library(shiny)
library(tidyverse)
library(DT)

df <- read_csv("df.csv")

# Define UI
ui <- fluidPage(
  # Application title
  titlePanel("Table example"),
  
  # Buttons
  downloadButton("downloadData", "Download Source data"),
  downloadButton("downloadFilteredData", "Download filtered data"),
  
  # Show table
  mainPanel(
    DT::dataTableOutput(outputId = "df")
    )
  )

# Define server logic required to show table
server <- function(input, output, session) {
   
  output$df <- 
    DT::renderDataTable(
      datatable(df,
                filter = "top",
                options = list(pageLength = 100, 
                               lengthMenu = c(10,20, 50, 100, 500, 1000, 5000, 10000, 
                                              nrow(df)),
                               paging = TRUE,
                               search = list(regex = TRUE)))
    )
  
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("Source_Data", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(df, file, row.names = FALSE)
    }
  )
  
  output$filtered_row <- 
    renderPrint({
      input[["df_rows_all"]]
    })
  
  output$downloadFilteredData <- 
    downloadHandler(
      filename = "Filtered_Data.csv",
      content = function(file){
        write.csv(df[input[["df_rows_all"]], ],
                  file, row.names = FALSE)
      }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)

