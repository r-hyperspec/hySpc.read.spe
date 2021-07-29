#' Plot spectra with calibration points in WinSpec SPE file
#'
#' Plot the WinSpec SPE file (version 2.5) and show the calibration points
#' stored inside of it (x-axis calibration).
#'
#' @inheritParams read_spe
#'
#' @export
#'
spe_showcalpoints <- function(file,
                                        xaxis = "file",
                                        acc2avg = FALSE,
                                        cts_sec = FALSE) {
  hdr <- read_spe_header(file)
  xaxis <- .wl_fix_unit_name(xaxis)

  # Check if we should use display units specified in the SPE file
  if (xaxis == "file") {
    xaxis <- .wl_fix_unit_name(hdr$xCalDisplayUnit)
  }
  if (xaxis == "px") {
    xaxis <- hdr$xCalDisplayUnit
    warning("Cannot show calibration data in pixels")
  }

  # Open file, make plot and mark position of all peaks stored inside the file
  # in the x-calibration structure
  spc <- read_spe(file, xaxis, acc2avg, cts_sec)
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
    return("")
  }

  markpeak(spc, wl_convert_units(
    from   = hdr$xCalInputUnit,
    to     = .wl_fix_unit_name(xaxis),
    x      = hdr$xCalValues,
    ref_wl = hdr$LaserWavelen
  ))
}
