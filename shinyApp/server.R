
source("./predict.R")

uniFreq <- readRDS(file = "./data/uniFreq.Rds")
biFreq <- readRDS(file = "./data/biFreq.Rds")
triFreq <- readRDS(file = "./data/triFreq.Rds")

shinyServer(function(input, output) {
    
    predWdList <- reactive({PredNextWord(input$inText)})
    
    output$predWd <- renderText({
        predWdList()[1]        
    })
    
    output$sugWd <- renderText ({
        if (length(predWdList())>4) {
            paste(predWdList()[2:4], sep=", ")
        } else {
            paste(predWdList()[2:length(predWdList())], sep=", ")
        }
    })
    
    output$repInText <- renderText({
        input$inText
    })
}
)