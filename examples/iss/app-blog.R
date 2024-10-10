library(shiny)
library(leaflet)
library(jsonlite)
library(kafka)

ui <- fluidPage(
    leafletOutput("iss_map", height = "80vh")
)

server <- function(input, output, session) {
    consumer <- Consumer$new(list(
        "bootstrap.servers" = "localhost:9093",
        "group.id" = paste(sample(letters, 10), collapse = ""),
        "enable.auto.commit" = "True"
    ))

    consumer$subscribe("iss")

    iss_position <- reactive({
        on.exit(invalidateLater(0))
        message <- result_message(consumer$consume(5000))
        if (!is.null(message$value)) {
            data <- fromJSON(message$value)
            list(
                latitude = as.numeric(data$iss_position$latitude),
                longitude = as.numeric(data$iss_position$longitude)
            )
        }
    })

    output$iss_map <- renderLeaflet({
        leaflet(options = leafletOptions(zoomSnap = 0.1, zoomDelta = 0.1)) %>%
            addProviderTiles(providers$Esri.WorldImagery) %>%
            setView(lng = 0, lat = 0, zoom = 2.3)
    })

    observe({
        if (is.null(iss_position())) {
            return()
        }

        leafletProxy("iss_map") %>%
            clearMarkers() %>%
            addMarkers(
                lng = iss_position()$longitude,
                lat = iss_position()$latitude,
                icon = makeIcon(
                    iconUrl = "https://img.icons8.com/?size=100&id=7ThZQJ5wZJ2T&format=png&color=000000",
                    iconWidth = 30, iconHeight = 30
                )
            )
    })

    session$onSessionEnded(function() {
        consumer$close()
    })
}

shinyApp(ui = ui, server = server)
