#' Consumer reference class
#'
#' @export
Consumer <- R6Class("Consumer",
    public = list(
        #' @description
        #' Create a new consumer instance
        #'
        #' @param config (`list()`)\cr
        #'   list of config values. These are passed without modification to
        #'   librdkafka
        initialize = function(config) {
            consumer_rcpp_module <- Rcpp::Module("consumer_module")
            private$consumer <- new(consumer_rcpp_module$Consumer, config)
        },
        #' @description
        #' Subscribe to topic
        #'
        #' @param topic (`character`)\cr
        #'   kafka topic
        subscribe = function(topic) {
            private$consumer$subscribe(topic)
        },
        #' @description
        #' Consume single message
        #'
        #' @param timeout (`integer`)\cr
        #'   timeout in ms.
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
        #' @description
        #' Commit current offset
        #'
        #' @param async (`logical`)\cr
        #'   commit async
        commit = function(async = FALSE) {
            private$consumer$commit(async)
        },
        #' @description
        #' Unsubscribe from current topic
        unsubscribe = function() {
            private$consumer$unsubscribe()
        },
        #' @description
        #' Close consumer
        close = function() {
            private$consumer$close()
        }
    ),
    private = list(
        consumer = NULL
    )
)
