#' Read Valid-Pairs Files
#'
#' A 'VALIDPAIRS' file is for all valid pairs in each library.
#'
#' @param file Pathname to a \file{*.validPairs.txt(.gz)} file.
#'
#' @param columns (optional) Name of columns to be read.
#'
#' @param ... Additional arguments passed to [readr::read_tsv()].
#'
#' @return A data.frame with 17 columns:
#'  \item{`col1`}{}
#'  \item{`col2`}{}
#'  \item{`col3`}{}
#'  \item{`col4`}{}
#'  \item{`col5`}{}
#'  \item{`col6`}{}
#'  \item{`readname`}{Read names, e.g. `D00584:136:HMTLJBCXX:1:1101:10000:101176`}
#'  \item{`col8`}{}
#'  \item{`col9`}{}
#'  \item{`col10`}{Strand (`-` or `+`)}
#'  \item{`col11`}{Strand (`-` or `+`)}
#'  \item{`inner_barcode`}{Barcode ...}
#'  \item{`outer_barcode`}{Barcode ...}
#'  \item{`col14`}{}
#'  \item{`col15`}{}
#'  \item{`col16`}{}
#'  \item{`col17`}{}
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
#' @importFrom readr read_tsv cols col_character col_integer col_skip
#' @export
read_validpairs <- function(file, columns = NULL, ...) {
  col_types <- cols(
    chr_a = col_character(),
    start_a = col_integer(),
    end_a = col_integer(),
    chr_b = col_character(),
    start_b = col_integer(),
    end_b = col_integer(),
    readname = col_character(),
    col8 = col_integer(),
    col9 = col_integer(),
    col10 = col_character(),  ## strand
    col11 = col_character(),  ## strand
    inner_barcode = col_character(),
    outer_barcode = col_character(),
    col14 = col_character(),
    col15 = col_integer(),
    col16 = col_character(),
    col17 = col_integer(),
    .default = col_skip()
  )
  all_col_names <- names(col_types$cols)

  if (!is.null(columns)) {
    stopifnot(all(columns %in% names(col_types$cols)))
    col_types$cols <- col_types$cols[columns]
  }

  data <- read_tsv(file, col_names = all_col_names, col_types = col_types, ...)
  
  ## Validation
  col_names <- colnames(data)
  with(data, stopifnot(
    !"start_a" %in% col_names || all(start_a >= 0),
    !"end_a" %in% col_names || all(end_a >= 0),
    !"start_b" %in% col_names || all(start_b >= 0),
    !"end_b" %in% col_names || all(end_b >= 0),
    !"col8" %in% col_names || all(col8 >= 0),
    !"col9" %in% col_names || all(col9 >= 0),
    !"col10" %in% col_names || all(col10 %in% c("+", "-")),
    !"col11" %in% col_names || all(col11 %in% c("+", "-")),
    !"inner_barcode" %in% col_names || all(nchar(inner_barcode) == 8L),
    !"outer_barcode" %in% col_names || all(nchar(outer_barcode) == 8L),
    !"col15" %in% col_names || all(col15 >= 0),
    !"col17" %in% col_names || all(col17 >= 0)
  ))

  data
}
