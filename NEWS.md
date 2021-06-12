# hySpc.read.spe 0.0.x 2021-xx-xx

## User-Visible Changes

* Moved functions from **hyperSpec** to **hySpc.read.spe**:
  - `hyperSpec::read.spe()` -> `hySpc.read.spe::read_spe()`
  - `hyperSpec::.read.spe.xml()` -> `hySpc.read.spe::read_spe_xml()`
  - `hyperSpec::.read.spe.xml_string()` -> `hySpc.read.spe::read_spe_xml_string()`
  - `hyperSpec::.read.spe.header()` -> `hySpc.read.spe::read_spe_header()`
  - `hyperSpec::spe.showcalpoints()` -> `hySpc.read.spe::spe.showcalpoints()`
## New Features
* When new versions of the data are pushed to this repo, the newly created `.tar.gz` is automatically deployed to `pkg-repo`.
