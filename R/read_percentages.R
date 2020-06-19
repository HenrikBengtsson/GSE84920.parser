#' Read Percentages Files
#'
#' A 'percentages' file provides summary statistics for each processed cellular
#' index in combinatorial single-cell Hi-C data.
#'
#' @param file Pathname to a \file{*.percentages.txt(.gz)} file.
#'
#' @param columns (optional) Name of columns to be read.
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
#'  \item{`inner_barcode`}{Round 1 Barcode (Inner)}
#'  \item{`outer_barcode`}{Round 2 Barcode (Outer)}
#'  \item{`is_observed`}{`True` or `Randomized`;
#'        `True` are the observed data,
#'        `Randomized` are the result of shuffling all
#'        barcode assignments to new reads}
#'  \item{`Col10`}{`All` or `Long`;
#'        `All` are all intrachromosomal / interchromosomal reads
#'        associated with a cellular index;
#'        `Long` are only inter- and intra > 20 kbp}
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
#' path <- system.file("extdata", package = "GSE84920.parser")
#' file <- file.path(path, "GSM2254215_ML1.rows=1-1000.percentages.txt.gz")
#' data <- read_percentages(file)
#' print(data)
#' # # A tibble: 1,000 x 16
#' #    hg19_frac mm10_frac hg19_count mm10_count pair_count inner_barcode outer_barcode is_observed
#' #        <dbl>     <dbl>      <int>      <int>      <int> <chr>         <chr>         <chr>      
#' #  1     1.000 0.0000356      28050          1      28052 ACCACCAC      TCAGATGC      True       
#' #  2     0.680 0.320          19081       8970      28052 ACCACCAC      TCAGATGC      Randomized 
#' #  3     1.000 0.0000370      27010          1      28052 ACCACCAC      TCAGATGC      True       
#' #  4     0.683 0.317          18444       8555      28052 ACCACCAC      TCAGATGC      Randomized 
#' #  5     0     1                  0          1          1 CATAGCGC      ACTTGATA      True       
#' #  6     1     0                  1          0          1 CATAGCGC      ACTTGATA      Randomized 
#' #  7     0     1                  0          1          1 CATAGCGC      ACTTGATA      True       
#' #  8     1     0                  1          0          1 CATAGCGC      ACTTGATA      Randomized 
#' #  9     1     0                  2          0          2 GGCCGTTC      GCCATTAA      True       
#' # 10     1     0                  2          0          2 GGCCGTTC      GCCATTAA      Randomized 
#' # # … with 990 more rows, and 8 more variables: Col10 <chr>, dpnii_1x <int>, dpnii_2x <int>,
#' # #   dpnii_3x <int>, dpnii_4x <int>, cistrans_ratio <dbl>, hela_allele_frac <dbl>,
#' # #   celltype <chr>
#'
#' print(table(data$celltype))
#' ###   HAP1    HeLa    MEF   Patski Undetermined 
#' ###    156     163    174      152          355 
#'
#' 
#' @importFrom readr read_tsv cols col_character col_integer col_double col_skip
#' @export
read_percentages <- function(file, columns = NULL, ...) {
  col_types = cols(
    hg19_frac        = col_double(),
    mm10_frac        = col_double(),
    hg19_count       = col_integer(),
    mm10_count       = col_integer(),
    hg19mm10_count   = col_integer(),
    pair_count       = col_integer(),
    inner_barcode    = col_character(),
    outer_barcode    = col_character(),
    is_observed      = col_character(),
    Col10            = col_character(),
    dpnii_1x         = col_integer(),
    dpnii_2x         = col_integer(),
    dpnii_3x         = col_integer(),
    dpnii_4x         = col_integer(),
    cistrans_ratio   = col_double(),
    hela_allele_frac = col_double(),
    celltype         = col_character(),
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
    !"hg_19_frac" %in% col_names || all(hg19_frac >= 0 & hg19_frac <= 1),
    !"mm10_frac" %in% col_names || all(mm10_frac >= 0 & mm10_frac <= 1),
    !"hg19_count" %in% col_names || all(hg19_count >= 0),
    !"mm10_count" %in% col_names || all(mm10_count >= 0),
    !all(c("hg19_count", "mm10_count", "hg19mm10_count") %in% col_names) || all(hg19_count + mm10_count == hg19mm10_count),
    !"pair_count" %in% col_names || all(pair_count >= 0),
    !"inner_barcode" %in% col_names || all(nchar(inner_barcode) == 8L),
    !"outer_barcode" %in% col_names || all(nchar(outer_barcode) == 8L),
    !"is_observed" %in% col_names || all(is_observed %in% c("True", "Randomized")),
    !"Col10" %in% col_names || all(Col10 %in% c("All", "Long")),
    !"dpnii_1x" %in% col_names || all(dpnii_1x >= 0),
    !"dpnii_2x" %in% col_names || all(dpnii_2x >= 0),
    !"dpnii_3x" %in% col_names || all(dpnii_3x >= 0),
    !"dpnii_4x" %in% col_names || all(dpnii_4x >= 0),
    !"hela_allele_frac" %in% col_names || all(is.na(hela_allele_frac) | hela_allele_frac >= 0)
  ))

  ## Cleanup
  data$hg19mm10_count <- NULL ## redundant
  
  data
}
