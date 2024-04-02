library(shiny)
library(rsconnect)

data <- read.csv("/cloud/project/data/Auschwitz_Death_Certificates_1942-1943 - Auschwitz.csv")

# Shiny UI
ui <- fluidPage(
  titlePanel("Auschwitz Victims by Category"),
  sidebarLayout(
    sidebarPanel(
      selectInput("category",
                  "Select Category:",
                  choices = unique(data$Religion),
                  selected = unique(data$Religion)[1])
    ),
    mainPanel(
      plotOutput("categoryPlot"),
      DTOutput("categoryTable")
    )
  )
)

# Server logic
server <- function(input, output) {
  filteredData <- reactive({
    data %>% filter(Religion == input$category)
  })
  
  output$categoryPlot <- renderPlot({
    ggplot(filteredData(), aes(x = Religion, fill = Religion)) +
      geom_bar() +
      theme_minimal() +
      labs(title = paste("Number of Victims by", input$category),
           x = input$category,
           y = "Count")
  })
  
  output$categoryTable <- renderDT({
    datatable(filteredData(), options = list(pageLength = 10))
  }, server = FALSE)
}

# Run the application
shinyApp(ui = ui, server = server)