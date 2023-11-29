print.KafkaMessage <- function(x) {
    if ("payload_data" %in% names(x)) {
        print(x$payload_data)
    } else {
        cat("This is an empty message\n")
    }
}

has_error <- function(x) {
    UseMethod("has_error")
}

has_error.KafkaMessage <- function(x) {
    "error" %in% names(x) || !("payload_data" %in% names(x))
}