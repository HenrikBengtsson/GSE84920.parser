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
