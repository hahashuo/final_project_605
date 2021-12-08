library(dplyr)

##################################################################################################################

format_linePlots <- function(dirName){
  files =  list.files(path=dirName, pattern = '*.csv',full.names=TRUE, recursive=FALSE)
  first <- 1
  for (file in files){
    topic <- strsplit(strsplit(file,'[.]')[[1]][1],'_')[[1]][3]   #splits string then takes a piece to split again ASSUMES data in directory cleaned_data
    if (first){
      data <- read.csv(file)[,2]
      data <- data.frame(data)
      colnames(data) <- c(topic)
      first <- 0
    }
    else{
      temp <- read.csv(file)[,2]
      data[,topic] <- temp
    }
  }
  data[,"index"] <- 1:100
  write.csv(data,"linePlot-formatData.csv")
}
format_linePlots("clean_data")
format_wordFreq <- function(dirName){
  files =  list.files(path=dirName, pattern = '*.csv',full.names=TRUE, recursive=FALSE)
  first <- 1
  for (file in files){
    topic <- strsplit(strsplit(file,'[.]')[[1]][1],'_')[[1]][3]   #splits string then takes a piece to split again ASSUMES data in directory cleaned_data
    if (first){
      data <- read.csv(file)
      data <- data.frame(data)
      colnames(data) <- c(paste0(topic,"_w"),paste0(topic,"_f"))
      first <- 0
    }
    else{
      temp <- read.csv(file)
      data[,paste0(topic,"_w")] <- temp[,1]
      data[,paste0(topic,"_f")] <- temp[,2]
    }
  }
  write.csv(data,"wordFreq-formatData.csv")  
}


scale <- function(x){
  return(x/sum(x))
}

'''
data <- data %>% 
  mutate_all(scale)
'''
##################################################################################################################################
###################################################################

data <- read.csv("linePLot-formatData.csv")

#create heatmap of chisq test of independence between topics
vars <- colnames(data)
efficientVarList <- vars
L <- length(vars)

pVals <- matrix(0, nrow = L, ncol = L, dimnames = list(vars,vars))
for (var1 in vars){
  efficientVarList <- efficientVarList[-1]
  print(length(efficientVarList))
  for (var2 in efficientVarList){
    pVals[var1,var2] <- chisq.test(data[,var1],data[,var2])$p.value
  }
}



#############################################################
#Generate theoretical distributions based off sample means to run chisq test of goodness of fit of theoretical distribution 

#Note since many tests are being run we adjust with family wise error restriction 
inv <- function(x){
  return(x^-1)
}

means <- data %>% 
  summarise_all(mean)

params_exponent <- means %>%
  mutate_all(inv)

first <- 1
for (topic in vars){
  if (first){
    theoretical_dists <- sort(rexp(100,params_exponent[,topic]),decreasing = TRUE)
    theoretical_dists <- data.frame(theoretical_dists)
    colnames(theoretical_dists) <- c(paste0("thry-",topic))
    first <- 0
  }
  else{
    temp <- sort(rexp(100,params_exponent[,topic]),decreasing = TRUE)
    theoretical_dists[,paste0("thry-",topic)] <- temp
  }
}

vars <- colnames(data)
efficientVarList <- colnames(theoretical_dists)
L <- length(vars)

pValGoodnessFit <- matrix(0, nrow = L, ncol = L, dimnames = list(vars,efficientVarList))
for (var1 in vars){
  print(length(efficientVarList))
  for (var2 in efficientVarList){
    pValGoodnessFit[var1,var2] <- chisq.test(data[,var1],theoretical_dists[,var2])$p.value
  }
  efficientVarList <- efficientVarList[-1]  #moved here to include diagonal
}








library(reshape2) #install.packages('reshape2')

melted_pVals <- melt(pVals)
melted_pValsGoodnessFit <- melt(pValGoodnessFit)



library(ggplot2)
library(paletteer)

#plot independence tests
ggplot(data = melted_pVals, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile() + theme(axis.text.x = element_text(color = "#993333", 
                                               size = 12, angle = 270)) + 
  theme(axis.text.y = element_text(color = "#993333", 
                                     size = 10)) + 
                        paletteer::scale_fill_paletteer_c("viridis::plasma")


#plot goodness of fits tests
ggplot(data = melted_pValsGoodnessFit, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile() + theme(axis.text.x = element_text(color = "#993333", 
                                                 size = 12, angle = 270)) + 
  theme(axis.text.y = element_text(color = "#993333", 
                                   size = 10)) + 
  paletteer::scale_fill_paletteer_c("viridis::plasma")
#########################################################################################################3




  