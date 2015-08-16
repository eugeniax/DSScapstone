
## load 3 English corpus
zipURL <- "http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
if (!file.exists("Coursera-SwiftKey.zip")) 
    download.file(zipURL, destfile = "Coursera-SwiftKey.zip")
unzip("Coursera-SwiftKey.zip")

blogs <- readLines("./final/en_US/en_US.blogs.txt", encoding="UTF-8", skipNul=TRUE)

file_news <- file("./final/en_US/en_US.news.txt", "rb")
news <- readLines(file_news, encoding="UTF-8", skipNul=TRUE)
close(file_news)
rm(file_news)

twitter <- readLines("./final/en_US/en_US.twitter.txt", encoding="UTF-8", skipNul=TRUE)


## sampling
set.seed(123)
sampleBlogs <- sample(blogs, length(blogs)*0.01)
sampleNews <- sample(news, length(news)*0.01)
sampleTw <- sample(twitter, length(twitter)*0.01)
sampleText <- c(sampleBlogs,sampleNews,sampleTw)
length(sampleText)

## save & load
# save(blogs, file="blogs.RData")
# save(news, file="news.RData")
# save(twitter, file="twitter.RData")
# save(sampleText,file="sampleRaw.RData")
# load("blogs.RData")
# load("news.RData")
# load("twitter.RData")

## clean up
library(tm)
#profanity lib
profURL <- "http://www.bannedwordlist.com/lists/swearWords.csv"
download.file(profURL, destfile = "swearWords.csv")
profanity <- c(t(read.csv("swearWords.csv",header=F)))

sampleText <- gsub(" #\\S*","",sampleText) #remove hashtags 
sampleText <- gsub("(f|ht)(tp)(s?)(://)(\\S*)", "", sampleText) #remove URLs (http, https, ftp)
sampleText <- gsub(" @[^\\s]+","",sampleText) #remove twitter account 
sampleText <- iconv(sampleText, "latin1", "ASCII", sub=" ") #remove non-printable
# sampleText <- gsub("[^0-9A-Za-z///' ]", "", sampleText) #remove all non english / non numeric 
corpus<-Corpus(VectorSource(sampleText))
corpus<-tm_map(corpus, content_transformer(tolower))
corpus<-tm_map(corpus, removePunctuation)
corpus<-tm_map(corpus, removeNumbers)
corpus<-tm_map(corpus, stripWhitespace)
corpus<-tm_map(corpus, removeWords, profanity)
#inspect(corpus[1:3])
# save(corpus,file="corpus.RData")


## ngrams
library(tau)
# unigrams <- textcnt(sample_df, method="string",n=1,split = "[[:space:]]+", decreasing=TRUE)
# unigrams <- data.frame(freq = unclass(unigrams))
# bigrams <- textcnt(sample_df, method="string",n=2,split = "[[:space:]]+", decreasing=TRUE)
# bigrams <- data.frame(freq = unclass(bigrams))
# trigrams <- textcnt(sample_df, method="string",n=3,split = "[[:space:]]+", decreasing=TRUE)
# trigrams <- data.frame(freq = unclass(trigrams))
sample_df <- data.frame(text=unlist(sapply(corpus, '[',"content")),stringsAsFactors=F)
tokenize_ngrams <- function(x, n=3) {
    return(textcnt(x,method="string",n=n,decreasing=TRUE))}
unigrams <- tokenize_ngrams(sample_df,n=1)
bigrams <- tokenize_ngrams(sample_df,n=2)
trigrams <- tokenize_ngrams(sample_df,n=3)

freq_tb <- function(txtcnt){
    return(data.frame(word=rownames(as.data.frame(unclass(txtcnt))),
                      freq=unclass(txtcnt)))}
unigramFreq <- freq_tb(unigrams)
bigramFreq <- freq_tb(bigrams)
trigramFreq <- freq_tb(trigrams)

## trim n-gram tables, then save to Rds files
library(dplyr)
uniFreq <- filter(unigramFreq, freq>1)
biFreq <- filter(bigramFreq, freq>1)
triFreq <- filter(trigramFreq, freq>1)

saveRDS(uniFreq, file = "./data/uniFreq.Rds")
saveRDS(biFreq, file = "./data/biFreq.Rds")
saveRDS(triFreq, file = "./data/triFreq.Rds")