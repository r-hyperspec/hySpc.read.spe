# Reading of SPE files, produced by Princeton Instruments spectrometers
# File format version 2.5 (Sept. 2002)

# C. Beleites
# R. Kiselev
# July 2015


# Function -------------------------------------------------------------------

#' Import spectra from WinSpec SPE file
#'
#' Import function for WinSpec SPE files (file version up to 3.0).
#' The calibration data (polynomial and calibration data pairs) for x-axis
#' are automatically read and applied to the spectra. **Note** that
#' the y-calibration data structure is not extracted from the file
#' since it is not saved there by WinSpec and is always empty.
#'
#' @name read_spe
#' @rdname read_spe
#'
#'
#' @param file (character): Name of the SPE file to read data from.
#'
#' @param wl_units (character|`NULL`): Units of x-axis, e.g., `"px"`, `"nm"`,
#'        `"energy"`, `"raman"`, `...`. `NULL` means default units defined in
#'        a file.
#'
#'    Function [read_spe()] automatically checks if the x-calibration data are
#' available and uses them (if possible) to reconstruct the *wavelength* axis
#' in the selected units.
#'
#' @param acc2avg (logical): Whether to divide the actual data set by
#'        the number of accumulations, thus transforming *accumulated*
#'        spectra to *averaged* spectra.
#'        WinSpec does not do this automatically, so the  spectral
#'        intensity is always proportional to the number of accumulations.
#'        The flag `@data$averaged` is automatically set to `TRUE`.
#'
#' @param cts_sec (logical): Whether to divide the actual data set by the
#'        exposure time,  thus going to count per second unit.
#'
#' @param keys_hdr2data (character): Which metadata from the file header
#'        should be saved to the `@data` slot of a newly created
#'        `hyperSpec` object.
#'
#' @param xaxis (DEPRECATED): use `wl_units` instead.
#'
#'
#' @return [hyperSpec][hyperSpec::hyperSpec-class()] object.
#'
#'
#' @author R. Kiselev, C. Beleites
#'
#'
#' @tests testthat
#'
#' # File names
#'
#' # polystyrene <- "fileio\\spe\\polystyrene.SPE"
#' f_blut1 <- system.file(
#'   "extdata",
#'   "blut1.SPE",
#'   package = "hySpc.read.spe"
#' )
#'
#' f_spe3 <- system.file(
#'   "extdata",
#'   "spe_format_3.0.SPE",
#'   package = "hySpc.read.spe"
#' )
#'
#' # Unit tests for `read_spe` itself
#' test_that("read_spe correctly extracts spectral data from SPE file", {
#'   fname <- f_blut1
#'   expect_true(file.exists(fname))
#'   spc <- read_spe(fname)
#'
#'   # We check that specific values are correctly read from a particular file
#'   # This test is not generic and works with this and only this SPE file
#'   expect_equal(spc$spc[[5, 77]], 1484)
#'   expect_equal(spc$spc[[2, 811]], 606)
#'   expect_equal(spc@wavelength[621], 2618.027)
#' })
#'
#' test_that("read_spe() wl_units values", {
#'   fname <- f_blut1
#'
#'   expect_silent(spc_default <- read_spe(fname, wl_units = NULL))
#'   expect_silent(spc_px <- read_spe(fname, wl_units = "px"))
#'   expect_silent(spc_nm <- read_spe(fname, wl_units = "nm"))
#'
#'   expect_match(as.character(labels(spc_default)$.wavelength), "Raman")
#'   expect_match(as.character(labels(spc_nm)$.wavelength), "nm")
#'   expect_match(as.character(labels(spc_px)$.wavelength), "pixel")
#' })
#'
#' test_that("read_spe(): arg. 'xaxis' is deprecated. ", {
#'   fname <- f_blut1
#'
#'   expect_warning(spc_default_d <- read_spe(fname, xaxis = NULL), "deprecated")
#'   expect_silent(spc_default_ok <- read_spe(fname, wl_units = NULL))
#'
#'   expect_equal(spc_default_d, spc_default_ok)
#' })
#'
#'
#' test_that("read_spe detects an XML footer in SPE 3.0 file", {
#'   fname <- f_spe3
#'   expect_true(file.exists(fname))
#'   spc <- read_spe(fname)
#'
#'   expect_true("xml" %in% names(spc@data))
#' })
#'
#'
#' test_that(paste(
#'   "read_spe correctly parses XML footer with SPE 3.0 file and",
#'   "saves metadata in hyperSpec object"
#' ), {
#'   fname <- f_spe3
#'   expect_true(file.exists(fname))
#'   spc <- read_spe(fname)
#'
#'   expect_equal(
#'     attr(spc$xml$SpeFormat$DataFormat$DataBlock, "pixelFormat"),
#'     "MonochromeFloating32"
#'   )
#' })
#'
#'
#' # Unit tests for helper functions of `read_spe` (whose name starts with .)
#' test_that("read_spe_xml_string throws error on SPE format below v3.0", {
#'   fname <- f_blut1
#'   expect_true(file.exists(fname))
#'
#'   expect_error(read_spe_xml_string(fname), regexp = "*no XML*")
#' })
#'
#'
#' test_that("We can correctly read XML footer from SPE3.0 file", {
#'   expect_true(file.exists(f_spe3))
#'
#'   xml_file <- paste0(f_spe3, "_metadata.xml")
#'   actual_xml_footer <- read_spe_xml_string(f_spe3)
#'   expected_xml_footer <- readChar(xml_file, file.info(xml_file)$size)
#'   expect_equal(actual_xml_footer, expected_xml_footer)
#' })
#'
#'
#' test_that(paste(
#'   "read_spe_xml correctly parses the XML footer and",
#'   " can extract the actual data"
#' ), {
#'   expect_true(file.exists(f_spe3))
#'
#'   # Read XML footer and convert it to R list
#'   x <- read_spe_xml(f_spe3)
#'   expect_true(is.list(x))
#'
#'   # Check values of some elements
#'   expect_true(is.list(x))
#'   expect_true("SpeFormat" %in% names(x))
#'
#'   # Check file format version and namespace URL
#'   expect_equal(attr(x$SpeFormat, "version"), "3.0")
#'   expect_equal(
#'     attr(x$SpeFormat, "xmlns"),
#'     "http://www.princetoninstruments.com/spe/2009"
#'   )
#'
#'   # Check that some children are present
#'   expect_true("DataFormat" %in% names(x$SpeFormat))
#'   expect_true("Calibrations" %in% names(x$SpeFormat))
#'   expect_true("DataHistories" %in% names(x$SpeFormat))
#'   expect_true("GeneralInformation" %in% names(x$SpeFormat))
#'
#'   # Check that we can correctly extract file creation date
#'   info <- x$SpeFormat$GeneralInformation$FileInformation
#'   expect_equal(attr(info, "created"), "2018-01-26T16:31:09.0979397+01:00")
#'
#'   # Check that we can correctly extract pixel format and laser line
#'   expect_equal(
#'     attr(x$SpeFormat$DataFormat$DataBlock, "pixelFormat"),
#'     "MonochromeFloating32"
#'   )
#'   expect_equal(
#'     attr(x$SpeFormat$Calibrations$WavelengthMapping, "laserLine"),
#'     "785"
#'   )
#' })
#'
#'
#' @importFrom graphics title
#' @importFrom methods new
#'
#' @export
#'
#' @examples
#' suppressPackageStartupMessages({
#'   library(hySpc.read.spe)
#' })
#'
#' # Example 1
#' f_blut1 <- system.file("extdata", "blut1.SPE", package = "hySpc.read.spe")
#' spc_blut1 <- read_spe(f_blut1)
#'
#' spc_blut1
#'
#' plot(spc_blut1)
#'
#'
#' # Example 2
#' f_spe3 <- system.file(
#'   "extdata", "spe_format_3.0.SPE",
#'   package = "hySpc.read.spe"
#' )
#' spc_spe3 <- read_spe(f_spe3)
#'
#' spc_spe3
#'
#' plot(spc_spe3)
#'
read_spe <- function(file, wl_units = NULL, acc2avg = FALSE, cts_sec = FALSE,
                     keys_hdr2data = c(
                       "exposure_sec",
                       "LaserWavelen",
                       "accumulCount",
                       "numFrames",
                       "darkSubtracted"
                     ),
                     xaxis = "DEPRECATED") {

  if (is.null(xaxis) || (xaxis != "DEPRECATED")) {
    warning("Argument 'xaxis' is deprecated. Use 'wl_units' instead. ")
    wl_units <- xaxis
  }


  hdr <- read_spe_header(file)

  # This is the size of one data point in bytes.
  # WinSpec uses 2 bytes or 4 bytes only.
  data_size <- ifelse(hdr$datatype > 2, 2L, 4L)
  data_chunk_size <- hdr$xdim * hdr$ydim * hdr$numFrames * data_size

  # Read the part of file that contains actual experimental data
  raw_data <- readBin(file, "raw", data_chunk_size + 4100, 1)[-(1:4100)]

  # Convert raw spectral data according to the datatype defined in the header
  spc <- switch(hdr$datatype + 1,
    readBin(raw_data, "double", length(raw_data) / 4, 4), # float
    readBin(raw_data, "integer", length(raw_data) / 4, 4, signed = TRUE), # long
    readBin(raw_data, "integer", length(raw_data) / 2, 2, signed = TRUE), # int
    readBin(raw_data, "integer", length(raw_data) / 2, 2, signed = FALSE) # uint
  )

  # Create a structured data.frame that accommodates spectral data
  dim(spc) <- c(hdr$xdim, hdr$ydim * hdr$numFrames)
  extra_data <- data.frame(
    px.y = rep(seq_len(hdr$ydim), hdr$numFrames),
    frame = rep(seq_len(hdr$numFrames), each = hdr$ydim)
  )

  # Extract selected items from the header.
  # They will go to a new hyperSpec object
  hdr2data <- hdr[keys_hdr2data]
  if (length(hdr2data > 0)) {
    extra_data <- cbind(extra_data, hdr2data)
  }

  # Create hyperSpec object
  spc <- new("hyperSpec",
    spc = t(spc),
    data = extra_data,
    labels = list(spc = "counts", .wavelength = "pixel number")
  )

  # For SPE 3.0 and above we need to read the XML header
  if (hdr$fileFormatVer >= 3.0) {
    spc@data$xml <- read_spe_xml(file)
  }

  # Check if we should use display units specified in the SPE file
  if (is.null(wl_units)) {
    wl_units <- .wl_fix_unit_name(hdr$xCalDisplayUnit)
  }

  # Create a new x-axis, if required
  wl_units <- .wl_fix_unit_name(wl_units)
  if (wl_units == "px") {
    return(.spc_io_postprocess_optional(spc, file))
  }


  if (!hdr$xCalValid) {
    warning("The calibration is NOT valid")
  }

  # Recreate calibration function
  polyorder <- hdr$xCalPolyOrder
  coeffs <- hdr$xCalPolCoeffs[seq(polyorder + 1)]

  vM <- vanderMonde(spc@wavelength, polyorder)

  # Check if we have laser wavelength
  if (hdr$LaserWavelen < 10) {
    hdr$LaserWavelen <- NULL
  }

  # Perform conversion
  spc@wavelength <- wl_convert_units(
    from   = .wl_fix_unit_name(hdr$xCalPolyUnit),
    to     = wl_units,
    x      = as.numeric(vM %*% coeffs),
    ref_wl = hdr$LaserWavelen
  )

  spc@label$.wavelength <-
    switch(wl_units,
      nm    = expression("Wavelength, nm"),
      invcm = expression(tilde(nu) / cm^-1),
      ev    = expression("Energy / eV"),
      freq  = expression(nu / THz),
      raman = expression(Raman ~ shift / cm^-1)
    )
  if (acc2avg) {
    spc <- spc / hdr$accumulCount
    spc@data$averaged <- TRUE
  }
  if (cts_sec) {
    spc <- spc / hdr$exposure_sec
    spc@label$spc <- expression("counts / s")
  }

  ## consistent file import behavior across import functions
  .spc_io_postprocess_optional(spc, file)
}


