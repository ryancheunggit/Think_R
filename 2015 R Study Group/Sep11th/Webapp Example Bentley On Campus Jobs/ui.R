library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Bentley On Campus Job Posting"),
    
    # Sidebar with a slider input for the number of bins
    fluidRow(
        tableOutput("table")
    )
))