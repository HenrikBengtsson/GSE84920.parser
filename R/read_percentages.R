#' Read Percentages Files
#'
#' A 'percentages' file provides summary statisics for each processed cellular
#' index in combinatorial single-cell Hi-C data.
#'
#' @param file Pathname to a \file{*.percentages.txt(.gz)} file.
#'
#' @param ... Additional arguments passed to [readr::read_tsv()].
#'
#' @return A data.frame with 17 columns:
#'  \item{`hg19_frac`}{Fraction Reads Mapping to hg19}
#'  \item{`mm10_frac`}{Fraction Reads Mapping to mm10}
#'  \item{`hg19_count`}{Number of Reads Mapping to hg19}
#'  \item{`mm10_count`}{Number of Reads Mapping to mm10}
#'  \item{`hg19mm10_count`}{Total Number of Read Pairs filtering out
#'       interspecies (== `read_hg19_count` + `read_mm10_count`)}
#'  \item{`pair_count`}{Total Number of Reads Pairs}
#'  \item{`barcode1_inner`}{Round 1 Barcode (Inner)}
#'  \item{`barcode2_outer`}{Round 2 Barcode (Outer)}
#'  \item{`is_observed`}{`True` or `Randomized`;
#'        `True` are the observed data,
#'        `Randomized` are the result of shuffling all
#'        barcode assignments to new reads}
#'  \item{`Col10`}{`All` or `Long`;
#'        `All` are all intrachromosomal / interchromosomal reads
#'        associated with a cellular index;
#'        `Long` are only inter- and intra >20kb}
#'  \item{`dpnii_1x`}{Number of times a DpnII fragment is observed once}
#'  \item{`dpnii_2x`}{Number of times a DpnII fragment is observed twice}
#'  \item{`dpnii_3x`}{Number of times a DpnII fragment is observed thrice}
#'  \item{`dpnii_4x`}{Number of times a DpnII fragment is observed four times}
#'  \item{`cistrans_ratio`}{Cis-trans ratio for that cellular index}
#'  \item{`hela_allele_frac`}{If applicable (only HeLa S3 and HAP1 cells),
#'        fraction of homozygous alternate HeLa allele calls}
#'  \item{`celltype`}{Programmed cell type assignment, if applicable.
#'        For ML libraries, only cells with >0.95 in `hg19_frac` or
#'        `mm10_frac` receive assignments.}
#'
#' @details
#' The description here are adopted from [GSE84920_README.txt](ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE84nnn/GSE84920/suppl/GSE84920\%5FREADME\%2Etxt), which
#' refers to the "manuscript" for description of the "PERCENTAGES" files.
#' The column names returned are ours, because the data files do not provide
#' column names.
#'
#' @section Validation:
#' The `read_percentages()` function does some basic validation on the
#' values read.
#'
#' @examples
#' path <- system.file("extdata", package = "ramani")
#' file <- file.path(path, "GSM2254215_ML1.rows=1-1000.percentages.txt.gz")
#' data <- read_percentages(file)
#' print(data)
#' 
#' @importFrom readr read_tsv
#' @export
read_percentages <- function(file, ...) {
  data <- read_tsv(file, col_names = FALSE, ...)
  ## Default Col1-17
  ## colnames(data) <- sprintf("Col%d", seq_len(ncol(data)))
  colnames(data) <- c(
    "hg19_frac", "mm10_frac", "hg19_count", "mm10_count", "hg19mm10_count",
    "pair_count",
    "barcode1_inner", "barcode2_outer",
    "is_observed",
    "Col10",
    "dpnii_1x", "dpnii_2x", "dpnii_3x", "dpnii_4x",
    "cistrans_ratio",
    "hela_allele_frac",
    "celltype"
  )
  
  ## Validation
  with(data, stopifnot(
    all(hg19_frac >= 0), all(hg19_frac <= 1),
    all(mm10_frac >= 0), all(mm10_frac <= 1),
    all(hg19_count >= 0),
    all(mm10_count >= 0),
    all(hg19_count + mm10_count == hg19mm10_count),
    all(pair_count >= 0),
    all(nchar(barcode1_inner) == 8L),
    all(nchar(barcode2_outer) == 8L),
    all(is_observed %in% c("True", "Randomized")),
    all(Col10 %in% c("All", "Long")),
    all(dpnii_1x >= 0),
    all(dpnii_2x >= 0),
    all(dpnii_3x >= 0),
    all(dpnii_4x >= 0),
    all(is.na(hela_allele_frac) | hela_allele_frac >= 0)
  ))

  ## Cleanup
  data$hg19mm10_count <- NULL ## redundant
  
  data
}