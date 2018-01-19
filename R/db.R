#' Set up a Database
#'
#' @param name The name of a data set
#'
#' @param path Path where to store file database, if applicable.
#'
#' @param engine A DBI-compatible database engine.
#'
#' @return con A DBIConnection.
#'
#' @importFrom DBI dbConnect
#' @importFrom utils file_test
#' @export
db_connect <- function(name, path = "sqlite_data", engine = RSQLite::SQLite()) {
  if (!file_test("-d", path)) dir.create(path, recursive = TRUE)
  stopifnot(file_test("-d", path))
  pathname <- file.path(path, sprintf("%s.sqlite", name))
  dbConnect(engine, pathname)
}


#' Import an Assignments File to Database
#'
#' @param con A DBIConnection.
#'
#' @param file An tab-delimited assignment file readable
#' using [read_assignments()].
#'
#' @return (invisibly) A [dbplyr::tbl_dbi] object.
#'
#' @importFrom DBI dbWriteTable
#' @importFrom dplyr tbl
#' @export
import_assignments <- function(con, file) {
  if (!"assignments" %in% dbListTables(con)) {
    print(file.size(file))  ## 574410654
    data <- read_assignments(file) ## Takes ~20 min to read (574 MB file)
    print(data)
    ## Takes 4-5 min to write
    dbWriteTable(con, "assignments", data)
  }
  tbl(con, "assignments")
}

#' Import a Valid Pair File to Database
#'
#' @param con A DBIConnection.
#'
#' @param file An tab-delimited assignment file readable
#' using [read_validpairs()].
#'
#' @return (invisibly) A [dbplyr::tbl_dbi] object.
#'
#' @importFrom DBI dbWriteTable dbListTables
#' @importFrom dplyr tbl
#' @export
import_validpairs <- function(con, file) {
  if (!"validpairs" %in% dbListTables(con)) {
    print(file.size(file))  ## 1224864620
    message("reading")
    print(Sys.time())
    data <- read_validpairs(file) ## Takes ~10 min to read (1.2 GB file)
    print(data)
    print(Sys.time())
    ## Takes 4-5 min to write
    message("writing")
    print(Sys.time())
    dbWriteTable(con, "validpairs", data)
    print(Sys.time())
  }
  tbl(con, "validpairs")
}
