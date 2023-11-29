#' Consumer
#'
#' @param config (list)
#'
#' @export
Consumer <- function(config) {
    consumer_rcpp_module <- Rcpp::Module("consumer_module")

    new(consumer_rcpp_module$Consumer, config)
}
