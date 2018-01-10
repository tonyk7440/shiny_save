library(shiny)
library(rhandsontable)
library(data.table)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Handsontable"),
  sidebarLayout(
    sidebarPanel(
      actionButton("exportData", "Export Data")
    ),
    mainPanel(
      rHandsontableOutput("hot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  values = reactiveValues()
  
  data = reactive({
    if (is.null(input$hot)) {
      # Read in data
      message(getwd())
      MAT <- fread("input/data.csv")
    } else {
      MAT = hot_to_r(input$hot)
    }
    
    MAT
  })
  
  observe({
    hot = data()
    if (input$exportData != 0) {
      if (!is.null(hot)) {
        message("Exporting data")
        write.csv(hot, "input/data.csv")
      }
    }
  })
  
  output$hot <- renderRHandsontable({
    MAT = data()
    
    if (!is.null(MAT)) {
      hot = rhandsontable(MAT)
      
      hot
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)