# Helper functions -----------------------------------------------------------

#' Read XML footer from SPE file format version 3.0
#'
#' The new SPE file format, introduced in 2012, was designed to be backwards
#' compatible with the previous format 2.5. The most prominent change is the
#' new plain text XML footer holding vast experimental metadata that gets
#' attached at the end of the file. Thus, the file contains 3 blocks:
#' a 4100-bytes long binary header, a chunk with spectral data, and the XML
#' footer.
#' This function retrieves the XML footer converted to R list, and throws error
#' if it is not available.
#' The file format specification is available at Princeton Instruments FTP
#' server under name 'SPE 3.0 File Format Specification'.
#'
#' This function relies on R package \pkg{xml2} to work correctly.
#'
#' @param file Path to SPE file.
#'
#' @return XML data from the file converted to R list.
#'
#' @importFrom xml2 as_list read_xml
#'
#' @noRd
read_spe_xml <- function(file) {
  as_list(read_xml(read_spe_xml_string(file)))
}


#' read_spe_xml_string
#'
#' Read XML footer from SPE file format version 3.0 and return it as a long
#' string for subsequent parsing. Basically the purpose of this function is
#' to check that the file format version is 3.0 or above, and to find and
#' read the correct part of this file.
#'
#' @param file Path to SPE file.
#'
#' @return string containing XML footer
#'
#' @noRd

