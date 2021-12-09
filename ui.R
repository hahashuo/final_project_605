#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(visNetwork)
curvePlotsData <- read.csv("linePLot-formatData.csv")
curvePlotsData <- curvePlotsData[,-1] #remove needless index variable

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Natural Language in the Stack Exchange Network: An Analysis on Frequencies of the Top 100 Most Used Words per Topic"),
    navbarPage("Welcome",
               tabPanel(icon("home"),
                        strong("Jack Bressett, Haishuo Chen, Jinghao Liu, Luke Vandenheuvel"),br(),
                        strong("Welcome. Let's start with the analysis on Stack Exchange Topics\n"),
                        br(),
                        strong("Our Data:"),
                        p("Nearly 6GB of Stack Exchange Posts from approximately 160 different topics"),
                        strong("Analysis Goal:"),
                        p("What are similarities and differences between topics mentioned in different themes? "),
                        p("Are frequencies of highest used words very similar, or do they vary from topic to topic?"),
               ),
               tabPanel("Explore Zipf's Law",
                        sidebarLayout( # Sidebar 
                            sidebarPanel(                
                                multiInput(
                                    inputId = "topics",
                                    label = "Select which topics you would like to see", 
                                    choices = colnames(curvePlotsData),
                                    choiceNames = colnames(curvePlotsData),
                                    choiceValues = colnames(curvePlotsData)
                                )),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                                plotOutput("distPlot")
                            )
                        ),
                        p("Generally, the lines are consistent with inverse propotional curve families. So, we draw the conclusion that Zipf's Law is obeyed.")
               ), #closes first tab
               tabPanel("See the Important Words",
                        # Sidebar with a slider input for number of bins
                        sidebarLayout(
                            sidebarPanel(
                                numericInput(
                                    inputId = "numRows",
                                    label = "Select how many rows you would like [1-100]",
                                    value = 15,
                                    min=1,
                                    max = 100,
                                    step = 1
                                ),
                                multiInput(
                                    inputId = "topicsFreq",
                                    label = "Select which topics you would like to see", 
                                    choices = colnames(curvePlotsData),
                                    choiceNames = colnames(curvePlotsData),
                                    choiceValues = colnames(curvePlotsData)
                                )),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                                tableOutput("mostFreq")
                                
                            )  
                        )
               ), #close second tab
               tabPanel("Run Inference by Topic",
                        sidebarLayout( # Sidebar 
                            sidebarPanel(
                                radioButtons(
                                    inputId= "test",
                                    label = "Select whether to run a test of independence between topics or a goodness of
                                    fit between some topics and a random sample from an exponetial distribution with the topic's inverse mean frequency as the parameter.",
                                    choices = c("Independence", "GoodFit"),
                                    choiceNames = c("Independence", "GoodFit"),
                                    choiceValues = c("Independence", "GoodFit")
                                ),
                                multiInput(
                                    inputId = "topicsInference",
                                    label = "Select which topics you would like to test", 
                                    choices = colnames(curvePlotsData),
                                    choiceNames = colnames(curvePlotsData),
                                    choiceValues = colnames(curvePlotsData)
                                )),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                                plotOutput("pValPlot")
                            )  
                        ),
                        p("In the tests for indepence there is some variation in the p-values but overall the majority of 
                          relationships are not significantly different. This is evidence to suggest the rankings belong to similar distribution between topics."),
                        p("In the tests for goodness of fit there is very little variation in the p-values and overall the majority of 
                          relationships are not significantly different. This is evidence to suggest the rankings belong to an exponential distribution with a parameter 
                          of 1/mean(topic frequencies)."),
               ), #closes third tab
               tabPanel("Explore topics' relations",
                        sidebarLayout( # Sidebar 
                            sidebarPanel(                
                                multiInput(
                                    inputId = "networkTopics",
                                    label = "Select which topics you would like to see", 
                                    choices = colnames(curvePlotsData),
                                    choiceNames = colnames(curvePlotsData),
                                    choiceValues = colnames(curvePlotsData)
                                )),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                                visNetworkOutput("networkPlot")
                            )  
                        ), p("We displayed important words here. The visualization results, sometimes, have some gaps to our expectation. Some words, like 'can', 'will' make no sense to detect the hottest words people are talking. 
                            However, the results still shows enogh important information"),
                        
                        p("The network plot shows the relationship among different topics, where the nodes are different topics and the edges show 
                          the existence of relationship. The numbers on the edge show the corelation score. This is an interactive plot. So, you can drag the node to make their relationship with other topics more distinguishable")
               ), #closes forth tab
              
    ) #Close Navbar
)) #Close Shiny UI
