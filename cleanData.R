args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  csvPath = args[1]
} else {
  cat('usage: Rscript cleanData.R <csvPath>\n', file=stderr())
  stop()
}
print(csvPath)

library(textstem)   #Used for lemmatize function
print("here")
