suppressWarnings(library(shiny))

shinyUI(fluidPage(
    
    # title and top instruction
    titlePanel("Next Word Predictor"),
    
    fluidRow(strong("Capstone Project for Coursera Data Science 
                    Specialization") ),    
    fluidRow(
        br(),
        p("This Shiny app takes an input from users and uses a simple ngram back-off model to predict next word. ",
          a("HC Corpora", href = "http://www.corpora.heliohost.org")," is pre-processed to build the frequency dictionary that is then loaded to Shiny app at runtime.
          The Shiny app will provide a few suggested words, if available, besides the predicted next word to ease user experience.")),
    br(),
  
    fluidRow(strong("Enter your text below. Press \"Next Word\" button to predict the next word.") ),
    br(),
    
    # Sidebar layout
    sidebarLayout(        
        sidebarPanel(
            textInput("inText", "Enter your text",value = "e.g. Happy birthday to"),
            submitButton("Next Word")
        ),
        
        mainPanel(            
            h5("You have entered:"),
            span(style="color:red; font-weight:bold",textOutput('repInText')),
            h5("Predicted Next Word:"),
            h4(span(style="color:blue; font-weight:bold",(textOutput('predWd')))),
            h5("Other suggested words:"),
            h4(span(style="color:blue; font-weight:bold",(textOutput('sugWd'))))

        )
    )
))