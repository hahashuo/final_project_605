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

curvePlotsData <- read.csv("linePLot-formatData.csv")
curvePlotsData <- curvePlotsData[,-1] #remove needless index variable

wordFreqData <- read.csv("wordFreq-formatData.csv")
wordFreqData <- wordFreqData[,-1] #remove needless index variable


plot_topic_curve <- function(topic,data){
    ggplot(data, aes(x=index,y=data[,topic]))+ geom_line()
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
    
})
