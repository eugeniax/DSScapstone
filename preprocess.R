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


str_count("one,   two three 4,,,, 5 6", "\\S+")

## clean up