read_spe_xml_string <- function(file) {
  hdr <- read_spe_header(file)

  if (hdr$fileFormatVer < 3.0) {
    stop(paste(
      "This SPE file contains no XML data: file format version",
      round(hdr$fileFormatVer, digits = 3), "< 3.0"
    ))
  }

  data_size <- ifelse(hdr$datatype > 2, 2L, 4L)
  data_chunk_size <- hdr$xdim * hdr$ydim * hdr$numFrames * data_size

  # Read the part of file that contains actual experimental data
  i_data <- -(1:(4100 + data_chunk_size))
  raw_bytes <- readBin(file, "raw", file.info(file)$size, 1)[i_data]
  readChar(raw_bytes, length(raw_bytes))
}


# @describeIn read_spe
#
#' Read only header of a WinSpec SPE file (version 2.5)
#'
#' @return hdr list with `key=value` pairs
#'
#' @noRd

read_spe_header <- function(file) {
  # Read the 4100-byte long binary header from the SPE file and parse it

  # Load the header
  raw_data <- readBin(file, "raw", 4100, 1)

  # Extract some items from the 4100 bytes-long file header
  hdr <- list(
    hwVersion       = readBin(raw_data[1:2], "integer", 1, 2, signed = TRUE), # uint16
    xDimDet         = readBin(raw_data[7:8], "integer", 1, 2, signed = FALSE), # uint16
    mode            = readBin(raw_data[9:10], "integer", 1, 2, signed = TRUE), # uint16
    exposure_sec    = readBin(raw_data[11:14], "double", 1, 4), # float32
    vChipXDim       = readBin(raw_data[15:16], "integer", 1, 2, signed = TRUE), # int8
    vChipYDim       = readBin(raw_data[17:18], "integer", 1, 2, signed = TRUE), # int8
    yDimDet         = readBin(raw_data[19:20], "integer", 1, 2, signed = FALSE), # uint16
    date            = readBin(raw_data[21:30], "character", 1, 10), # char
    detTemperature  = readBin(raw_data[37:40], "double", 1, 4), # float32
    xdim            = readBin(raw_data[43:44], "integer", 1, 2, signed = FALSE), # uint16
    shutterMode     = readBin(raw_data[51:52], "integer", 1, 2, signed = FALSE), # uint16
    specCenterWlNm  = readBin(raw_data[73:76], "double", 1, 4), # float32
    datatype        = readBin(raw_data[109:110], "integer", 1, 2, signed = TRUE), # int8
    darkSubtracted  = readBin(raw_data[151:152], "integer", 1, 2, signed = FALSE), # int8
    timeLocal       = readBin(raw_data[173:179], "character", 1, 7), # char
    timeUTC         = readBin(raw_data[180:186], "character", 1, 7), # char
    gain            = readBin(raw_data[199:200], "integer", 1, 2, signed = FALSE), # uint16
    comments        = readBin(raw_data[201:600], "character", 1, 400), # char
    ydim            = readBin(raw_data[657:658], "integer", 1, 2, signed = FALSE), # uint16
    accumulCount    = readBin(raw_data[669:672], "integer", 1, 4), # uint32
    readoutTime     = readBin(raw_data[673:676], "double", 1, 4), # float32
    swVersion       = readBin(raw_data[688:704], "character", 1, 16), # char
    kinTrigMode     = readBin(raw_data[725:726], "integer", 1, 2, signed = TRUE), # int16
    expRepeatCount  = readBin(raw_data[1419:1422], "integer", 1, 4, signed = TRUE), # int32
    expAccumCount   = readBin(raw_data[1423:1426], "integer", 1, 4, signed = TRUE), # int32
    hwAccumFlag     = readBin(raw_data[1433:1434], "integer", 1, 2, signed = TRUE), # int16
    cosmicApplied   = readBin(raw_data[1439:1440], "integer", 1, 2, signed = TRUE), # int16
    cosmicType      = readBin(raw_data[1441:1442], "integer", 1, 2, signed = TRUE), # int16
    numFrames       = readBin(raw_data[1447:1450], "integer", 1, 4), # int32
    shutterType     = readBin(raw_data[1475:1476], "integer", 1, 2, signed = TRUE), # int16
    readoutMode     = readBin(raw_data[1481:1482], "integer", 1, 2, signed = TRUE), # int16
    kinWindowSize   = readBin(raw_data[1483:1484], "integer", 1, 2, signed = TRUE), # int16
    clkSpeed        = readBin(raw_data[1485:1486], "integer", 1, 2, signed = TRUE), # int16
    computerIface   = readBin(raw_data[1487:1488], "integer", 1, 2, signed = TRUE), # int16
    fileFormatVer   = readBin(raw_data[1993:1996], "double", 1, 4, signed = TRUE), # float32

    # X Calibration Structure
    xCalOffset      = readBin(raw_data[3001:3008], "double", 1, 8, signed = TRUE), # float64
    xCalFactor      = readBin(raw_data[3009:3016], "double", 1, 8, signed = TRUE), # float64
    xCalDisplayUnit = readBin(raw_data[3017], "integer", 1, 1, signed = FALSE), # uint8
    xCalValid       = readBin(raw_data[3099], "integer", 1, 1, signed = FALSE), # uint8
    xCalInputUnit   = readBin(raw_data[3100], "integer", 1, 1, signed = FALSE), # uint8
    xCalPolyUnit    = readBin(raw_data[3101], "integer", 1, 1, signed = FALSE), # uint8
    xCalPolyOrder   = readBin(raw_data[3102], "integer", 1, 1, signed = FALSE), # uint8
    xCalPointCount  = readBin(raw_data[3103], "integer", 1, 1, signed = FALSE), # uint8
    xCalPxPos       = readBin(raw_data[3104:3183], "double", 10, 8, signed = TRUE), # float64
    xCalValues      = readBin(raw_data[3184:3263], "double", 10, 8, signed = TRUE), # float64
    xCalPolCoeffs   = readBin(raw_data[3264:3311], "double", 6, 8, signed = TRUE), # float64
    LaserWavelen    = readBin(raw_data[3312:3319], "double", 1, 8, signed = TRUE) # float64
  )

  # Convert magic numbers into human-readable unit strings
  spe_units <- c("pixel", "pixel", "data", "user units", "nm", "cm-1", "Raman shift")
  hdr$xCalDisplayUnit <- spe_units[hdr$xCalDisplayUnit + 1]
  hdr$xCalInputUnit <- spe_units[hdr$xCalInputUnit + 1]
  hdr$xCalPolyUnit <- spe_units[hdr$xCalPolyUnit + 1]

  return(hdr)
}
