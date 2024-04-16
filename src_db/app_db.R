library(shiny)
library(bslib)
library(RPostgres)
library(shinyalert)

# Function to establish PostgreSQL connection
establish_db_connection <- function() {
  password <- readLines("/run/secrets/db-password", warn = FALSE)
  con <- dbConnect(
    RPostgres::Postgres(),
    dbname = "example",
    host = "db",
    port = 5432,
    user = "postgres",
    password = password
  )
  return(con)
}

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Hello Shiny!",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Slider for the number of bins ----
    sliderInput(
      inputId = "bins",
      label = "Number of bins:",
      min = 1,
      max = 50,
      value = 30
    )
  ),
  # Output: Histogram ----
  plotOutput(outputId = "distPlot"),
  # Output: DB Connection Message ----
  textOutput(outputId = "connection_message")
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Reactive function to handle database connection and display connection message
  con <- reactive({
    con <- establish_db_connection()
    if (dbIsValid(con)) {
      shinyalert({
        "DB CONNECTED"
      })
    } else {
      shinyalert({
        "DB CONNECTION FAILED"
      })
    }
    return(con)
  })
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    # Use the connection object returned by the reactive function
    con()
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#007bc2", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
}

shinyApp(ui = ui, server = server)
