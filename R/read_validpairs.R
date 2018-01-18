#' Read Valid-Pairs Files
#'
#' A 'VALIDPAIRS' file is for all valid pairs in each library.
#'
#' @param file Pathname to a \file{*.validPairs.txt(.gz)} file.
#'
#' @param ... Additional arguments passed to [readr::read_tsv()].
#'
#' @return A data.frame with 17 columns:
#'  \item{`???`}{???}
#'
#' @details
#' The description here are adopted from [GSE84920_README.txt](ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE84nnn/GSE84920/suppl/GSE84920\%5FREADME\%2Etxt).
#' It is sparse on what 'VALIDPAIRS' files contain, but says that they
#' "VALIDPAIRS files are for all valid pairs in each library.
#' BEDS were paired based on identical read name and simultaneously
#' associated with the proper cellular index. VALIDPAIRS also include the
#' result of bedtools closest, to determine the closest DpnII restriction
#' site and distance for each mate."
#'
#' @section Validation:
#' The `read_validpairs()` function does some basic validation on the
#' values read.
#'
#' @examples
#' path <- system.file("extdata", package = "ramani")
#' file <- file.path(path, "GSM2254215_ML1.rows=1-1000.validPairs.txt.gz")
#' data <- read_validpairs(file)
#' print(data)
#' 
#' @importFrom readr read_tsv
#' @export
read_validpairs <- function(file, ...) {
  data <- read_tsv(file, col_names = FALSE, ...)
  ## Default Col1-17
  ## colnames(data) <- sprintf("Col%d", seq_len(ncol(data)))
##  colnames(data) <- c(
##    "hg19_frac", "mm10_frac", "hg19_count", "mm10_count", "hg19mm10_count",
##    "pair_count",
##    "barcode1_inner", "barcode2_outer",
##    "is_observed",
##    "Col10",
##    "dpnii_1x", "dpnii_2x", "dpnii_3x", "dpnii_4x",
##    "cistrans_ratio",
##    "hela_allele_frac",
##    "celltype"
##  )
  
  ## Validation
  with(data, stopifnot(
    all(X2 >= 0), all(X3 >= 0),
    all(X5 >= 0), all(X6 >= 0),
    all(X8 >= 0), all(X9 >= 0),
    all(X10 %in% c("+", "-")),
    all(X11 %in% c("+", "-")),
    all(nchar(X12) == 8L),
    all(nchar(X13) == 8L),
    all(X15 >= 0), all(X17 >= 0)
  ))

  data
}
