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

## save the data to an .RData files
save(blogs, file="blogs.RData")
save(news, file="news.RData")
save(twitter, file="twitter.RData")

## for Quiz1
blogs_size <- file.size("./final/en_US/en_US.blogs.txt")/1024^2

twitter_leng <- length(twitter)

max(nchar(blogs))
max(nchar(news))
max(nchar(twitter))

love_ln <- grep("love", twitter)
hate_ln <- grep("hate", twitter)
length(love_ln)/length(hate_ln)

twitter[grep("biostats", twitter)]

twt <- "A computer once beat me at chess, but it was no match for me at kickboxing"
sum(grepl(twt,twitter))
