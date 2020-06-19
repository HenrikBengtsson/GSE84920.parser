library("ramani")

path <- system.file("extdata", package = "ramani", mustWork = TRUE)
file <- file.path(path, "GSM2254215_ML1.rows=1-1000.validPairs.txt.gz")
data <- read_validpairs(file)
print(data)

columns <- c("chr_a", "start_a", "readname")
data2 <- read_validpairs(file, columns = columns)
print(data2)
stopifnot(all.equal(data2, data[, columns], check.attributes = FALSE))
