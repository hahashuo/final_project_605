args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  csvPath = args[1]
} else {
  cat('usage: Rscript cleanData.R <csvPath>\n', file=stderr())
  stop()
}
print(csvPath)

library(textstem)   #Used for lemmatize function
library(tm)         #Used for removeWords and stopwords()

print("here")
parts <- strsplit(csvPath,"/")
file <- parts[[1]][2]

data <- read.csv(file, header = FALSE)

#Soft Cleaning
x <- data[,1]   #create temp vector to store changes

#Soft Cleaning
x <- sapply(x, function(x)  gsub("[^\x20-\x7E]", "", x))  #remove characters that are not printing characters
x <- sapply(x, function(x) gsub('([[:punct:]])', '',x))   #remove punctuation

x <- sapply(x, tolower) #makes lowercase to standardize        


#Heavy cleaning
x <- sapply(x, function(x) removeWords(x,stopwords()))    #remove the stopwords to filter quality material ------Uses textstem


x <- sapply(x, function(x) lemmatize_words(x))    #lemmatize words to standardize tenses and conjugation ------ Uses textstem


data[ , 1]  <- x     #save temp vector to dataframe


freq<-sort(table(x), decreasing=TRUE)

            
topic <- parts[[1]][1]
prefix <- paste0(topic,"-TF")

n_last <- 2                                # Specify number of characters to extract
ID <- substr(file, nchar(file) - n_last + 1, nchar(file))

suffix <- paste0('.csv.',ID)
filename <- paste0(prefix,suffix)
            
write.csv(as.data.frame(freq), file=filename)
