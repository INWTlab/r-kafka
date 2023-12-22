#' Check if message is empty
#'
#' @param msg A KafkaMessage
#'
#' @export
is_empty <- function(msg) {
  !("payload_data" %in% names(msg))
}

#' Print Message
#'
#' @param x a KafkaMessage
#' @param ... additional arguments. Not used atm
#'
#' @export
print.KafkaMessage <- function(x, ...) {
    if ("payload_data" %in% names(x)) {
      if ("key" %in% names(x)) {
        cat ("Key: ", x$key, "\n")
      }
      cat("Payload: ", x$payload_data, "\n")
    } else {
        cat("This is an empty message\n")
    }
}

#' Check for message errors
#'
#' @param x (a KafkaMessage)
#'
#' @export
has_error <- function(x) {
    UseMethod("has_error")
}

has_error.KafkaMessage <- function(x) {
    "error" %in% names(x) || !("payload_data" %in% names(x))
}

#' Get message content
#'
#' @param x (a KafkaMessage)
#'
#' @export
content <- function(x) {
    UseMethod("content")
}

content.KafkaMessage <- function(x) {
    x$payload_data
}

#' Get message key
#'
#' @param x (a KafkaMessage)
#'
#' @export
key <- function(x) {
    UseMethod("key")
}
key.KafkaMessage <- function(x) {
    x$key
}
