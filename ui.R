library(shiny)
library(shinythemes)

ui <- navbarPage(
  theme = shinytheme("sandstone"),
  title = "Next Word Prediction App",
  
  tabPanel(
    "Predictor",
    sidebarLayout(
      sidebarPanel(
        textInput("phrase", "Enter a phrase:", value = "The quick brown", placeholder = "Type your phrase here..."),
        sliderInput("num_predictions", "Number of words to predict:", min = 1, max = 5, value = 1),
        actionButton("predict", "Predict Next Word", class = "btn-primary"),
        br(),
        br(),
        h4("Prediction History"),
        uiOutput("history")
      ),
      mainPanel(
        h3("Predicted Next Words:"),
        textOutput("prediction"),
        br(),
        h4("Frequent Predictions:"),
        tableOutput("freq_table"),
        tags$hr(),
        h4("Example Phrases:"),
        p("1. The quick brown fox"),
        p("2. She sells sea shells"),
        p("3. To be or not to be"),
        p("4. Once upon a time"),
        p("5. In a galaxy far far away")
      )
    )
  ),
  
  tabPanel(
    "About",
    mainPanel(
      h3("About This App"),
      p("This next word prediction app was created as part of the Data Science Capstone project offered by the Johns Hopkins Coursera."),
      p("This app was created using bigrams, trigrams, and quadgrams to improve predicition accuracy and is trained based on the data provided by Johns Hopkins"),
      p("This project is developed by Kritika Gowda on July 28th 2024"),
      h4("How to Use:"),
      p("1. Enter the phrase you wish to predict into the text box on the predictor tab"),
      p("2. The slider can then be used to change the number of words you would like to be predicted"),
      p("3. Click the 'Predict Next Word' button to see the prediction."),
      p("4. Afterwards, you can use the prediction history feature and the frequency table to your convenience"),
      tags$br(),
      h4("Additional Resources:"),
      tags$ul(
        tags$li(a(href = "https://rpubs.com/kgowda1/1206009", "View Presentation Explaining App Here")),
        tags$li(a(href = "https://github.com/Azvasana/DSCapstone", "View Code Used on GitHub Here"))
      )
    )
  )
)
