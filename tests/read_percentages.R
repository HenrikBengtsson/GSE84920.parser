library("ramani")

path <- system.file("extdata", package = "ramani", mustWork = TRUE)
file <- file.path(path, "GSM2254215_ML1_rows=1-50.percentages.txt.gz")
data <- read_percentages(file)
print(data)
