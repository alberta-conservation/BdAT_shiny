library(shiny)
library(shinyjs)
library(bslib)
library(markdown)
library(leaflet)

server <- function(input, output, session){
  # tab and module-level reactives
  module <- reactive({
    input$tabs
  })
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>% # Add default OpenStreetMap tiles
      setView(lng = -74.0060, lat = 40.7128, zoom = 12) %>% # Set initial view
      addMarkers(lng = -74.0060, lat = 40.7128, popup = "Hello, world!")
  })
}
