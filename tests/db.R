library("GSE84920.parser")
library("dplyr")
path <- system.file("extdata", package = "GSE84920.parser", mustWork = TRUE)

name <- "GSM2254215_ML1"
con <- db_connect(name, path = tempfile("sqlite_data"))

file <- file.path(path, sprintf("%s.rows=1-1000_assignments.txt.gz", name))
import_assignments(con, file = file)
data <- tbl(con, "assignments")
print(data)

file <- file.path(path, sprintf("%s.rows=1-1000.validPairs.txt.gz", name))
import_validpairs(con, file = file)
data <- tbl(con, "validpairs")
print(data)

file <- file.path(path, sprintf("%s.rows=1-1000.percentages.txt.gz", name))
data <- read_percentages(file)  ## Quick to read
print(data)

DBI::dbDisconnect(con)
file.remove(con@dbname)
