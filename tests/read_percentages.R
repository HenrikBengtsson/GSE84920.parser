library("ramani")

path <- system.file("extdata", package = "ramani", mustWork = TRUE)
file <- file.path(path, "GSM2254215_ML1.rows=1-1000.percentages.txt.gz")
data <- read_percentages(file)
print(data)

columns <- c("hg19_frac", "inner_barcode", "outer_barcode")
data2 <- read_percentages(file, columns = columns)
print(data2)
stopifnot(all.equal(data2, data[, columns], check.attributes = FALSE))
