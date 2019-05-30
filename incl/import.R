name <- "GSM2254215_ML1.rows=1-1000"
con <- db_connect(name, path = file.path(tempdir(), ".sqlite_data"))

path <- system.file("extdata", package = "ramani")
import_assignments(con, file = file.path(path, sprintf("%s_assignments.txt.gz", name)))

data <- dplyr::tbl(con, "assignments")
print(data)

import_validpairs(con, file = file.path(path, sprintf("%s.validPairs.txt.gz", name)))

data <- dplyr::tbl(con, "validpairs")
print(data)

file <- file.path(path, sprintf("%s.percentages.txt.gz", name))
print(file.size(file))  ## 273357
data <- read_percentages(file)  ## Takes 1-2 sec to read (270 kB)
print(data)

DBI::dbDisconnect(con)
