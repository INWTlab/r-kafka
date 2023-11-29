#' Check if message is empty
#'
#' @param msg (a message)
#'
#' @export
is_empty <- function(msg) {
  !("payload_data" %in% names(msg))
}

#' Get content of message
#'
#' @param msg (a message)
#'
#' @export
content <- function(msg) {
  msg$payload_data
}
