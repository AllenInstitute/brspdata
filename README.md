# brspdata
A repository to hold the `brspdata` package, a package containing the normalized mRNA expression data used in the [Brainspan Atlas of the Developing Human](http://brainspan.org/) at the [Allen Institute](https://www.alleninstitute.org/).

The original data can be found [here](http://www.brainspan.org/static/download.html).

This package is intended to be used in conjunction with the `atlasplot` package.

## Install
To install the `brspdata` package it is recommended to use the
[`devtools`](https://github.com/hadley/devtools) package. This is a well trusted and reputable package from Hadley Wickham intended to streamline package development and installation. This alternate installation method is necessary due to the large size of this package.

**WARNING**: This package is large (>100 Mb); ensure that you have a
steady internet connection.

In the `R` command line perform the following commands
```
# Install devtools package
install.package("devtools")

# Install hbadata
devtools::install_github("edelsonc/brspdata")
```

## Licensing
The license this source code is release under is TBD.

## Additional Details
The source version of this package contains the code necessary to format the raw data downloaded from the [Allen Institute](http://human.brain-map.org/static/download) into the hosted `.rda` files. This code is located in `data-raw`. A `README.txt` is to follow.
