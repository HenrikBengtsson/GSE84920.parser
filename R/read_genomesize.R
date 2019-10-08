#' Read Genome-Size Files
#'
#' @param file Pathname to a \file{*.genomesize} file.
#'
#' @param ... Additional arguments passed to [readr::read_tsv()].
#'
#' @return A data.frame with four columns:
#'  \item{`chr`}{Chromosome label}
#'  \item{`length`}{Number of nucleotides in chromosome}
#'
#' @details
#' This file originates from \url{https://github.com/VRam142/combinatorialHiC}.
#' 
#' @section Validation:
#' The `read_genomsize()` function does some basic validation on the
#' values read.
#'
#' @examples
#' path <- system.file("extdata", package = "ramani")
#' file <- file.path(path, "combo_hg19_mm10.genomesize")
#' data <- read_genomesize(file)
#' print(data)
#' # # A tibble: 43 x 2
#' #    chr            length
#' #    <chr>           <int>
#' #  1 human_chr1  249250621
#' #  2 human_chr2  243199373
#' #  3 human_chr3  198022430
#' #  4 human_chr4  191154276
#' #  5 human_chr5  180915260
#' #  6 human_chr6  171115067
#' #  7 human_chr7  159138663
#' #  8 human_chr8  146364022
#' #  9 human_chr9  141213431
#' # 10 human_chr10 135534747
#' # # … with 33 more rows
#' 
#' @importFrom readr read_tsv cols col_character col_integer
#' @export
read_genomesize <- function(file, ...) {
  col_types <- cols(
    chr = col_character(),
    length = col_integer()
  )
  col_names <- names(col_types$cols)
  data <- read_tsv(file, col_names = col_names, col_types = col_types, ...)
  
  ## Validation
  with(data, stopifnot(
    all(length >= 0L)
  ))

  data
}
