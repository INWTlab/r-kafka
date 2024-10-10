library(httr)
library(jsonlite)
library(kafka)


config <- list(
    "bootstrap.servers" = "localhost:9093"
)
producer <- Producer$new(config)
url <- "http://api.open-notify.org/iss-now.json"


fetch_and_produce_iss_data <- function(topic) {
    tryCatch(
        {
            response <- GET(url)


            if (status_code(response) == 200) {
                json_content <- content(response, as = "parsed", encoding = "UTF-8")
                json_string <- toJSON(json_content, auto_unbox = TRUE)
                producer$produce(topic, json_string)
                producer$flush()
                print(paste("Produced message to topic", topic, ":", json_string))
            } else {
                print(paste("Request failed with status code:", status_code(response)))
            }
        },
        error = function(e) {
            print(paste("Error occurred:", e$message))
        }
    )
}


while (TRUE) {
    fetch_and_produce_iss_data("iss")
    Sys.sleep(3)
}
