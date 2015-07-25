library(stringr)

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
wdcount_blogs <- str_count(blogs, "\\S+")
wdcount_news <- str_count(news, "\\S+")
wdcount_twitter <- str_count(twitter, "\\S+")
lines_blogs <- length(blogs)
lines_news <- length(news)
lines_twitter <- length(twitter)

## sampling
set.seed(123)
sampleBlogs <- sample(blogs, length(blogs)*0.01)
sampleNews <- sample(news, length(news)*0.01)
sampleTw <- sample(twitter, length(twitter)*0.01)
sampleText <- c(sampleBlogs,sampleNews,sampleTw)
length(sampleText)

## clean up
