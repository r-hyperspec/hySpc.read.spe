## ----cleanup-hyperspec, include = FALSE---------------------------------------
# Clean up to ensure reproducible workspace ----------------------------------
rm(list = ls(all.names = TRUE))

## ----setup, include = FALSE-----------------------------------------------------------------------
# Packages -------------------------------------------------------------------
library(hySpc.read.spe)

# Functions ------------------------------------------------------------------
source("vignette-functions.R", encoding = "UTF-8")

# Settings -------------------------------------------------------------------
source("vignette-default-settings.R", encoding = "UTF-8")

# Temporary options ----------------------------------------------------------
# Change the value of this option in "vignette-default-settings.R"
show_reviewers_notes = getOption("show_reviewers_notes", TRUE)

## ----bib, echo = FALSE, paged.print = FALSE-------------------------------------------------------
dir.create("resources", showWarnings = FALSE)
knitr::write_bib(
  c("hyperSpec"),
  file = "resources/intro-pkg.bib"
)

## ---- echo = FALSE, results = "asis"--------------------------------------------------------------
res <- knitr::knit_child("list-of-vignettes.md", quiet = TRUE)
cat(res, sep = '\n')

# Example read file
HeNe <- system.file("extdata", "HeNe.SPE", package = "hySpc.read.spe")
read_spe(HeNe)
spe_showcalpoints(HeNe)

spe_format <- system.file("extdata", "spe_format_3.0.SPE", package = "hySpc.read.spe")
read_spe(spe_format)
read_spe(spe_format)

