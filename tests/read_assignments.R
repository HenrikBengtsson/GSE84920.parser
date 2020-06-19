library("ramani")

path <- system.file("extdata", package = "ramani")
file <- file.path(path, "GSM2254215_ML1.rows=1-1000_assignments.txt.gz")
data <- read_assignments(file)
print(data)

columns <- c("readname", "left_inner_barcode", "outer_barcode")
data2 <- read_assignments(file, columns = columns)
print(data2)
stopifnot(all.equal(data2, data[, columns], check.attributes = FALSE))
