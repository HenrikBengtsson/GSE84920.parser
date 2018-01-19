#' Get a file MD5 checksum and output to paired *.md5 file
#' 
#' @param pathname File for which MD5 checksum should be produced
#'
#' @return A MD5 checksum string validated to consist of 32 hexadecimal
#' characters (if not, an error is produced).
#'
#' @details
#' If a paired \file{*.md5} checksum file already exists and is newer than
#' the source `pathname` file, then the checksum is read from the checksum
#' file.  In all other cases, a new MD5 checksum is calculated and a paired
#' \file{*.md5} file is written/updated.
#' 
#' @importFrom utils file_test
#' @importFrom tools md5sum
#' @export
md5_file <- function(pathname) {
  stopifnot(length(pathname) == 1, file_test("-f", pathname))
  pathname_md5 <- sprintf("%s.md5", pathname)
  if (!file_test("-nt", pathname_md5, pathname)) {
    pathname_md5 <- file_tmpify(pathname_md5)
    md5 <- md5sum(pathname)
    md5 <- unname(md5)
    cat(md5, file = pathname_md5)
    pathname_md5 <- file_untmpify(pathname_md5, overwrite = TRUE)
  } else {
    stopifnot(file_test("-f", pathname_md5))
    md5 <- readLines(pathname_md5, warn = FALSE)
  }

  ## Assert that we have have a valid MD5 checksum
  stopifnot(nchar(md5) == 32L, grepl("^[0-9a-fA-Z]+$", md5))
  
  md5
}
