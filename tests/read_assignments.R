library("ramani")

path <- system.file("extdata", package = "ramani")
file <- file.path(path, "GSM2254215_ML1.rows=1-1000_assignments.txt.gz")
data <- read_assignments(file)
print(data)
