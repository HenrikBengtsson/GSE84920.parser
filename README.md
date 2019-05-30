# ramani - Access Ramani et al. Hi-C Data

This [R] package that provides an R API for working with the Ramani et al. Hi-C data sets, e.g. [GSM2254215](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2254215).

The package also provides a Bash script for splitting a HiC-count data file into chromosome-pair files.  This  `split.sh` script is located under `system.file("scripts", package = "ramani")`.


## Example

See `help("import_assignments", package = "ramani")` for an example.


## Install

This package is available on neither CRAN nor Bioconductor.  To install it, clone this repository and run:

```r
> install.packages(".", repos = NULL)
```

from within the `ramani/` package folder.


[R]: https://www.r-project.org/
