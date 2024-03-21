#' @title Producer reference class
#'
#' @description
#' Wrapper for RdKafka::Producer
#'
#' @export
Producer <- R6Class("Producer",
    public = list(
        #' @description
        #' Create a new consumer instance
        #'
        #' @param config (`list()`)\cr
        #'   list of config values. These are passed without modification to
        #'   librdkafka
        initialize = function(config) {
            producer_rcpp_module <- Rcpp::Module("producer_module")
            private$producer <- new(producer_rcpp_module$Producer, config)
        },
        #' @description
        #' Produce message
        #'
        #' @param topic (`character`)\cr
        #'   kafka topic
        #' @param value (`character`)\cr
        #'   value of message
        #' @param key (`character`)\cr
        #'   key of message (optional)
        produce = function(topic, value, key = NULL) {
            if (!is.null(key)) {
                private$producer$produce_with_key(topic, key, value)
            } else {
                private$producer$produce(topic, value)
            }
        },
        #' @description
        #' Flush producer, i.e. send all messages currently in the
        #' queue
        #'
        #' @param timeout (`integer`)\cr
        #'   timeout in ms.
        flush = function(timeout = 1000) {
            private$producer$flush(timeout)
        }
    ),
    private = list(
        producer = NULL
    )
)
