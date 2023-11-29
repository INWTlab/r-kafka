#' @export
is_empty <- function(msg) {
  !("payload_data" %in% names(msg))
}

#' @export
content <- function(msg) {
  msg$payload_data
}
