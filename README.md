# ramani: Access Ramani et al. Hi-C Data

This [R] package provides a shell script and an R API for working with the Ramani et al. (2017) Hi-C data set.

The Ramani data set is published on NCBI's Gene Expression Omnibus (GEO) in the GEO series [GSE84920] \(titled 'Massively multiplex single-cell Hi-C'\).  it contains GEO samples:

 * [GSM2254215]: Combinatorial scHi-C Library ML1
 * [GSM2254216]: Combinatorial scHi-C Library ML2
 * [GSM2254217]: Combinatorial scHi-C Library ML3
 * [GSM2254218]: Combinatorial scHi-C Library PL1
 * [GSM2254219]: Combinatorial scHi-C Library PL2
 * [GSM2438426]: Combinatorial scHi-C Library ML4

Except for the last sample (ML4), they are all from human cell lines (labelled HAP1, HeLa, K562, Asynchronous, Nocadazole), and mouse cell lines (labelled MEF and Patski).


## R API

This R package provides functions for reading the above GEO data set, and other data with the same file formats, into R.  It also includes a small subset of the ML1 data for the purpose of illustrating and testing the different functions:

```r
> library(ramani)
> path <- system.file("extdata", package = "ramani")
> dir(path)
[1] "combo_hg19_mm10.genomesize"                   
[2] "GSM2254215_ML1.rows=1-1000_assignments.txt.gz"
[3] "GSM2254215_ML1.rows=1-1000.percentages.txt.gz"
[4] "GSM2254215_ML1.rows=1-1000.validPairs.txt.gz" 
```


Lets look at the content of each of these `*.txt.gz` files:

```r
> file <- file.path(path, "GSM2254215_ML1.rows=1-1000_assignments.txt.gz")
> a <- read_assignments(file)
> a
# A tibble: 1,000 x 4
   readname                   left_inner_barcode right_inner_barc… outer_barcode
   <chr>                      <chr>              <chr>             <chr>        
 1 D00584:136:HMTLJBCXX:1:11… CTCTCACG           CTCTCACG          TCAGATGC     
 2 D00584:136:HMTLJBCXX:1:11… GCACCATG           GCACCATG          GTGTAGCA     
 3 D00584:136:HMTLJBCXX:1:11… AGGTGCGA           AGGTGCGA          GTATCTAT     
 4 D00584:136:HMTLJBCXX:1:11… GCCTTAGG           GCCTTAGG          CAGCATAT     
 5 D00584:136:HMTLJBCXX:1:11… CACCTGTG           CACCTGTG          TACTAAGC     
 6 D00584:136:HMTLJBCXX:1:11… CCGCTACG           CCGCTACG          CAGCATAT     
 7 D00584:136:HMTLJBCXX:1:11… GCCTCGAA           GCCTCGAA          GTATCTAT     
 8 D00584:136:HMTLJBCXX:1:11… CTGGTCAC           CTGGTCAC          TTGACCAT     
 9 D00584:136:HMTLJBCXX:1:11… CTGCGTAG           CTGCGTAG          TATCTTGT     
10 D00584:136:HMTLJBCXX:1:11… CACGACCT           CACGACCT          GATGATCC     
# … with 990 more rows
```

```r
> p <- read_percentages(file)
> p
# A tibble: 1,000 x 16
   hg19_frac mm10_frac hg19_count mm10_count pair_count inner_barcode outer_barcode is_observed Col10 dpnii_1x
       <dbl>     <dbl>      <int>      <int>      <int> <chr>         <chr>         <chr>       <chr>    <int>
 1     1.000 0.0000356      28050          1      28052 ACCACCAC      TCAGATGC      True        All      55603
 2     0.680 0.320          19081       8970      28052 ACCACCAC      TCAGATGC      Randomized  All      55603
 3     1.000 0.0000370      27010          1      28052 ACCACCAC      TCAGATGC      True        Long     55603
 4     0.683 0.317          18444       8555      28052 ACCACCAC      TCAGATGC      Randomized  Long     55603
 5     0     1                  0          1          1 CATAGCGC      ACTTGATA      True        All          2
 6     1     0                  1          0          1 CATAGCGC      ACTTGATA      Randomized  All          2
 7     0     1                  0          1          1 CATAGCGC      ACTTGATA      True        Long         2
 8     1     0                  1          0          1 CATAGCGC      ACTTGATA      Randomized  Long         2
 9     1     0                  2          0          2 GGCCGTTC      GCCATTAA      True        All          4
10     1     0                  2          0          2 GGCCGTTC      GCCATTAA      Randomized  All          4
# … with 990 more rows, and 6 more variables: dpnii_2x <int>, dpnii_3x <int>, dpnii_4x <int>,
#   cistrans_ratio <dbl>, hela_allele_frac <dbl>, celltype <chr>
```

