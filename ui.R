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
                        
                            p("p creates a paragraph of text."),
                            p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
                            strong("strong() makes bold text."),
                            em("em() creates italicized (i.e, emphasized) text."),
                            br(),
                            code("code displays your text similar to computer code"),
                            div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
                            br(),
                            p("span does the same thing as div, but it works with",
                              span("groups of words", style = "color:blue"),
                              "that appear inside a paragraph.")
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
                    )
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
                        )
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
                        )
               ) #closes forth tab
    ) #Close Navbar
)) #Close Shiny UI
