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
#' @param debug Should debug output be produced or not?
#'
#' @return (invisibly) A [dbplyr::tbl_dbi] object.
#'
#' @importFrom DBI dbWriteTable
#' @importFrom dplyr tbl
#' @importFrom utils object.size
#' @export
import_assignments <- function(con, file, debug = TRUE) {
  if (!"assignments" %in% dbListTables(con)) {
    if (debug) {
      mnote("Importing %s (%s)", sQuote(file), format_size(file_size(file)))
    }
    t0 <- Sys.time()
    data <- read_assignments(file) ## Takes ~20 min to read (574 MB file)
    if (debug) {
      mnote("Total read time: %s", format(Sys.time() - t0))
      mnote("Writing %d-by-%d %s (%s)", nrow(data), ncol(data), 
            sQuote(class(data)[1]), format_size(object.size(data)))
    }
    t0 <- Sys.time()
    dbWriteTable(con, "assignments", data)  ## takes 4-5 mins
    if (debug) mnote("Total write time: %s", format(Sys.time() - t0))
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
#' @param debug Should debug output be produced or not?
#'
#' @return (invisibly) A [dbplyr::tbl_dbi] object.
#'
#' @importFrom DBI dbWriteTable dbListTables
#' @importFrom dplyr tbl
#' @importFrom utils object.size
#' @export
import_validpairs <- function(con, file, debug = TRUE) {
  if (!"validpairs" %in% dbListTables(con)) {
    if (debug) {
      mnote("Importing %s (%s)", sQuote(file), format_size(file_size(file)))
    }
    t0 <- Sys.time()
    data <- read_validpairs(file) ## Takes ~10 min to read (1.2 GB file)
    if (debug) {
      mnote("Total read time: %s", format(Sys.time() - t0))
      mnote("Writing %d-by-%d %s (%s)", nrow(data), ncol(data), 
            sQuote(class(data)[1]), format_size(object.size(data)))
    }
    t0 <- Sys.time()
    dbWriteTable(con, "validpairs", data) ## takes 4-5 mins
    if (debug) mnote("Total write time: %s", format(Sys.time() - t0))
  }
  tbl(con, "validpairs")
}
