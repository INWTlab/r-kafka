library(shiny)
library(leaflet)
library(jsonlite)
library(kafka)


consumer <- Consumer$new(list(
    "bootstrap.servers" = "localhost:9093",
    "auto.offset.reset" = "earliest",
    "group.id" = paste(sample(letters, 10), collapse = ""),
    "enable.auto.commit" = "True"
))


consumer$subscribe("iss")


ui <- fluidPage(
    tags$head(
        tags$style(HTML("
           body {
               font-family: 'Montserrat', Arial, sans-serif;
               background-color: #ffffff;
               margin: 20px;
           }
           #iss_map {
               margin-bottom: 30px;
               border: 5px solid #5f6173;
               border-radius: 5px;
           }
           .leaflet-container {
               height: 75vh !important;
               width: 100%;
           }
           .header-container {
               display: flex;
               justify-content: space-between;
               align-items: center;
               margin-bottom: 20px;
               padding: 10px;
               background-color: #5f6173;
               color: #f4f4f4;
               border-radius: 5px;
           }
           .title {
               font-size: 30px;
               margin-left: 10px;
           }
           .controls {
               margin-right: 10px;
           }
       "))
    ),
    div(
        class = "header-container",
        div(class = "title", "Real-Time ISS Location Tracker"),
        div(class = "controls", numericInput("trail_length", "Trail Length", 100, 10, 1000))
    ),
    leafletOutput("iss_map", height = "80vh")
)


iss_position <- reactiveValues(
    lat = NA,
    lon = NA,
    trail = data.frame(lat = numeric(0), lon = numeric(0))
)


consume_message <- function() {
    consumer$consume(10)
}


server <- function(input, output, session) {
    last_update <- reactiveVal(NULL)
    trail_window <- reactive({
        start <- max(1, nrow(iss_position$trail) - input$trail_length)
        iss_position$trail[start:nrow(iss_position$trail), ]
    })




    observe({
        msg <- consume_message()$message
        if (!is.null(msg$value)) {
            data <- fromJSON(msg$value)
            iss_position$lat <- as.numeric(data$iss_position$latitude)
            iss_position$lon <- as.numeric(data$iss_position$longitude)


            iss_position$trail <- rbind(iss_position$trail, data.frame(lat = iss_position$lat, lon = iss_position$lon))
            if (nrow(iss_position$trail) > 1000) {
                iss_position$trail <- tail(iss_position$trail, 1000)
            }
        }


        if (is.null(msg$value)) {
            invalidateLater(1000)
        } else {
            last_update(Sys.time())
            invalidateLater(0)
        }
    })


    output$iss_map <- renderLeaflet({
        leaflet(options = leafletOptions(zoomSnap = 0.1, zoomDelta = 0.1)) %>%
            addProviderTiles(providers$Esri.WorldImagery) %>%
            setView(lng = 0, lat = 0, zoom = 2.3)
    })






    observe({
        if (is.null(last_update()) || last_update() > Sys.time() - 0.1) {
            invalidateLater(200)
            return()
        }


        if (!is.na(iss_position$lat) && !is.na(iss_position$lon)) {
            leafletProxy("iss_map") %>%
                clearMarkers() %>%
                clearShapes() %>%
                addMarkers(
                    lng = iss_position$lon,
                    lat = iss_position$lat,
                    popup = paste0("<b>ISS Position</b><br>Lat: ", round(iss_position$lat, 4), "<br>Lon: ", round(iss_position$lon, 4)),
                    icon = makeIcon(
                        iconUrl = "https://img.icons8.com/?size=100&id=7ThZQJ5wZJ2T&format=png&color=000000",
                        iconWidth = 30, iconHeight = 30
                    )
                )


            valid_trail <- trail_window()
            for (i in 2:nrow(valid_trail)) {
                if (sign(valid_trail$lon[i - 1]) == sign(valid_trail$lon[i])) {
                    leafletProxy("iss_map") %>%
                        addPolylines(
                            lng = valid_trail$lon[(i - 1):i],
                            lat = valid_trail$lat[(i - 1):i],
                            color = "#ffffff",
                            opacity = 1
                        )
                }
            }
        }
    })


    session$onSessionEnded(function() {
        consumer$close()
    })
}


shinyApp(ui = ui, server = server)
