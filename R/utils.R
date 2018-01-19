#' @importFrom utils file_test
file_tmpify <- function(pathname) {
  pathname_tmp <- sprintf("%s.tmp", pathname)
  stopifnot(!file_test("-f", pathname_tmp))
  pathname_tmp
}

#' @importFrom utils file_test
file_untmpify <- function(pathname_tmp, overwrite = FALSE) {
  stopifnot(file_test("-f", pathname_tmp))
  pathname <- gsub("[.]tmp$", "", pathname_tmp)
  if (overwrite && file_test("-f", pathname)) file.remove(pathname)
  stopifnot(!file_test("-f", pathname))
  file.rename(pathname_tmp, pathname)
  stopifnot(file_test("-f", pathname))
  pathname
}

mmsg <- function(fmt, ..., class = NULL) {
  if (!is.null(class)) fmt <- sprintf("[%s] %s", class, fmt)
  message(sprintf(fmt, ...))
  invisible(TRUE)
}

mnote <- function(fmt, ...) {
  mmsg(fmt, ..., class = "NOTE")
}
