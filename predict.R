## clean up input string

InputCleaner <- function (inText) {
    clnText <- inText
    clnText <- gsub(" #\\S*","",clnText) #remove hashtags 
    clnText <- gsub("(f|ht)(tp)(s?)(://)(\\S*)", "", clnText) #remove URLs (http, https, ftp)
    clnText <- gsub(" @[^\\s]+","",clnText) #remove twitter account 
    clnText <- iconv(clnText, "latin1", "ASCII", sub=" ") #remove non-printable
    clnText <- gsub("[^0-9A-Za-z///' ]", "", clnText) #remove all non english / non numeric 
    clnText <- tolower(clnText)
    clnText <- removePunctuation(clnText)
    clnText <- removeNumbers(clnText)
    clnText <- stripWhitespace(clnText)
    
    return(clnText)
}

PredNextWord <- function (inText) {
    inStr <- InputCleaner(inText)
    inStr <- unlist(strsplit(inStr, split = " "))
    wdCount <- length(inStr)
    
    uniFreq <- readRDS(file = "./data/uniFreq.Rds")
    biFreq <- readRDS(file = "./data/biFreq.Rds")
    triFreq <- readRDS(file = "./data/triFreq.Rds")
    
    
}