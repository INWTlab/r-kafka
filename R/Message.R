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

#' @export
result_message <- function(result) {
    result$message
}

#' @export
result_has_error <- function(result) {
    !is.null(result$error_code)
}


#' @export
result_error_code <- function(result) {
    result$error_code
}

#' @export
result_error_message <- function(result) {
    result$error_message
}

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
