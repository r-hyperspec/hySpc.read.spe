# Function -------------------------------------------------------------------

#' Plot spectra with calibration points in WinSpec SPE file
#'
#' Plot the WinSpec SPE file (version 2.5) and show the calibration points
#' stored inside of it (x-axis calibration).
#'
#' @inheritParams read_spe
#'
#' @export
#' @examples
#' suppressPackageStartupMessages({
#'   library(hySpc.read.spe)
#' })
#'
#' # Example 1
#' blut1 <- system.file("extdata", "blut1.SPE", package = "hySpc.read.spe")
#' spe_plot_calibration_points(blut1)
#'
#'
#' # Example 2: expect warnings as calibration data is not present.
#' spe3 <- system.file(
#'   "extdata", "spe_format_3.0.SPE",
#'   package = "hySpc.read.spe"
#' )
#' spe_plot_calibration_points(spe3)
spe_plot_calibration_points <- function(file,
                                        wl_units = NULL,
                                        acc2avg = FALSE,
                                        cts_sec = FALSE,
                                        xaxis = "DEPRECATED") {
  if (is.null(xaxis) || (xaxis != "DEPRECATED")) {
    warning("Argument 'xaxis' is deprecated. Use 'wl_units' instead. ")
    wl_units <- xaxis
  }

  hdr <- read_spe_header(file)

  # Check if we should use display units specified in the SPE file
  if (is.null(wl_units)) {
    wl_units <- .wl_fix_unit_name(hdr$xCalDisplayUnit)
  }

  wl_units <- .wl_fix_unit_name(wl_units)

  if (wl_units == "px") {
    wl_units <- hdr$xCalDisplayUnit
    warning("Cannot show calibration data in pixels")
  }

  # Open file, make plot and mark position of all peaks stored inside the file
  # in the x-calibration structure
  spc <- read_spe(file, wl_units, acc2avg, cts_sec)
  rng <- max(spc) - min(spc)
  ylims <- c(min(spc), max(spc) + 0.3 * rng)

  if (dim(spc@data$spc)[1] > 1) {
    plot(spc, plot.args = list(ylim = (ylims)), "spcprctl5")
  } else {
    plot(spc, plot.args = list(ylim = (ylims)))
  }
  title(basename(file))


  if (hdr$xCalPointCount == 0) {
    warning("No calibration data! Nothing to show")
    return(invisible(NULL))
  }

  markpeak(spc, wl_convert_units(
    from   = hdr$xCalInputUnit,
    to     = .wl_fix_unit_name(wl_units),
    x      = hdr$xCalValues,
    ref_wl = hdr$LaserWavelen
  ))
}

# Unit tests -----------------------------------------------------------------

hySpc.testthat::test(spe_plot_calibration_points) <- function() {

  # File names ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  f_blut1 <- system.file("extdata", "blut1.SPE", package = "hySpc.read.spe")
  f_spe3 <- system.file("extdata", "spe_format_3.0.SPE", package = "hySpc.read.spe")

  # Visual tests ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  test_that("result with callibration data", {
    vdiffr::expect_doppelganger(
      "calibration-data-present--default",
      spe_plot_calibration_points(f_blut1)
    )

    vdiffr::expect_doppelganger(
      "calibration-data-present--wl_units-nm",
      spe_plot_calibration_points(f_blut1, wl_units = "nm")
    )
  })


  test_that("no callibration data", {
    vdiffr::expect_doppelganger(
      "calibration-points-missing--default",
      expect_warning(
        expect_warning(
          spe_plot_calibration_points(f_spe3),
          "No calibration data!" # Warning 2
        ),
        "Cannot show calibration data in pixels" # Warning 1
      )
    )
  })

  test_that("spe_plot_calibration_points(): arg. 'xaxis' is deprecated. ", {
    expect_warning(
      vdiffr::expect_doppelganger(
        "calibration-data-present--default", # The same name as above
        spe_plot_calibration_points(f_blut1, xaxis = NULL)
      ),
      "deprecated"
    )
  })
}
