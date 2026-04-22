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
  btnw <- st_transform(readRDS("www/data/btnw_exposure.rds"), crs = 4326)
  btnw_current <- st_transform(readRDS("www/data/btnw_exposure_current.rds"), crs = 4326)
  bcr <- st_transform(st_read("www/data/BCR6S.shp"), crs = 4326)
  bcr_exp <- st_transform(readRDS("www/data/bcr_exposure.rds"), crs = 4326)
  
  labels_bcr6s <- sprintf(
    "<strong>BCR 6S pop: %s</strong><br/>OSR pop: %s<strong><br/>OSR pct: %s</strong><br/>OSR index: %s",
    bcr_exp$bcr_pop, bcr_exp$osr_pop, bcr_exp$osr_pct, bcr_exp$osr_index
  ) %>% lapply(htmltools::HTML)
  
  output$map <- renderLeaflet({
    r <- rast("www/data/BTNW_can61_2020.tif")
    pal <- colorNumeric(palette = "Spectral", domain = values(r), na.color = "transparent")
    leaflet() %>%
      addMapPane(name = "ground", zIndex=380) %>%
      addProviderTiles("CartoDB.Positron", group="baseMap") %>%
      # Fit bounds to BCR 6S extent
      fitBounds(lng1 = -116.0, lat1 = 50, lng2 = -105.0, lat2 = 58) |> 
      addRasterImage(r$mean, colors = "viridis", opacity = 0.8) |> 
      addPolygons(
        data = bcr_exp, 
        fillColor = NA, 
        fillOpacity = 0, 
        weight = 1, 
        color = "black", 
        label = ~labels_bcr6s
      ) |> 
      addPolygons(
        data = osr, 
        fillColor = NA, 
        fillOpacity = 0,
        weight = 4, 
        color = "red", 
        dashArray = "3", 
        highlightOptions = highlightOptions(weight = 5, color = "white", bringToFront = TRUE),
        label = ~Area_Name
      )
  })
  
  output$map_current <- renderLeaflet({
    rc <- rast("www/data/BlackthroatedGreenWarbler_osr_current.tif")
    pal <- colorNumeric(palette = "Spectral", domain = values(rc), na.color = "transparent")
    leaflet() %>%
      addMapPane(name = "ground", zIndex=380) %>%
      addProviderTiles("CartoDB.Positron", group="baseMap") %>%
      # Fit bounds to BCR 6S extent
      fitBounds(lng1 = -117.91614, lat1 = 53.54062, -110.00558, lat2 = 57.99188) |> 
      addRasterImage(rc$Species, colors = "viridis", opacity = 0.8)
  })
  
  
  observeEvent(input$co_prodField, {
    r1 <- rast("www/data/BlackthroatedGreenWarbler_osr_reference.tif")
    rc <- rast("www/data/BlackthroatedGreenWarbler_osr_current.tif")
    pf <- osr |> filter(Area_Name == "Athabasca")
    b <- st_bbox(osr)
    cf <- btnw |> filter(lease_holder == "Suncor Energy Inc." & osa == "ATHABASCA")
    cf_pt <- st_centroid(cf)
    cfc <- btnw_current |> filter(lease_holder == "Suncor Energy Inc." & osa == "ATHABASCA")
    cfc_pt <- st_centroid(cfc)
    
    labels <- sprintf(
      "<strong>Lease holder: %s</strong><br/>Lease no: %s<strong><br/>Lease pop: %s</strong><br/>OSR pct: %s</strong><br/>OSR index: %s",
      cf_pt$lease_holder, cfc_pt$lease, cfc_pt$lease_pop, cfc_pt$pop_pct, cf$index
    ) %>% lapply(htmltools::HTML)
    
    labels_current <- sprintf(
      "<strong>Lease holder: %s</strong><br/>Lease no: %s<strong><br/>Lease pop: %s</strong><br/>OSR pct: %s</strong><br/>OSR index: %s",
      cfc_pt$lease_holder, cf_pt$lease, cf_pt$lease_pop, cf_pt$pop_pct, cf$index
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
    
    leafletProxy("map_current") |> 
      clearShapes() |> 
      addMapPane(name = "ground", zIndex=380) |> 
      addProviderTiles("CartoDB.Positron", group="baseMap") |> 
      fitBounds(lng1 = -117.91614, lat1 = 53.54062, -110.00558, lat2 = 57.99188) |> 
      addRasterImage(rc$Species, colors = "viridis", opacity = 0.8) |> 
      addPolygons(
        data = pf, 
        fillColor = NA, 
        fillOpacity = 0,
        weight = 4, 
        color = "red", 
        dashArray = "3"
      ) |> 
      addPolygons(
        data = cfc, 
        fillColor = NA, 
        fillOpacity = 0,
        weight = 2, 
        color = "yellow", 
        dashArray = "3", 
        label = ~lease
      ) |> 
      addMarkers(
        data = cfc_pt, 
        label = ~labels_current
      )
  })
  
}