```r
> file <- file.path(path, "GSM2254215_ML1.rows=1-1000.validPairs.txt.gz")
> vp <- read_validpairs(file)
> vp
# A tibble: 1,000 x 17
   chr_a start_a  end_a chr_b start_b  end_b readname  col8  col9 col10 col11 inner_barcode outer_barcode
   <chr>   <int>  <int> <chr>   <int>  <int> <chr>    <int> <int> <chr> <chr> <chr>         <chr>        
 1 mous…  2.28e7 2.28e7 mous…  5.33e7 5.33e7 D00584:…    37    42 +     -     ATCCGCGG      GTCATAGT     
 2 huma…  8.86e7 8.86e7 huma…  8.91e7 8.91e7 D00584:…    42    42 -     -     GAGGAGCA      CGATGACA     
 3 huma…  1.27e8 1.27e8 huma…  1.27e8 1.27e8 D00584:…    42    42 +     +     GCTACGGT      AGTCGTAT     
 4 huma…  4.21e7 4.21e7 huma…  4.27e7 4.27e7 D00584:…    42    42 +     +     AGGTGCGA      ATACATGT     
 5 huma…  2.09e8 2.09e8 huma…  2.32e8 2.32e8 D00584:…    42    35 +     -     GCCTCGAA      GAGTACGT     
 6 huma…  5.57e6 5.57e6 huma…  1.50e8 1.50e8 D00584:…    42    42 +     -     GCTCGCTA      CTAGTGAA     
 7 mous…  4.12e7 4.12e7 mous…  4.12e7 4.12e7 D00584:…    42    42 +     -     GAGGAGCA      CGTTACTT     
 8 mous…  6.54e7 6.54e7 mous…  6.59e7 6.59e7 D00584:…    42    42 -     +     TCCGGACA      TGTCTGCA     
 9 huma…  1.82e8 1.82e8 huma…  1.82e8 1.82e8 D00584:…    42    42 +     -     CAGGCTTG      GATATAAC     
10 mous…  5.86e7 5.86e7 mous…  6.33e7 6.33e7 D00584:…    42    42 +     +     TCACGAGC      TGAGGCAA     
# … with 990 more rows, and 4 more variables: col14 <chr>, col15 <int>, col16 <chr>, col17 <int>
```


Reading the _full_ Ramani HiC files can take quite a while, particularly the ones with "assignments" and "validPairs" data.  Because of this, you might want to import these data (once) into a local database and work with the data from there.  See `help("import_assignments", package = "ramani")` for an example showing how to import into an SQLite database on file, which is easy since it requires zero setup.



## Shell Script API

### Splitting whole-genome files into chromosome-pair files

The package also provides a Bash script for splitting a HiC-count data file into chromosome-pair files.  This  [`split.sh`](inst/scripts/split.sh) script is located under `system.file("scripts", package = "ramani")`.

```
$ split.sh 
Split HiC Count Data File into Chromosome-Pair Files

Usage:
 ./split.sh [options] path/to/*.summary.txt.gz

Options:
 --help       Display this help
 --version    Display the version
 --dryrun     Don't run anything
 --intraonly  Only process intra-chromosome pairs

Examples:
 ./split.sh --intraonly hicData/GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary.txt.gz

This outputs *.tsv.gz files:

  1. GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary_chr1_vs_chr1.tsv.gz
  2. GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary_chr2_vs_chr2.tsv.gz
...
 25. GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary_chrM_vs_chrM.tsv.gz

to folder hicData/GSE35156_GSM862720/ with names 

Details:
The produced files are names '<name>,<chr_i>_vs_<chr_j>.tsv.gz' where <name>
is the name of input '*.summary.txt.gz' file without the extension. The
files are written to folder 'hicData/<gse_id>_<gsm_id>/' where <gse_id> and
<gsm_id> are inferred from the <name>. This folder is automatically created,
if missing.

Version: 0.1.2
Copyright: Henrik Bengtsson (2017-2019)
License: GPL (>= 3.0)
Source: https://github.com/HenrikBengtsson/ramani
```


[R]: https://www.r-project.org/
[remotes]: https://cran.r-project.org/package=remotes

## Installation
R package ramani is only available via [GitHub](https://github.com/HenrikBengtsson/ramani) and can be installed in R as:
```r
remotes::install_github("HenrikBengtsson/ramani")
```

## References

1. Ramani, V., Deng, X., Qiu, R., Gunderson, K. L., Steemers, F. J., Disteche, C. M., … Shendure, J. (2017). Massively multiplex single-cell Hi-C. Nature methods, 14(3), 263–266. doi:10.1038/nmeth.4155, [PMC5330809](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5330809/)



## Contributions

This Git repository uses the [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/) branching model (the [`git flow`](https://github.com/petervanderdoes/gitflow-avh) extension is useful for this).  The [`develop`](https://github.com/HenrikBengtsson/ramani/tree/develop) branch contains the latest contributions and other code that will appear in the next release, and the [`master`](https://github.com/HenrikBengtsson/ramani) branch contains the code of the latest release.

Contributing to this package is easy.  Just send a [pull request](https://help.github.com/articles/using-pull-requests/).  When you send your PR, make sure `develop` is the destination branch on the [ramani repository](https://github.com/HenrikBengtsson/ramani).  Your PR should pass `R CMD check --as-cran`, which will also be checked by <a href="https://travis-ci.org/HenrikBengtsson/ramani">Travis CI</a> and <a href="https://ci.appveyor.com/project/HenrikBengtsson/ramani">AppVeyor CI</a> when the PR is submitted.


## Software status

| Resource:     | GitHub        | Travis CI       | AppVeyor         |
| ------------- | ------------------- | --------------- | ---------------- |
| _Platforms:_  | _Multiple_          | _Linux & macOS_ | _Windows_        |
| R CMD check   |  | <a href="https://travis-ci.org/HenrikBengtsson/ramani"><img src="https://travis-ci.org/HenrikBengtsson/ramani.svg" alt="Build status"></a>   | <a href="https://ci.appveyor.com/project/HenrikBengtsson/ramani"><img src="https://ci.appveyor.com/api/projects/status/github/HenrikBengtsson/ramani?svg=true" alt="Build status"></a> |
| Test coverage |                     | <a href="https://codecov.io/gh/HenrikBengtsson/ramani"><img src="https://codecov.io/gh/HenrikBengtsson/ramani/branch/develop/graph/badge.svg" alt="Coverage Status"/></a>     |                  |



[GSE84920]: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE84920
[GSM2254215]: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2254215
[GSM2254216]: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2254216
[GSM2254217]: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2254217
[GSM2254218]: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2254218
[GSM2254219]: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2254219
[GSM2438426]: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2438426
