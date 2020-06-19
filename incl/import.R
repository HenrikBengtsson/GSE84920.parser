name <- "GSM2254215_ML1.rows=1-1000"
con <- db_connect(name, path = file.path(tempdir(), ".sqlite_data"))

path <- system.file("extdata", package = "GSE84920.parser")
import_assignments(con, file = file.path(path, sprintf("%s_assignments.txt.gz", name)))
import_validpairs(con, file = file.path(path, sprintf("%s.validPairs.txt.gz", name)))

data <- dplyr::tbl(con, "assignments")
print(data)
# # Source:   table<assignments> [?? x 4]
# # Database: sqlite 3.29.0
# #   [/tmp/hb/RtmpVrbKzK/.sqlite_data/GSM2254215_ML1.rows=1-1000.sqlite]
#    readname                   left_inner_barcode right_inner_barc… outer_barcode
#    <chr>                      <chr>              <chr>             <chr>        
#  1 D00584:136:HMTLJBCXX:1:11… CTCTCACG           CTCTCACG          TCAGATGC     
#  2 D00584:136:HMTLJBCXX:1:11… GCACCATG           GCACCATG          GTGTAGCA     
#  3 D00584:136:HMTLJBCXX:1:11… AGGTGCGA           AGGTGCGA          GTATCTAT     
#  4 D00584:136:HMTLJBCXX:1:11… GCCTTAGG           GCCTTAGG          CAGCATAT     
#  5 D00584:136:HMTLJBCXX:1:11… CACCTGTG           CACCTGTG          TACTAAGC     
#  6 D00584:136:HMTLJBCXX:1:11… CCGCTACG           CCGCTACG          CAGCATAT     
#  7 D00584:136:HMTLJBCXX:1:11… GCCTCGAA           GCCTCGAA          GTATCTAT     
#  8 D00584:136:HMTLJBCXX:1:11… CTGGTCAC           CTGGTCAC          TTGACCAT     
#  9 D00584:136:HMTLJBCXX:1:11… CTGCGTAG           CTGCGTAG          TATCTTGT     
# 10 D00584:136:HMTLJBCXX:1:11… CACGACCT           CACGACCT          GATGATCC     
# # … with more rows


data <- dplyr::tbl(con, "validpairs")
print(data)
# # Source:   table<validpairs> [?? x 17]
# # Database: sqlite 3.29.0
# #   [/tmp/hb/RtmpVrbKzK/.sqlite_data/GSM2254215_ML1.rows=1-1000.sqlite]
#    chr_a start_a  end_a chr_b start_b  end_b readname  col8  col9 col10 col11
#    <chr>   <int>  <int> <chr>   <int>  <int> <chr>    <int> <int> <chr> <chr>
#  1 mous…  2.28e7 2.28e7 mous…  5.33e7 5.33e7 D00584:…    37    42 +     -    
#  2 huma…  8.86e7 8.86e7 huma…  8.91e7 8.91e7 D00584:…    42    42 -     -    
#  3 huma…  1.27e8 1.27e8 huma…  1.27e8 1.27e8 D00584:…    42    42 +     +    
#  4 huma…  4.21e7 4.21e7 huma…  4.27e7 4.27e7 D00584:…    42    42 +     +    
#  5 huma…  2.09e8 2.09e8 huma…  2.32e8 2.32e8 D00584:…    42    35 +     -    
#  6 huma…  5.57e6 5.57e6 huma…  1.50e8 1.50e8 D00584:…    42    42 +     -    
#  7 mous…  4.12e7 4.12e7 mous…  4.12e7 4.12e7 D00584:…    42    42 +     -    
#  8 mous…  6.54e7 6.54e7 mous…  6.59e7 6.59e7 D00584:…    42    42 -     +    
#  9 huma…  1.82e8 1.82e8 huma…  1.82e8 1.82e8 D00584:…    42    42 +     -    
# 10 mous…  5.86e7 5.86e7 mous…  6.33e7 6.33e7 D00584:…    42    42 +     +    
# # … with more rows, and 6 more variables: inner_barcode <chr>,
# #   outer_barcode <chr>, col14 <chr>, col15 <int>, col16 <chr>, col17 <int>


## The full "percentages" file is small (270 kB) and only takes a
## second or two to read so there is little need to import these into
## a data base.  The example file used here is even smaller (13 kB).
file <- file.path(path, sprintf("%s.percentages.txt.gz", name))
data <- read_percentages(file)
print(data)
# # A tibble: 1,000 x 16
#    hg19_frac mm10_frac hg19_count mm10_count pair_count inner_barcode
#        <dbl>     <dbl>      <int>      <int>      <int> <chr>        
#  1     1.000 0.0000356      28050          1      28052 ACCACCAC     
#  2     0.680 0.320          19081       8970      28052 ACCACCAC     
#  3     1.000 0.0000370      27010          1      28052 ACCACCAC     
#  4     0.683 0.317          18444       8555      28052 ACCACCAC     
#  5     0     1                  0          1          1 CATAGCGC     
#  6     1     0                  1          0          1 CATAGCGC     
#  7     0     1                  0          1          1 CATAGCGC     
#  8     1     0                  1          0          1 CATAGCGC     
#  9     1     0                  2          0          2 GGCCGTTC     
# 10     1     0                  2          0          2 GGCCGTTC     
# # … with 990 more rows, and 10 more variables: outer_barcode <chr>,
# #   is_observed <chr>, Col10 <chr>, dpnii_1x <int>, dpnii_2x <int>,
# #   dpnii_3x <int>, dpnii_4x <int>, cistrans_ratio <dbl>,
# #   hela_allele_frac <dbl>, celltype <chr>

DBI::dbDisconnect(con)
