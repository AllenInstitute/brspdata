#    Copyright (C) 2017 Allen Institute
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

#'Microarray RNA Expression Values for the Human Brain Span Atlas.
#'
#' Data frame containing the normalized RNA values for the genes studied via micro array sampling in the brain span altas. 
#'
#'@format A data frame with 8502744 rows and 4 variables:
#'\describe{
#'  \item{gene}{gene from the brain span atals }
#'  \item{brain_structure}{brain structure acronym}
#'  \item{value}{normalized log2 expression value}
#'  \item{age}{specimen age; (gene, brain_structure, age) are unique}
#'}
#'@source \url{"http://www.brainspan.org/static/download.html"}
#'
"datBRSP.gene.array"

#'RNAseq RNA Expression Values for the Human Brain Span Atlas.
#'
#'Data frame containing the normalized RNA values for the genes studied via RNAseq sampling in the brain span altas. 
#'
#'@format A data frame with 25051392 rows and 4 variables:
#'\describe{
#'  \item{gene}{gene from the brain span atals }
#'  \item{brain_structure}{brain structure acronym}
#'  \item{value}{normalized log2 expression value}
#'  \item{age}{specimen age; (gene, brain_structure, age) are unique}
#'}
#'@source \url{"http://www.brainspan.org/static/download.html"}
#'
"datBRSP.gene.rna"

#'Genes in the brain span atlas
#'
#'Vector of genes in the in the brain span atlas 
#'
#'@format A vector with 48466 
#'@source \url{"http://www.brainspan.org/static/download.html"}
#'
"genesBRSP"

