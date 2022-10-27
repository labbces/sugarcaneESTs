library(shiny)
library(reshape2)
library(ggplot2)
source("helper.R")
rm(list=ls())

download.file('https://raw.githubusercontent.com/labbces/sugarcaneESTs/main/dataCPM.rds', "dataCPM.rds")
dataCPM<-readRDS('dataCPM.rds')

libraries<-as.data.frame(cbind(Library=colnames(dataCPM),LibraryTissue=gsub("[0-9]*$","",colnames(dataCPM))))
libraryTissues<-unique(libraries$LibraryTissue)

dataCPM$Transcript<-rownames(dataCPM)
cpm2long<-melt(dataCPM)
colnames(cpm2long)<-c('Transcript','Library','CPM')
cpm2long$libraryTissue<-gsub("[0-9]+$","",cpm2long$Library)
dataCPM$Transcript<-NULL

ui <- fluidPage(
  # Title of the APP: Sugarcane EST-DigitalNorthern
  titlePanel(title=div(img(src="LabBCES.png"), "Digital Northern - Sugarcane ESTs - LabBCES")),
  fluidRow(
    p("This is a Digital Northern with ESTs from sugarcane. ESTs were generated in the early 2000s (", 
      a(href='https://www.ncbi.nlm.nih.gov/pmc/articles/PMC403815/', 'Vettore et al., 2003'), ").
      Vettore report 26 EST libraries (Table 1 in the original paper, and reproduced below, 
      however data from 37 libraries were recovered from NCBI (as shown in the boxplot and barplot below).",
      style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
    img(src="SUCEST_Libs.png"),
    br(),
    p("EST sequences were downloaded from NCBI, and mapped against the EST assembly from SUCEST, with Salmon v1.8.0.
      From the Salmon estimated read counts per transcript, counts per million were estimated with EdgeR's function cpm."
    ,style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
    
    br(),
    p("The goal of this tool is to aid in the selection of ESTs for downstream studies. 
    For this we have devised a set of three filters that act one after the other.
    The First filter is used to select a set of genes/transcripts that could be considered expressed,
    for this we will keep gene/transcript that have at least one EST (CPM > 0) in a user defined percent of the libraries.
    Users can control this with the slider ",strong('Percent of libraries with data:'),"."
      ,style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
    
    br(),
  ),
  sidebarLayout(
    # Sidebar for the first part of the analyses. Select the amount of samples to be taken into account to consider a gene as expressed.
    sidebarPanel(
      sliderInput(inputId = "percentLibs",
                  label = "Percent of libraries with data:",
                  min = 1,
                  max = 100,
                  value = 30)
      
    ),
    mainPanel(
      plotOutput(outputId = "boxPlotExpressedGenes")
    )
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput("selectLib",p("Select the group of libraries to focus on:",
                                 style="color:black; text-align:center"),
                  choices=libraryTissues,
                  selected = 'CL'),
      numericInput(inputId = 'minCPM',label = "Minimum CPM", min = 0, value = 2)
    ),
    mainPanel(
      textOutput("selectedLibraryGroup"),
      textOutput("selectedminCPM"),
      tableOutput("selectedLibraries"),
    )
  ),
  sidebarLayout(
    sidebarPanel(
      htmlOutput("listSelectedGenesUI")
    ),
    mainPanel(
      plotOutput(outputId = "expressionProfileSelectedGene"),
      tableOutput(outputId = "expressionTableSelectedGene")
    )
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:",
                  choices = c("full", "filtered")),
      downloadButton("downloadData", "Download")
    ),
    mainPanel(
      tableOutput("table")
    )
  )
  
  
)

server <- function(input, output) {
  #Boxplot of genes expression values per EST library
  output$boxPlotExpressedGenes <- renderPlot({
    keep<-(rowSums(dataCPM != 0)/ncol(dataCPM)*100)>=input$percentLibs
    expresed30pct<-dataCPM[keep,]
    ggplot(cpm2long[which(cpm2long$Transcript %in% rownames(expresed30pct)),], aes(x=Library,y=CPM,fill=libraryTissue)) +
      theme_bw()+
      theme(legend.position = 'none',axis.text.x = element_text(angle = 45))+
      geom_boxplot()+
      scale_y_log10()+
      ylab("CPM - Log10")
    
  })
  output$selectedLibraryGroup <- renderText({
    paste("You have selected: ",input$selectLib)
  })
  output$selectedLibraries <- renderTable({
    
    txpExpressed<-getExpressionProfile(dataCPM,input$minCPM,input$selectLib, input$percentLibs, libraries)
    txpExpressed<-as.data.frame(txpExpressed[,libraries[which(libraries$LibraryTissue == input$selectLib),'Library']])
    colnames(txpExpressed)<-libraries[which(libraries$LibraryTissue == input$selectLib),'Library']
    if(ncol(txpExpressed) == 1){
      counts<-as.data.frame(table(txpExpressed>input$minCPM))
      nExpressedGenesPerLib<-as.data.frame(matrix(ncol=3,nrow=1))
      colnames(nExpressedGenesPerLib)<-c('NotExpressed','Expressed','Library')
      if(any(counts == FALSE)){
        nExpressedGenesPerLib$NotExpressed<-counts[which(counts$Var1 == FALSE),'Freq']
      }
      else{
        nExpressedGenesPerLib$NotExpressed<-0
      }
      if(any(counts == TRUE)){
        nExpressedGenesPerLib$Expressed<-counts[which(counts$Var1 == TRUE),'Freq']
      }
      else{
        nExpressedGenesPerLib$Expressed<-0
      }
      nExpressedGenesPerLib$Library<-libraries[which(libraries$LibraryTissue == input$selectLib),'Library']
      # colnames(nExpressedGenesPerLib)<-c('Expressed')
      # nExpressedGenesPerLib$NotExpressed<-0
      # nExpressedGenesPerLib$Library<-input$selectLib
      return(nExpressedGenesPerLib)
    }
    else{
      nExpressedGenesPerLib<-as.data.frame(t(apply(txpExpressed>input$minCPM,MARGIN=2,FUN=table)))
      nExpressedGenesPerLib$Library<-row.names(nExpressedGenesPerLib)
      colnames(nExpressedGenesPerLib)<-c('NotExpressed','Expressed','Library')
      return(nExpressedGenesPerLib)
    }
  })
  output$selectedminCPM <- renderText({
    ntxpExpressed<-getNumberTranscripts(dataCPM,input$minCPM,input$selectLib, input$percentLibs, libraries)
    paste(ntxpExpressed," transcripts with a value of CPM greater than: ",input$minCPM, ", in at least one of your selected libraries, were kepth")
    
  })
  #Creates the list of selected genes, based on the filters,m and send to UI as a display list (choices)
  output$listSelectedGenesUI <-renderUI({selectInput(
    "selectedGene",p("Select the gene of interest, based on your previous filters:",
                  style="color:black; text-align:center"),
    choices=getTranscriptNames(dataCPM,input$minCPM,input$selectLib, input$percentLibs, libraries)
  )
  })
  output$expressionProfileSelectedGene<-renderPlot({
    ggplot(cpm2long[which(cpm2long$Transcript == input$selectedGene),],aes(x=Library, y=CPM, fill=libraryTissue))+
      theme_bw() +
      theme(legend.position = 'none',axis.text.x = element_text(angle = 45)) +
      geom_col() +
      ylab("Counts per million - Log10")+
      scale_y_log10() +
      ggtitle(input$selectedGene)
  })
  output$expressionTableSelectedGene<-renderTable({
    cpm2long[which(cpm2long$Transcript == input$selectedGene),]
  })
  datasetDownload <- reactive({
    switch(input$dataset,
           "full" = dataCPM,
           "filtered" = getExpressionProfile(dataCPM, input$minCPM,input$selectLib, input$percentLibs, libraries)
           )
  })
  output$table <- renderText({
    paste("Ready to download your selected dataset: ", input$dataset, "with ", nrow(datasetDownload()), "genes" )
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, "_sugarcaneEST_CPM.csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetDownload(), file, row.names = TRUE)
      }
  )
}

shinyApp(ui = ui, server = server)
