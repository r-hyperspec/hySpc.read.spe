# hySpc.read.spe 0.0.x 2021-xx-xx

## Acknowledgements
The `hyperSpec` team gratefully acknowledges support from the Google Summer of Code program, which sponsored student Sang Truong during summer 2021.
Sang and the team carried out a significant overhaul of `hyperSpec` which led to this release.

## User-Visible Changes

* Moved functions from **hyperSpec** to **hySpc.read.spe**:
  - `hyperSpec::read.spe()` -> `hySpc.read.spe::read_spe()`
  - `hyperSpec::spe.showcalpoints()` -> `hySpc.read.spe::spe_show_calibration_points()`
  - `hyperSpec::.read.spe.xml()` -> `hySpc.read.spe::read_spe_xml()`
  - `hyperSpec::.read.spe.xml_string()` -> `hySpc.read.spe::read_spe_xml_string()`
  - `hyperSpec::.read.spe.header()` -> `hySpc.read.spe::read_spe_header()`
  
## New Features

* When new versions of the data are pushed to this repo, the newly created `.tar.gz` is automatically deployed to `pkg-repo`.
