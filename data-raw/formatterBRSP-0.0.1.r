#------------------------------------------------------------------------------#
#----------------------------FUNCTION DEFINITIONS------------------------------#
#------------------------------------------------------------------------------#

#' Tidy the human brain atlas data. The data is available for download here:
#' http://human.brain-map.org/static/download. The data comes as 6 zip files,
#' one for each donor. To use this script, put all 6 directories in a base
#' directory like such
#' 
#' dirHBA
#'      |_ Donor1
#'      |_ Donor2
#'      |_ ...
#' 
#' The `path` is then the path to dirHBA.
#' 
#' 
#' 
#' @param path File path to the base directory as depicted above
#' @return Create a new directory in the current working directory `resultFrameCollapse` This directoy contains the tidy version of each donors brain
#' @examples
#' dirHBA <- "/my/very/cool/file/system/dirHBA"
#' # aggregate to max and don't collapse
#' formatterHBA(dirHBA)
formatterBRSP <- function(path){
    
    # create a list of files to iterate through
    pathBRSP <- as.list(list.dirs(path, recursive = FALSE))
    
    # format each file and save to a csv labeled 1-n for reading later
    for (brain in pathBRSP) {
        print("Begin Formatting")
        print(brain)
        resultFrame <- .formatOneBRSP(brain)
        print("Saving results")

        # write to csv
        name <- strsplit(brain, '/')[[1]]
        name <- name[[length(name)]]
        readr::write_csv(resultFrame,
                         paste("./resultFrameBRSP/resultFrame",
                               name, ".csv", sep=""))

        print(paste("Done saving", name))
    }
}

#------------------------------HELPER FUNCTIONS--------------------------------#

.createBRSPMatrix <- function(mpath, ppath, apath){

    # load the microexpression data...suppress to hide parse info
    suppressMessages(MicroExp <- readr::read_csv(mpath, col_names = FALSE))
    suppressMessages(AnSamp <- readr::read_csv(apath))
    suppressMessages(Probes <- readr::read_csv(ppath)[c("row_num", "gene_symbol")])

    # Change first column name for joining
    colnames(MicroExp)[1] <- "row_num"

    if (all(MicroExp$row_num == Probes$row_num)) {

        # this is to ensure that the order of the probe ids is the same in both
        # frames. Checking is O(n), while joining is O(n^2)
        rowProbeID <- Probes$row_num
        rowGeneGroup <- Probes$gene_symbol
        MicroExp <- MicroExp[c(-1)]

    } else {
        # in the event that they are ordered differently we need to join on the
        # identifier
        warning("probe_id variable from micro-array expression csv and probe csv do not have the same order\n\nThis implies gene order may have changed")
        MicroExp <- dplyr::inner_join(
            Probes, MicroExp, by="row_num")

        rowProbeID <- MicroExp$row_num
        rowGeneGroup <- MicroExp$gene_symbol
        MicroExp <- MicroExp[c(-1,-2,-3)]
    }

    colnames(MicroExp) <- paste(AnSamp$structure_acronym, AnSamp$age)
    MicroExp <- cbind(probe_name = rowProbeID,
                      gene = rowGeneGroup,
                      MicroExp)

    return(list(dat = MicroExp))
}

    
.formatOneBRSP <- function(folder){

    # format the paths appropriately to read the csvs
    micro_path <- paste(folder,"expression_matrix.csv",sep="/")
    probe_path <- paste(folder, "rows_metadata.csv", sep="/")
    annot_path <- paste(folder, "columns_metadata.csv", sep="/")

    # format the dataframe correctly and retun for aggregating
    print("Begin reading in data")
    MicroExp <- .createBRSPMatrix(micro_path, probe_path, annot_path)
    print("Data loaded")
    gc() # reallocate free memory

    # create unique column ids...for melting later
    n_col <- ncol(MicroExp$dat) - 2
    n_pad <- nchar(as.character(n_col))
    id_pad <- stringr::str_pad(as.character(1:n_col), n_pad, pad="0")
    col_ids <- paste(colnames(MicroExp$dat)[c(-1,-2)], id_pad, sep="")
    colnames(MicroExp$dat)[c(-1,-2)] <- col_ids

    # collapse rows -- this is a time intensive step

    # format for use in WGCNA collapseRow
    MicroExp$group <- MicroExp$dat$gene
    MicroExp$id <- MicroExp$dat$probe_name
    MicroExp$struct <- colnames(MicroExp$dat)[c(-1,-2)]
    MicroExp$dat <- as.matrix(MicroExp$dat[c(-1,-2)])
    rownames(MicroExp$dat) <- MicroExp$id

    gc()  # this may make the machine return memory

    # collapse rows to get a single representative of each gene
    print("Collapsing Rows")
    MicroCollapse <- WGCNA::collapseRows(
        MicroExp$dat, rowGroup = MicroExp$group, rowID = MicroExp$id)
    print("Done collapsing")

    # reformat to a dataframe and create a gene variable before reshaping
    # this is to facilitate joining the gene on the selected probe
    resultFrame <- as.data.frame(MicroCollapse$datETcollapsed)
    resultFrame$gene <- rownames(resultFrame)
    rownames(resultFrame) <- c(1:nrow(resultFrame))
    resultFrame <- reshape2::melt(resultFrame, id.vars=c("gene"))

    # Finish final formatting details and return
    structs <- as.character(resultFrame$variable)
    resultFrame$variable <- factor(substr(structs, 1, nchar(structs) - n_pad))
    
    print(paste("dataframe dimensions:", dim(resultFrame)))
    print("Formatting complete")
    return(resultFrame)
}


#------------------------------------------------------------------------------#
#---------------------------------MAIN SCRIPT----------------------------------#
#------------------------------------------------------------------------------#

# This script is meant to reformat the data found on the allen institutes human
# brain atlas form into tidy (http://vita.had.co.nz/papers/tidy-data.html) data.
# It accomplishes this goal by first collapsing data on gene using collapseRows
# in the WGCNA package. Data is then transformed into long format so that each
# row is an ID and an observation.

# folder <- "C:/Users/cygwin/home/charlese/dir_BRSP/exon_array_matrix_csv//"

# reset dirHBA to point to base directory
dirBRSP <- "C:/Users/cygwin/home/charlese/dir_BRSP"
formatterBRSP(dirBRSP)
