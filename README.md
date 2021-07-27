<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version-last-release/hySpc.read.spe)](https://cran.r-project.org/package=hySpc.read.spe)
[![R-CMD-check](https://github.com/r-hyperspec/hySpc.read.spe/workflows/R-CMD-check/badge.svg)](https://github.com/r-hyperspec/hySpc.read.spe/actions)
![Website (pkgdown)](https://github.com/r-hyperspec/hySpc.read.spe/workflows/Website%20(pkgdown)/badge.svg)
[![Codecov](https://codecov.io/gh/r-hyperspec/hySpc.read.spe/branch/develop/graph/badge.svg)](https://codecov.io/gh/r-hyperspec/hySpc.read.spe?branch=develop)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!--[![metacran downloads](https://cranlogs.r-pkg.org/badges/grand-total/hySpc.read.spe)](https://cran.r-project.org/package=hySpc.read.spe)-->
<!--[![metacran downloads](https://cranlogs.r-pkg.org/badges/hySpc.read.spe)](https://cran.r-project.org/package=hySpc.read.spe)-->
<!-- badges: end -->



# R Package **hySpc.read.spe**

[**R**](https://www.r-project.org/) package **hySpc.read.spe** is a member of the [**`r-hyperspec`**](https://r-hyperspec.github.io/) packages family, which imports a number of file formats produced by Princeton Instruments spectrometers.
    The imported data are returned as hyperSpec objects.

<!-- ---------------------------------------------------------------------- -->

## Documentation

There are two versions of **hySpc.read.spe** online documentation:

a. for the [released version](https://r-hyperspec.github.io/hySpc.read.spe/) of package,  
b. for the [development version](https://r-hyperspec.github.io/hySpc.read.spe/dev/) of package.

The documentation of the other **`r-hyperspec`** family packages can be found at [r-hyperspec.github.io](https://r-hyperspec.github.io/).

<!-- ---------------------------------------------------------------------- -->

## Installation

### Install from CRAN

You can install the released version of **hySpc.read.spe** from [CRAN](https://cran.r-project.org/package=hySpc.read.spe) with:

```r
install.packages("hySpc.read.spe")
```


### Install from GitHub

You can install the development version of the package from [GitHub](https://github.com/r-hyperspec/hySpc.read.spe):

```r
if (!require(remotes)) {install.packages("remotes")}
remotes::install_github("r-hyperspec/hySpc.read.spe")
```

**NOTE 1:**
Usually, "Windows" users need to download, install and properly configure **Rtools** (see [these instructions](https://cran.r-project.org/bin/windows/Rtools/)) to make the code above work.

**NOTE 2:**
This method will **not** install package's documentation (help pages and vignettes) into your computer.
So you can either use the [online documentation](https://r-hyperspec.github.io/) or build the package from source (see the next section).


### Install from Source

1. From the **hySpc.read.spe**'s GitHub [repository](https://github.com/r-hyperspec/hySpc.read.spe):
    - If you use Git, `git clone` the branch of interest.
      You may need to fork it before cloning.
    - Or just chose the branch of interest (1 in Figure below), download a ZIP archive with the code (2, 3) and unzip it on your computer.  
![image](https://user-images.githubusercontent.com/12725868/89338263-ffa1dd00-d6a4-11ea-94c2-fa36ee026691.png)

2. Open the downloaded directory in RStudio (preferably, as an RStudio project).
    - The code below works correctly only if your current working directory coincides with the root of the repository, i.e., if it is in the directory that contains file `README.md`.
    - If you open RStudio project correctly (e.g., by clicking `project.Rproj` icon ![image](https://user-images.githubusercontent.com/12725868/89340903-26621280-d6a9-11ea-8299-0ec5e9cf7e3e.png) in the directory), then the working directory is set correctly by default.

3. In RStudio 'Console' window, run the code (provided below) to:
    a. Install packages **remotes** and **devtools**.
    b. Install **hySpc.read.spe**'s dependencies.
    c. Create **hySpc.read.spe**'s documentation.
    d. Install package **hySpc.read.spe**.

```r
# Do not abort installation even if some packages are not available
Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS = "true")

# Install packages remotes and devtools
install.packages(c("remotes", "devtools"))

# Install hySpc.read.spe's dependencies
remotes::install_deps(dependencies = TRUE)

# Create hySpc.read.spe's documentation
devtools::document()

# Install package hySpc.read.spe
devtools::install(build_vignettes = TRUE)
```

**NOTE 1:**
Usually, "Windows" users need to download, install and properly configure **Rtools** (see [these instructions](https://cran.r-project.org/bin/windows/Rtools/)) to make the code above work.
