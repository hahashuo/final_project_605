#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(paletteer)
library(wordcloud)  #install.packages('Rcpp')   install.packages('wordcloud')
library(reshape2) #install.packages('reshape2')
library(tidyverse)
library(visNetwork)
library(stringr)

curvePlotsData <- read.csv("linePLot-formatData.csv")
curvePlotsData <- curvePlotsData[,-1] #remove needless index variable

wordFreqData <- read.csv("wordFreq-formatData.csv")
wordFreqData <- wordFreqData[,-1] #remove needless index variable


plot_topic_curve <- function(topic,data){
    ggplot(data, aes(x=index,y=data[,topic]))+ geom_line()
}

inv <- function(x){
    return(x^-1)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({
        n <- length(input$topics)
        if (n != 0){
            L <- 100
            
            bundle <- c()
            bundle_tags <- c()
            for (topic in input$topics){
                bundle <- append(bundle,curvePlotsData[,topic])
                bundle_tags <- append(bundle_tags,rep.int(topic, L))
            }
            
            test <- data.frame(Rank = rep.int(1:100,n),Freq = bundle, 
                               Topic = bundle_tags) #bundle for ggplot 
            
            ggplot(test,aes(Rank,Freq,col=Topic))+geom_line()
        }#Close if statement
    }) #Close line-plot
    
    
    output$mostFreq <- renderTable({
        n <- length(input$topicsFreq)
        if (n != 0){
            names <- c()
            for (topic in input$topicsFreq){
                names <- append(names,paste0(topic,"_w"))
                names <- append(names,paste0(topic,"_f"))
                
            }
            wordFreqData %>% head(input$numRows) %>%
                select(names)
        }
    }) #close table select
    
    output$pValPlot <- renderPlot({
        if (input$test == "Independence"){
            n <- length(input$topicsInference)
            if(n > 1){
                vars <- sapply(input$topicsInference, paste0,"_f")
                efficientVarList <- vars
                pVals <- matrix(0, nrow = n, ncol = n, dimnames = list(vars,vars))
                for (var1 in vars){
                    efficientVarList <- efficientVarList[-1]
                    for (var2 in efficientVarList){
                        pVals[var1,var2] <- chisq.test(wordFreqData[,var1],wordFreqData[,var2])$p.value
                    }
                }
                melted_pVals <- melt(pVals)
                #plot independence tests
                ggplot(data = melted_pVals, aes(x=Var1, y=Var2, fill=value)) + 
                    geom_tile() + theme(axis.text.x = element_text(color = "#993333", 
                                                                   size = 12, angle = 270)) + 
                    theme(axis.text.y = element_text(color = "#993333", 
                                                     size = 10)) + 
                    paletteer::scale_fill_paletteer_c("viridis::plasma")
            }#close validate
        } #close ind test
        else{
            n <- length(input$topicsInference)
            if(n != 0){
                vars <- sapply(input$topicsInference, paste0,"_f")
                efficientVarList <- vars
                
                means <- wordFreqData %>% 
                    select(vars) %>% summarise_all(mean)
                
                trimmed <- wordFreqData %>% select(vars)
                
                params_exponent <- means %>%
                    mutate_all(inv) 
                
                colnames(params_exponent) <- vars

                first <- 1
                for (topic in vars){
                    if (first){
                        theoretical_dists <- sort(rexp(100,params_exponent[,topic]),decreasing = TRUE)
                        theoretical_dists <- data.frame(theoretical_dists)
                        colnames(theoretical_dists) <- c(paste0("thry-",topic))
                        print(colnames(theoretical_dists))
                        first <- 0
                    }
                    else{
                        temp <- sort(rexp(100,params_exponent[,topic]),decreasing = TRUE)
                        theoretical_dists[,paste0("thry-",topic)] <- temp
                    }
                }#close simulate new data with sample means
                efficientVarList <- colnames(theoretical_dists)
                pValGoodnessFit <- matrix(0, nrow = n, ncol = n, dimnames = list(vars,efficientVarList))
                for (i in 1:n){
                    pValGoodnessFit[i,i] <- chisq.test(trimmed[,i],theoretical_dists[,i])$p.value
                }
                
                melted_pValsGoodnessFit <- melt(pValGoodnessFit)
                
                #plot goodness of fits tests
                ggplot(data = melted_pValsGoodnessFit, aes(x=Var1, y=Var2, fill=value)) + 
                    geom_tile() + theme(axis.text.x = element_text(color = "#993333", 
                                                                   size = 12, angle = 270)) + 
                    theme(axis.text.y = element_text(color = "#993333", 
                                                     size = 10)) + 
                    paletteer::scale_fill_paletteer_c("viridis::plasma")
            }#close validate
        }#close goodness of fit test
        

})#close inference section
    
    output$networkPlot <- renderVisNetwork({
        topics <- input$networkTopics
        if(length(topics) < 2){
            return(NULL)
        }
        data <- wordFreqData
        reserve_columns <- paste0(topics, "_w")
        # reserve_index <- sapply(colnames(data), FUN = function(x){
        #   result <- sapply(topics, function(y){ grepl(y, x)})
        #   return(any(result))
        # })
        words <- data[reserve_columns]
        topic_number = length(topics)
        relation = data.frame()
        relation_matrix = matrix(rep(0, topic_number^2), nrow = topic_number)
        for(i in 1:topic_number){
            for(j in i:topic_number){
                relation_matrix[i, j] = length(intersect(words[,i], words[,j]))
                if(relation_matrix[i, j] > 40 && i!=j){
                    relation = rbind(c(topics[i], topics[j], relation_matrix[i, j]/5-5), relation)
                    row.names(relation)=NULL
                }
            }
        }
        
        names(data) = topics
        top10 = apply(words, 2, function(x){
            return(paste(x[1:10],collapse = ", "))
        })
        top10 <- data.frame(label = topics, title = top10)
        row.names(top10) <- NULL
        top10$id = top10$label
        if(nrow(relation)> 1){
            colnames(relation) = c("from", "to", "width")
            relation$label = relation$width
            visNetwork(nodes = top10, edges = relation)
        }else{
            visNetwork(nodes = top10)
        }
    }) #Close network plot
    
})#Close server
