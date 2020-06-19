library("GSE84920.parser")

path <- system.file("extdata", package = "GSE84920.parser")
file <- file.path(path, "combo_hg19_mm10.genomesize")
data <- read_genomesize(file)
print(data)
