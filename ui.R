
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
              choices = c("Black-throated green warbler")
            )
          )
        )),
        
        column(9, div(id = "markdown-content", includeMarkdown("Rmd/text_intro_tab.md")))
      )
    )
  ),
  
  # Layout for species tab
  conditionalPanel(
    condition = "input.tabs == 'spp' || input.tabs == 'vulnerability'",
    fluidRow(
      column(12, 
             conditionalPanel(
               condition = "input.tabs == 'spp'",
               div(id = "markdown-content", includeMarkdown("Rmd/text_spp_tab.md")))
      )
    )
  ),
  
  # Layout for vulnerability tab 
  conditionalPanel(
    condition = "input.tabs == 'vulnerability'", 
    fluidRow(
      column(12, div(id = "markdown-content", includeMarkdown("Rmd/text_vulnerability_tab.md")))
    )
  )
  
)




