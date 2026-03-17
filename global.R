# For loading packages and necessary data files

options(repos = c(CRAN = "https://cran.rstudio.com"))

# List of required packages
required_packages <- c("shiny","shinyjs", "rmarkdown", "markdown", "bslib")

# Load packages quietly
invisible(lapply(required_packages, library, character.only = TRUE))




