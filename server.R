

server <- function(input, output, session){
  # tab and module-level reactives
  module <- reactive({
    input$tabs
  })
  
}
