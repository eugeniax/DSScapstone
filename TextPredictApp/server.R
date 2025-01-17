
source("predict.R")

shinyServer(function(input, output) {
    
    predWdList <- reactive({PredNextWord(input$inText)})
    
    output$predWd <- renderText({
        predWdList()[1]        
    })
    
    output$sugWd <- renderText ({
        if (length(predWdList())>4) {
            paste(predWdList()[2:4], collapse=", ")
        } else {
            paste(predWdList()[2:length(predWdList())], collapse=", ")
        }
    })
    
    output$repInText <- renderText({
        input$inText
    })
}
)