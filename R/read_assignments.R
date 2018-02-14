#' Read Assignments Files
#'
#' An 'assignments' file ...
#'
#' @param file Pathname to a \file{*_assignments.txt(.gz)} file.
#'
#' @param columns (optional) Name of columns to be read.
#'
#' @param ... Additional arguments passed to [readr::read_tsv()].
#'
#' @return A data.frame with four columns:
#'  \item{`readname`}{...}
#'  \item{`left_inner_barcode`}{...}
#'  \item{`right_inner_barcode`}{...}
#'  \item{`outer_barcode`}{...}
#'
#' @details
#' The description here are adopted from [GSE84920_README.txt](ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE84nnn/GSE84920/suppl/GSE84920\%5FREADME\%2Etxt).
#' It is sparse on what 'assignments' files are, but it says:
#' "TXT \[ed. we think they meant ASSIGNMENTS\] files represent the barcode
#' associations for each sequenced read where two barcodes were identifiable.
#' The format is `READNAME\\tLEFT_INNER_BARCODE\\tRIGHT_INNER_BARCODE\\tOUTER_BARCODE`,
#' where `LEFT_INNER_BARCODE` and `RIGHT_INNER_BARCODE` should match for
#' valid reads.  We include all reads here, but note that for all analyses
#' presented in the associated paper, all reads where these barcodes do not
#' match were discarded."
#'
#' @section Validation:
#' The `read_assignments()` function does some basic validation on the
#' values read.
#'
#' @examples
#' path <- system.file("extdata", package = "ramani")
#' file <- file.path(path, "GSM2254215_ML1.rows=1-1000_assignments.txt.gz")
#' data <- read_assignments(file)
#' print(data)
#' 
#' @importFrom readr read_tsv cols col_character col_skip
#' @export
read_assignments <- function(file, columns = NULL, ...) {
  col_types <- cols(
    readname = col_character(),
    left_inner_barcode = col_character(),
    right_inner_barcode = col_character(),
    outer_barcode = col_character()
  )

  if (!is.null(columns)) {
    stopifnot(all(columns %in% names(col_types)))
    for (name in columns) col_types[[name]] <- col_skip()
  }

  col_names <- names(col_types$cols)
  data <- read_tsv(file, col_names = col_names, col_types = col_types, ...)
  
  ## Validation
  with(data, stopifnot(
    all(nchar(left_inner_barcode) == 8L),
    all(nchar(right_inner_barcode) == 8L),
    all(nchar(outer_barcode) == 8L)
  ))

  data
}
