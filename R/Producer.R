#' Create Kafka Producer
#' 
#' @details This function creates an instance of a Kafka Producer based on a list with configuration options. The following methods are currently implemented: ...
#' 
#' @examples
#' \dontrun{
#' config <- list(
#'     "bootstrap.servers" = "my-boostrap-server.com"
#' )
#' 
#' producer <- Producer(config)
#' 
#' producer$produce(topic = "test-topic", message = "Hello World!")
#' 
#' producer$flush(1000)
#' }
#' @param config list with configuration options accepted by librdkafka. See https://github.com/confluentinc/librdkafka/blob/master/CONFIGURATION.md for details.
#'
#' @return A kafka producer object. See details for currently available methods
#' @export
Producer <- function(config) {
    producer_rcpp_module <- Rcpp::Module("producer_module")

    new(producer_rcpp_module$Producer, config)
}