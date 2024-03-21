#' Create KafkaMessage object
#'
#' @param key (`character`) message key (optional)
#' @param value (`character`) message value
#' @export
new_kafka_message <- function(key = NULL, value) {
    structure(
        list(
            key = key,
            value = value
        ),
        class = "KafkaMessage"
    )
}

#' Extract message from result
#'
#' @param result (`KafkaResult`) result from consumer
#'
#' @export
result_message <- function(result) {
    result$message
}

#' Check if result has errors
#'
#' @param result (`KafkaResult`) result from consumer
#'
#' @export
result_has_error <- function(result) {
    !is.null(result$error_code)
}

#' Extract error code from result
#'
#' @param result (`KafkaResult`) result from consumer
#'
#' @export
result_error_code <- function(result) {
    result$error_code
}

#' Extract error message from result
#'
#' @param result (`KafkaResult`) result from consumer
#'
#' @export
result_error_message <- function(result) {
    result$error_message
}

#' Print kafka message
#'
#' @param x (`KafkaMessage`) message
#' @param ... additional args (not used)
#'
#' @export
print.KafkaMessage <- function(x, ...) {
    if (!is.null(x$key)) {
        cat(sprintf("Key: %s\n", x$key))
    }
    cat(sprintf("Value: %s\n", x$value))
    invisible(x)
}


new_kafka_result <- function(message, error_code, error_message) {
    structure(
        list(
            message = message,
            error_code = error_code,
            error_message = error_message
        ),
        class = "KafkaResult"
    )
}
