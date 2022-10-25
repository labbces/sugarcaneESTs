library(shiny)
library(reshape2)
library(R.utils)
library(edgeR)
library(ggplot2)
source("helper.R")
rm(list=ls())
#data from https://genome.cshlp.org/content/13/12/2725/T1.expansion.html
dataCNT<-read.delim(gunzip("/data/diriano/sugarcaneESTs/SUCEST_ESTs_LIBS.NUMREADS.txt.gz", remove=FALSE, overwrite=TRUE),dec='.',header=TRUE, row.names=1)


head(dataCNT)

libraries<-as.data.frame(cbind(Library=colnames(dataCNT),LibraryTissue=gsub("[0-9]*$","",colnames(dataCNT))))
libraryTissues<-unique(libraries$LibraryTissue)
dataCPM<-as.data.frame(cpm(dataCNT, normalized.lib.sizes=FALSE,log=FALSE, prior.count = 0))
dataCPM$Transcript<-rownames(dataCPM)
cpm2long<-melt(dataCPM)
colnames(cpm2long)<-c('Transcript','Library','CPM')
cpm2long$libraryTissue<-gsub("[0-9]+$","",cpm2long$Library)
dataCPM$Transcript<-NULL

ui <- fluidPage(
  
  # App title ----
  titlePanel("Selection of Sugarcane ESTs - LabBCES"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "percentLibs",
                  label = "Percent of libraries with data:",
                  min = 1,
                  max = 100,
                  value = 30)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "boxPlotExpressedGenes")
      
    )
  ),
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput("selectLib",p("Select the group of libraries to focus on:",
                                 style="color:black; text-align:center"),
                  choices=libraryTissues,
                  selected = 'CL'),
      numericInput(inputId = 'minCPM',label = "Minimum CPM", min = 0, value = 2)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      textOutput("selectedLibraryGroup"),
      tableOutput("selectedLibraries"),
      textOutput("selectedminCPM"),
      #img(src = "SUCEST_Libs.png", width = 600),
      # Output: Histogram ----
      #plotOutput(outputId = "boxPlotExpressedGenes2")
      
    )
  ),
  sidebarLayout(
    sidebarPanel(
      htmlOutput("listSelectedGenesUI")
    ),
    mainPanel(
      plotOutput(outputId = "expressionProfileSelectedGene")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$boxPlotExpressedGenes <- renderPlot({
    
    #x    <- faithful$waiting
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    #hist(x, breaks = bins, col = "#75AADB", border = "white",
    #     xlab = "Waiting time to next eruption (in mins)",
    #     main = "Histogram of waiting times")
    keep<-(rowSums(dataCPM != 0)/ncol(dataCPM)*100)>=input$percentLibs
    expresed30pct<-dataCPM[keep,]
    ggplot(cpm2long[which(cpm2long$Transcript %in% rownames(expresed30pct)),], aes(x=Library,y=CPM,fill=libraryTissue)) +
      theme(legend.position = 'none')+
      theme_bw()+
      geom_boxplot()+
      scale_y_log10()+
      ylab("CPM - Log10")
    
  })
  output$selectedLibraryGroup <- renderText({
    paste("You have selected: ",input$selectLib, ". See Table 1 below for a definition of the libraries.")
  })
  output$selectedLibraries <- renderTable({
    libraries[which(libraries$LibraryTissue == input$selectLib),]
  })
  output$selectedminCPM <- renderText({
    ntxpExpresed<-getNumberTranscripts(dataCPM,input$minCPM,input$selectLib, input$percentLibs, libraries)
    paste(ntxpExpresed," transcripts with a value of CPM greater than: ",input$minCPM, " in any of your selected libraries were kepth")
    
  })
  output$listSelectedGenesUI <-renderUI({selectInput(
    "selectGenes",p("Select the gene of interest, based on your previous filters:",
                  style="color:black; text-align:center"),
    choices=getTranscriptNames(dataCPM,input$minCPM,input$selectLib, input$percentLibs, libraries)
  )
  })
  
  
  
}

shinyApp(ui = ui, server = server)
