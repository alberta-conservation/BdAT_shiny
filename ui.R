tagList(
  # The navigation bar
  navbarPage(
    theme = bslib::bs_theme(version = 4, bootswatch = "lux"),
    id = 'tabs',
    collapsible = TRUE,
    
    # Describes the top head bar with the dropdown tabs
    header = tagList(
      tags$head(tags$line(href = "css/style_blank.css", rel = "stylesheet")
                ), 
      tags$div(
        style = "position: absolute; right: 20px; top: 10px;",
        actionButton(
          "reload_btn",
          label = "Reload",
          icon = icon("refresh"),
          style = "color: white; background-color: rgb(30, 80, 85); border: none; font-size: 16px; margin-top: 8px;"
        ),
        style = "position: absolute; right: 20px; top: 10px;" # adjust position
      )
    ), 
    
  )
)




