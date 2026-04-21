
tagList(
  navbarPage(
    theme = bslib::bs_theme(version = 5, bootswatch = "lux"),
    id = 'tabs',
    collapsible = TRUE,
    
    # Describes the top header bar with tabs
    header = tagList(
      tags$head(tags$link(href = "css/style_blank.css", rel = "stylesheet")
      )
    ),
    title = HTML('<div style="margin-top: 0px;"><a href="https://github.com/alberta-conservation" target="_blank"><img src="abc-program-logo.png" height="50"></a></div>'),
    windowTitle = "OSR Biodiversity Assessment tool",
    tabPanel("Welcome", value = 'intro'),
    tabPanel("Species description", value = 'spp'),
    tabPanel("Vulnerability assessment", value = 'vulnerability'),
    tabPanel("Risk Assessment", value = 'risk'),
    tabPanel("Recommendations", value = 'recommendations')
  ), 
  
  tags$div(
    
    shinyjs::useShinyjs(),
    
    # Intro tab
    conditionalPanel(
      condition="input.tabs == 'intro'",
      div(style = "background-color: white; width: 100vw; margin: 0; padding: 0; display: flex; justify-content: center;",
          tags$img(src = "osr.png", height = "300px",  style = "display: block; object-fit: contain; width: 100%; max-width: none;")),
      
      fluidRow(
        column(3, layout_sidebar(
          sidebar = sidebar(
            position = "left",
            selectInput(
              "spp",
              "Select a species:",
              choices = c("Black-throated Green Warbler" = "btnw", 
                          "Ovenbird" = "oven", 
                          "Canada Warbler" = "cawa", 
                          "Swainson's Thrush" = "swth", 
                          "Ruby-crowned Kinglet" = "rcki", 
                          "Alder Flycatcher" = "alfl"),
              selected = "btnw"
            )
          )
        )),
        
        column(9, div(id = "markdown-content", includeMarkdown("Rmd/text_intro_tab.Rmd")))
      )
    ), 
  
  # Layout for species tab
  conditionalPanel(
    condition = "input.tabs == 'spp'",
    fluidRow(
      column(12, 
             conditionalPanel(
               condition = "input.tabs == 'spp'",
               div(id = "markdown-content", includeMarkdown("Rmd/text_spp_btnw.Rmd")))
      )
    )
  ),
  
  # Layout for vulnerability tab 
  conditionalPanel(
    condition = "input.tabs == 'vulnerability' || input.tabs == 'risk'", 
    fluidRow(
      column(3, 
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'", 
               tabsetPanel(
                 tabPanel("Tool", 
                          checkboxGroupInput(
                            inputId = "prod_field",
                            label = "Choose the Oil Sands Area:",
                            choices = c("All", "Athabasca", "Cold Lake", "Peace River Area 1", "Peace River Area 2"),
                            selected = "Athabasca" # Optional: pre-select an item
                          ), 
                          selectInput(
                            inputId = "app_holder", 
                            label = "Select a lease holder:", 
                            choices = c("All", "Canada Natural Resources Limited", "Suncor Energy Inc.", "Surmont Energy Ltd."), 
                            selected = "Suncor Energy Inc."
                          ), 
                          actionButton(inputId = "co_prodField", 
                                       label = "Show selected AOI and leases", 
                                       icon = icon(name = "fas fa-crow", lib = "font-awesome"), 
                                       style="width:200px")
                 ), 
                 tabPanel("Instructions", 
                          icon = icon("circle-info"), 
                          div(style = "color: white !important; font-size: 14px; font-family: 'Cormorant Garamond', serif;", 
                              includeMarkdown("./Rmd/gtext_exposure.Rmd")
                          )
                 )
               )
               ), 
             conditionalPanel(
               condition = "input.tabs == 'risk'", 
               tabsetPanel(
                 tabPanel("Tool", 
                          checkboxGroupInput(
                            inputId = "prod_field",
                            label = "Choose the Oil Sands Area:",
                            choices = c("All", "Athabasca", "Cold Lake", "Peace River Area 1", "Peace River Area 2"),
                            selected = "Athabasca" # Optional: pre-select an item
                          ), 
                          selectInput(
                            inputId = "app_holder", 
                            label = "Select a lease holder:", 
                            choices = c("All", "Canada Natural Resources Limited", "Suncor Energy Inc.", "Surmont Energy Ltd."), 
                            selected = "Suncor Energy Inc."
                          ), 
                          actionButton(inputId = "co_prodField", 
                                       label = "Show selected AOI and leases", 
                                       icon = icon(name = "fas fa-crow", lib = "font-awesome"), 
                                       style="width:200px")
                 ), 
                 tabPanel("Instructions", 
                          icon = icon("circle-info"), 
                          div(style = "color: white !important; font-size: 14px; font-family: 'Cormorant Garamond', serif;", 
                              includeMarkdown("./Rmd/gtext_risk.Rmd")
                          )
                 )
               )
             )
             ), 
      column(6, 
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'", 
               tabsetPanel(id ="centerPanel",
                           tabPanel("Reference Exposure", 
                                    leafletOutput(outputId = "map", width = "100%", height = "400px") 
                           ),
                           tabPanel("Current Exposure",
                                    leafletOutput(outputId = "map_current", width = "100%", height = "400px")
                           ) 
               )
             ), 
             conditionalPanel(
               condition = "input.tabs == 'risk'", 
               tabsetPanel(
                           tabPanel("Density distributions", 
                                    tags$img(src = "data/oven_density.png", width = "100%", height = "auto")
                           ),
                           tabPanel("Risk estimates",
                                    tags$img(src = "data/oven_decline_5pct.png", width = "100%", height = "auto")
                           ) 
               )
             )
      ), 
      column(3, 
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'",
               div(id = "markdown-content", includeMarkdown("Rmd/data_download_tab.md")), 
               actionButton(inputId = "dwnld_dta", label = "Download Data", icon = icon(name = "fas fa-crow", lib = "font-awesome"), tyle="width:250px")
             ), 
             conditionalPanel(
               condition = "input.tabs == 'risk'",
               div(id = "markdown-content", includeMarkdown("Rmd/risk_download_tab.md")), 
               actionButton(inputId = "dwnld_dta", label = "Download Data", icon = icon(name = "fas fa-crow", lib = "font-awesome"), tyle="width:250px")
             )
             ), 
      column(12,  
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'",
               div(id = "markdown-content", includeMarkdown("Rmd/text_vulnerability_tab.md"))
               )
      )
    )
  )
  )
)




