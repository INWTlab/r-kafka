#' @export
Producer <- R6Class("Consumer",
    public = list(
        initialize = function(config) {
            producer_rcpp_module <- Rcpp::Module("producer_module")
            private$producer <- new(producer_rcpp_module$Producer, config)
        },
        produce = function(topic, value, key = NULL) {
            if (!is.null(key)) {
                private$producer$produce_with_key(topic, key, value)
            } else {
                private$producer$produce(topic, value)
            }
        },
        flush = function(timeout = 1000) {
            private$producer$flush(timeout)
        },
        close = function() {
            private$producer$close()
        }
    ),
    private = list(
        producer = NULL
    )
)