#' Read Percentages Files
#'
#' A 'percentages' file provides summary statisics for each processed cellular
#' index in combinatorial single-cell Hi-C data.
#'
#' @param file Pathname to a *.percentages(.tar.gz) file
#'
#' @return A data.frame with columns:
#' \itemize{
#'  \item{Col}{}
Col1: Fraction Reads Mapping to hg19
Col2: Fraction Reads Mapping to mm10
Col3: Number of Reads Mapping to hg19
Col4: Number of Reads Mapping to mm10
Col5: Total Number of Read Pairs filtering out interspecies (Col3 + Col4)
Col6: Total Number of Reads Pairs
Col7: Round 1 Barcode (Inner)
Col8: Round 2 Barcode (Outer)
Col9: True or Randomized; True are the observed data, Randomized are the result of shuffling all barcode assignments to new reads
Col10: All or Long; All are all intrachromosomal / interchromosomal reads associated with a cellular index; Long are only inter- and intra >20kb
Col11: # of times a DpnII fragment is observed once
Col12: # of times a DpnII fragment is observed twice
Col13: # of times a DpnII fragment is observed thrice
Col14: # of times a DpnII fragment is observed four times
Col15: Cis-trans ratio for that cellular inde
Col16: If applicable (only HeLa S3 and HAP1 cells), fraction of homozygous alternate HeLa allele calls
Col17: Programmed cell type assignment, if applicable. For ML libraries, only cells with >0.95 in Col1 or Col2 receive assignments.
#' }
#'
#' @details
#' The description here are adopted from \file{GSE84920_README.txt}, which
#' refers to the "manuscript" for description of the "PERCENTAGES" files.
#' The column names returned are ours, because the data files do not provide
#' column names.
#'
#' @section Validation:
#' The `read_percentages()` function does some basic validation on the
#' values read.
#'
#' 
#' @importFrom readr read_tsv
#' @export
read_percentages <- function(file, col_names = FALSE, ...) {
  data <- read_tsv(file, col_names = col_names, ...)
  colnames(data)[17] <- ""
  data
}




## # A tibble: 21,432 x 17
      X1        X2    X3    X4    X5    X6 X7       X8       X9         X10     X11   X12   X13   X14   X15    X16 X## 17
         <dbl>     <dbl> <int> <int> <int> <int> <chr>    <chr>    <chr>      <chr> <int> <int> <int> <int> <dbl>  <## dbl> <chr>
	  1 1.000 0.0000356 28050     1 28051 28052 ACCACCAC TCAGATGC True       All   55603   182     1     0  7.93##   0.534 HAP1
