library(tm)

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
    clnText <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", clnText)
    return(clnText)
}

PredNextWord <- function (inText) {
    inStr <- InputCleaner(inText)
    inStr <- unlist(strsplit(inStr, split = " "))
    wdCount <- length(inStr)
    
    if (wdCount>=2) {
        leadWd <- inStr[(wdCount-1):wdCount] 
    } else {
        leadWd <- c(NA,inStr)
    }
    leadWd <- paste(leadWd[1],leadWd[2],sep = ' ')
    if(leadWd == ''|leadWd == "NA NA") 
        warning ('no valid text input yet')
    
    triSearch <- grepl(paste0("^",leadWd," "),triFreq$word)
    if (sum(triSearch)==0) {
        # no match in trigram
        leadWd <- unlist(strsplit(leadWd," "))[2]
        biSearch <- grepl(paste0("^",leadWd," "),biFreq$word)
        if (sum(biSearch)==0) {
            # no match in bigram, return the most common unigrams
            pred <- uniFreq[1:4,]
        } else {
            # found match in bigram
            pred <- biFreq[biSearch,]
        }        
    } else {
        # found match in trigram
        pred <- triFreq[triSearch,]        
    }
    nextWd <- strsplit(as.character(pred[,"word"]),split=paste0(leadWd," "))
    # words are in nextWd[[n]][2], so convert to dataframe and transpose
    nextWd <- unname(t(data.frame(nextWd)))[,2]
    return(nextWd)
}