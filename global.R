# For loading packages and necessary data files

options(repos = c(CRAN = "https://cran.rstudio.com"))

# List of required packages
required_packages <- c(
  "leaflet", "shiny", "rmarkdown", "markdown", "shinydashboard", "shinyjs", "shinyBS", "lubridate",
  "shinycssloaders", "tidyverse", "bslib", "leafem", "glue", "purrr", "opticut", "readr", "utils",
  "terra", "stringr", "DT", "httr", "RColorBrewer", "sf", "tools", "viridis", "knitr", "ggplot2", "stars"
)

# Load packages quietly
invisible(lapply(required_packages, library, character.only = TRUE))




