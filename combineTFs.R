args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  topic = args[1]
} else {
  cat('usage: Rscript combineTFs.R <csvPath>\n', file=stderr())
  stop()
}
print(topic)

files =  list.files(path=paste("./", topic, sep = ""), pattern="*TF.csv.*", full.names=TRUE, recursive=FALSE)
print(files)
first <- 1              #flag for first iteration
for (file in files){
    if(first==1){
	TF_Main <- read.csv(file)[,2:3]         #Get only words and frequencies
	first <- 0
    }
    else{
        data <- read.csv(file)[,2:3]
	      for (i in 1:nrow(data)){
            x <- data[i,]
            if(x[1] %in% TF_Main[,1]){
                    TF_Main[i,2] = TF_Main[i,2] + x[2]
            }
            else{
                    TF_Main[nrow(TF_Main),] <- x
            }

	      }

    }
}

write.csv(TF_Main,paste0(topic,"-TF-Main.csv"))
