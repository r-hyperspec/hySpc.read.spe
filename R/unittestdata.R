#' package internal unit test data
#' @include read_spe.R
#' @noRd
skip_if_not_fileio_available <- function() {
  testthat::skip_if_not(file.exists("fileio"), message = "file import test files not installed")
}
