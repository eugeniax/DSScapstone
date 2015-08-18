suppressWarnings(library(shiny))

shinyUI(fluidPage(
    
    # title and top instruction
    titlePanel("Next Word Predictor"),
    
    fluidRow(strong("Capstone Project for Coursera Data Science 
                    Specialization") ),    
    fluidRow(
        br(),
        p("This Shiny app takes an input from users and uses a simple ngram back-off model to predict next word. 
          HC Corpora is pre-processed to build the frequency dictionary that is then loaded to Shiny app at runtime.
          The Shiny app will provide a few suggested words, if available, besides the predicted next word to ease user experience.")),
    br(),
  
    fluidRow(strong("Enter at least 2 words. Press \"Next Word\" button to predict the next word.") ),
    br(),
    
    # Sidebar layout
    sidebarLayout(        
        sidebarPanel(
            textInput("inText", "Enter your text here",value = "input text..."),
            submitButton("Next Word")
        ),
        
        mainPanel(
            h3("Predicted Next Word:"),
            textOutput('predWd'),
            h4("Other suggested words:"),
            textOutput('sugWd'),
            h3("You have entered:"),
            textOutput('repInText')
        )
    )
))