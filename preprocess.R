
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

## summarize training data
library(stringr)
size_blogs <- file.size("./final/en_US/en_US.blogs.txt")/1024^2
size_news <- file.size("./final/en_US/en_US.news.txt")/1024^2
size_twitter <- file.size("./final/en_US/en_US.twitter.txt")/1024^2
wdcount_blogs <- str_count(blogs, "\\S+")
wdcount_news <- str_count(news, "\\S+")
wdcount_twitter <- str_count(twitter, "\\S+")
lines_blogs <- length(blogs)
lines_news <- length(news)
lines_twitter <- length(twitter)

dataSummary <- data.frame(
    fileName = c("Blogs","News","Twitter"),
    fileSize = c(round(size_blogs, digits = 2), 
                 round(size_news,digits = 2), 
                 round(size_twitter, digits = 2)),
    lineCount = c(lines_blogs,lines_news,lines_twitter),
    wordCount = c(sum(wdcount_blogs),sum(wdcount_news),sum(wdcount_twitter)),
    maxWords = c(max(wdcount_blogs),max(wdcount_news),max(wdcount_twitter)),
    minWords = c(min(wdcount_blogs),min(wdcount_news),min(wdcount_twitter)),
    meanWords = c(mean(wdcount_blogs),mean(wdcount_news),mean(wdcount_twitter))
)
dataSummary

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
library(RWeka)
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

library(wordcloud)
wordcloud(corpus, scale=c(5,0.5), max.words=100, 
          random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, 
          colors=brewer.pal(8, "Dark2"))

## ngrams
# #op1: too slow
# sample_df <- data.frame(text=unlist(sapply(corpus, '[',"content")),stringsAsFactors=F)
# token_delim <- " \\t\\r\\n.!?,;\"()"
# UnigramTokenizer <- NGramTokenizer(sample_df, Weka_control(min=1,max=1))
# BigramTokenizer <- NGramTokenizer(sample_df, Weka_control(min=2,max=2, delimiters = token_delim))
# TrigramTokenizer <- NGramTokenizer(sample_df, Weka_control(min=3,max=3, delimiters = token_delim))
# 
# unigramTable <- data.frame(table(UnigramTokenizer))
# bigramTable <- data.frame(table(BigramTokenizer))
# trigramTable <- data.frame(table(TrigramTokenizer)) 
# 
# unigramTable <- unigramTable[order(unigramTable$Freq,decreasing = TRUE),]
# bigramTable <- bigramTable[order(bigramTable$Freq,decreasing = TRUE),]
# trigramTable <- trigramTable[order(trigramTable$Freq,decreasing = TRUE),]

#op2
# ## Support Tokenization for bigrams and trigrams (Create functions off NGramTokenizer)
# UnigramTokenizer <- function(x) NGramTokenizer(x, control = Weka_control(min = 1, max = 1))
# BigramTokenizer  <- function(x) NGramTokenizer(x, control = Weka_control(min = 2, max = 2))
# TrigramTokenizer <- function(x) NGramTokenizer(x, control = Weka_control(min = 3, max = 3))
# ## Create the term document matrices for unigrams, bigrams and trigrams
# tdmUnigram <- TermDocumentMatrix(corpus, control = list(tokenize = UnigramTokenizer))
# tf <- sort(rowSums(as.matrix(tdmUnigram)), decreasing=TRUE)
# tdmUnigram <- data.frame(term=names(tf), frequency=tf)
# tdmBigram <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
# tf2 <- sort(rowSums(as.matrix(tdmBigram)), decreasing=TRUE)
# tdmBigram <- data.frame(term=names(tf2), frequency=tf2)
# tdmTrigram <- TermDocumentMatrix(x = corpus, control = list(tokenize = TrigramTokenizer))
# tf3 <- sort(rowSums(as.matrix(tdmTrigram)), decreasing=TRUE)
# tdmTrigram <- data.frame(term=names(tf3), frequency=tf3)

#op3
library(tau)
unigrams <- textcnt(sample_df, method="string",n=1,split = "[[:space:]]+", decreasing=TRUE)
unigrams <- data.frame(freq = unclass(unigrams))
bigrams <- textcnt(sample_df, method="string",n=2,split = "[[:space:]]+", decreasing=TRUE)
bigrams <- data.frame(freq = unclass(bigrams))
trigrams <- textcnt(sample_df, method="string",n=3,split = "[[:space:]]+", decreasing=TRUE)
trigrams <- data.frame(freq = unclass(trigrams))

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

## plot ngram distribution
library(ggplot2)
ggplot(head(unigramFreq,20), aes(x=reorder(word,freq), y=freq, fill=freq)) +
    geom_bar(stat="identity") +
    theme_bw() +
    coord_flip() +
    theme(axis.title.y = element_blank()) +
    labs(y="Frequency", title="Most Frequent Unigrams in Sampled Text")

ggplot(head(bigramFreq,20), aes(x=reorder(word,freq), y=freq, fill=freq)) +
    geom_bar(stat="identity") +
    theme_bw() +
    coord_flip() +
    theme(axis.title.y = element_blank()) +
    labs(y="Frequency", title="Most Frequent Bigrams in Sampled Text")

ggplot(head(trigramFreq,20), aes(x=reorder(word,freq), y=freq, fill=freq)) +
    geom_bar(stat="identity") +
    theme_bw() +
    coord_flip() +
    theme(axis.title.y = element_blank()) +
    labs(y="Frequency", title="Most Frequent Trigrams in Sampled Text")