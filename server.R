library(shiny)
library(shinyjs)
library(bslib)
library(markdown)
library(leaflet)
library(terra)
library(sf)
library(tidyverse)

server <- function(input, output, session){
  # tab and module-level reactives
  module <- reactive({
    input$tabs
  })
  osr <- st_transform(st_read("www/data/oil_sands_areas.shp"), crs = 4326)[-5, ]
  btnw <- st_transform(st_read("www/data/btnw_exposure.shp"), crs = 4326)
  output$map <- renderLeaflet({
    r <- rast("www/data/BTNW_can61_2020.tif")
    pal <- colorNumeric(palette = "Spectral", domain = values(r), na.color = "transparent")
    leaflet(osr) %>%
      addMapPane(name = "ground", zIndex=380) %>%
      addProviderTiles("CartoDB.Positron", group="baseMap") %>%
      # Fit bounds to BCR 6S extent
      fitBounds(lng1 = -116.0, lat1 = 50, lng2 = -105.0, lat2 = 58) |> 
      addRasterImage(r$mean, colors = "viridis", opacity = 0.8) |> 
      addPolygons(
        fillColor = NA, 
        fillOpacity = 0,
        weight = 4, 
        color = "red", 
        dashArray = "3", 
        highlightOptions = highlightOptions(weight = 5, color = "white", bringToFront = TRUE),
        label = ~Area_Name
      )
  })
  
  observeEvent(input$co_prodField, {
    r1 <- rast("www/data/BlackthroatedGreenWarbler_osr_reference.tif")
    pf <- osr |> filter(Area_Name == "Athabasca")
    b <- st_bbox(osr)
    cf <- btnw |> filter(lease_hold == "Suncor Energy Inc." & osa == "ATHABASCA")
    cf_pt <- st_centroid(cf)
    
    labels <- sprintf(
      "<strong>Lease holder: %s</strong><br/>Lease no: %s<strong><br/>Lease pop: %s</strong><br/>OSR prop: %s</strong><br/>OSR index: %s",
      cf_pt$lease_hold, cf_pt$lease, cf_pt$lease_pop, cf_pt$pop_prop, cf$index
    ) %>% lapply(htmltools::HTML)

    leafletProxy("map") |> 
      clearShapes() |> 
      addMapPane(name = "ground", zIndex=380) |> 
      addProviderTiles("CartoDB.Positron", group="baseMap") |> 
      fitBounds(lng1 = -117.91614, lat1 = 53.54062, -110.00558, lat2 = 57.99188) |> 
      addRasterImage(r1$Species, colors = "viridis", opacity = 0.8) |> 
      addPolygons(
        data = pf, 
        fillColor = NA, 
        fillOpacity = 0,
        weight = 4, 
        color = "red", 
        dashArray = "3"
      ) |> 
      addPolygons(
        data = cf, 
        fillColor = NA, 
        fillOpacity = 0,
        weight = 2, 
        color = "yellow", 
        dashArray = "3", 
        label = ~lease
      ) |> 
      addMarkers(
        data = cf_pt, 
        label = ~labels
      )
  })
  
}
