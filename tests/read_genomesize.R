library("ramani")

path <- system.file("extdata", package = "ramani")
file <- file.path(path, "combo_hg19_mm10.genomesize")
data <- read_genomesize(file)
print(data)
