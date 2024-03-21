#' @export
Consumer <- R6Class("Consumer",
    public = list(
        initialize = function(config) {
            consumer_rcpp_module <- Rcpp::Module("consumer_module")
            private$consumer <- new(consumer_rcpp_module$Consumer, config)
        },
        subscribe = function(topic) {
            private$consumer$subscribe(topic)
        },
        consume = function(timeout = 1000) {
            result <- private$consumer$consume(timeout)

            message <- new_kafka_message(
                value = result$payload_data,
                key = result$key
            )

            new_kafka_result(
                message,
                result$error_code,
                result$error_message
            )
        },
        commit = function(async = FALSE) {
            private$consumer$commit(async)
        },
        unsubscribe = function() {
            private$consumer$unsubscribe()
        },
        close = function() {
            private$consumer$close()
        }
    ),
    private = list(
        consumer = NULL
    )
)
