# Package list ---------------------------------

# # #install {renv} if not already done so
# if (!require("renv")) renv::install("renv")

library(renv)

renv::deactivate(clean = TRUE)

# renv::activate()

#set repos for {renv} and disable download from MRAN:
options(repos = "https://cran.r-project.org",
        renv.config.repos.override = "https://cran.r-project.org",
        renv.config.mran.enabled = FALSE,
        renv.config.install.verbose = TRUE, # This will give more information in the console while installing the R packages, which may give more error details
        renv.config.connect.timeout = 5, # default is 20 seconds
        renv.config.connect.retry = 1, # default is 3 
        download.file.method = "curl" # curl / wininet
)

# https://rstudio.github.io/renv/reference/config.html#renv-config-cache-symlinks

Sys.setenv(RENV_DOWNLOAD_METHOD = "curl") # curl / wininet

# install purrr ----------------------------------------------------------

# #install {purrr} if not already done so
if (!require("purrr")) renv::install(
  "purrr")

library(purrr)

# list packages to download -----------------------------------------------

packages_to_download <- c(
  "tidyverse", #list your packages here
  "lubridate",
  "flextable",
  "readxl",
  "readr",
  "janitor",
  "here",
  "bookdown"
)

# check packages already installed vs. listed for install -----------------

packages_to_download %in% row.names(installed.packages())

row.names(installed.packages()) %in% packages_to_download

# create function to install packages -------------------------------------

install_vector_of_packages <- function(x) {
  if (!any(x %in% row.names(installed.packages()))) {  # Check if already loaded without installing
    # RE: renv::install() : it's a little less typing and can install packages from GitHub, Bioconductor, and more, not just CRAN
    # NB: If you use renv for multiple projects, you'll have multiple libraries, meaning that you'll often need to install the same package in multiple places.
    renv::install(x)
  }
}

# use purrr to map() function and install packages ------------------------

purrr::map(packages_to_download, install_vector_of_packages)

# Load packages --------------------------------------------------------------------

# Loop through packages_to_download and load all libraries
for (i in packages_to_download) {
  if (!require(i, character.only = TRUE)) {
    library(i, character.only = TRUE)
  }
}


# status ------------------------------------------------------------------

renv::status(
  sources = TRUE, #Boolean; check that each of the recorded packages have a known installation source? If a package has an unknown source, renv may be unable to restore it.
  cache = TRUE #Boolean; perform diagnostics on the global package cache? When TRUE, renv will validate that the packages installed into the cache are installed at the expected + proper locations, and validate the hashes used for those storage locations.
) 

# snapshot ----------------------------------------------------------------

# renv::snapshot()

# Project setup -----------------------------------------------------------

options(stringsAsFactors = FALSE)
options(scipen = 1, digits = 2)
ggplot2::theme_set(ggplot2::theme_minimal())


# Get the packages references
knitr::write_bib(c(.packages(), "bookdown"), here::here("packages.bib"))

# merge the zotero references and the packages references
cat(paste("% Automatically generated", Sys.time()), "\n% DO NOT EDIT",
    { readLines("references.bib") %>% #which .bib file is being used?
        paste(collapse = "\n") },
    { readLines("packages.bib") %>% 
        paste(collapse = "\n") },
    file = "biblio.bib",
    sep = "\n")


