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
      Vettore report 26 EST libraries (Table 1 in the original paper, and reproduced below), 
      however data from 37 libraries were recovered from NCBI (as shown in the boxplot and barplot below).
      Further information about the CL EST libraries are found at the bottom of the page.",
      style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
    img(src="SUCEST_Libs.png"),
    br(),
    p("EST sequences were downloaded from NCBI, and mapped against the EST assembly from SUCEST, with Salmon v1.8.0.
      From the Salmon estimated read counts per transcript, counts per million were estimated with EdgeR's function cpm."
    ,style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
    
    br(),
    p("The goal of this tool is to aid in the selection of ESTs for downstream studies. 
    For this we have devised a set of three filters that act one after the other.
    The First filter is used to select a set of genes/transcripts that could be considered reliably expressed,
    for this we will keep gene/transcripts that have at least one EST (CPM > 0) in a user defined percent of the libraries.
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
  p("Then, in a second step the user can focus on a subset of libraries, 
  keeping only genes/transcript expressed in these libraries with a CPM greater than a specificed value.
    Users can control these two options with the display list ",strong('Select the group of libraries to focus on:'),", and the text box: ",
    strong('Minimum CPM:'),"."
    ,style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px" ),
  
  br(),
  p("These filters will result in a set of genes, that can be reliably expressed in sugarcane (present in several libraries), and
  that are expressed above a especified value in a selected subset of these libraries."
    ,style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
  
  br(),
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
  p("The last figure can display the expression profile of each of the genes/transcripts kepth after the filters."
    ,style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
  
  br(),
  sidebarLayout(
    sidebarPanel(
      htmlOutput("listSelectedGenesUI")
    ),
    mainPanel(
      plotOutput(outputId = "expressionProfileSelectedGene"),
      tableOutput(outputId = "expressionTableSelectedGene")
    )
  ),
  p("Finaly, the user can download the whole dataset (all genes/transcripts), or the set after filtering.z"
    ,style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
  
  br(),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:",
                  choices = c("full", "filtered")),
      downloadButton("downloadData", "Download")
    ),
    mainPanel(
      tableOutput("table")
    )
  ),
  hr(),
  h2("Information about the CL libraries"),
  p("No decorrer do Projeto, foram construídas 35 bibliotecas de cDNA a partir dos mais diferentes tecidos de cana-de-açúcar.
  Destas 35 bibliotecas, 9 não foram aprovadas durante o processo de validação e não tiveram seus clones seqüenciados no Projeto
   SUCEST (Tabela II). As bibliotecas CL1, CL2, CL3, CL4, CL5 e CL7 foram construídas com RNA mensageiro obtido de calli com 11 
   dias de idade foram submetidos a diferentes tratamentos: alta temperatura, baixa temperatura, luz e escuro conforme descrito 
   no Relatório FAPESP No 1 (Nov/99). As bibliotecas CL1, CL2, CL3 e CL4 foram construídas utilizando-se o fago l como vetor, mas, 
   devido aos inúmeros problemas enfrentados com este tipo de vetor, as demais bibliotecas utilizadas no projeto foram construídas 
   utilizando-se o plasmídio pSport-1 como vetor. As análises de restrição e seqüenciamento da biblioteca CL1 revelaram que ~65% 
    dos clones eram pequenos e  havia uma significativa contaminação com DNA de E coli. A biblioteca CL2 foi descartada devido 
    a contaminação expressiva com clones com alta homologia com fago lambda (21,9%), apesar do título primário muito bom (8,6 x 106), 
    da insignificância de contaminação com E .coli (1,6%) e do tamanho médio dos insertos ser de 1.650 pb,. 
    A biblioteca CL3 não apresentou nenhum dos problemas verificados com as bibliotecas anteriores. Foram seqüenciados cerca de 
    1.000 clones desta biblioteca para confirmar sua qualidade. Uma vez que a biblioteca se mostrou satisfatória, 
    foram estocados 16.128 clones em triplicata. Entretanto, após 2 meses de estocagem a –70°C verificou-se que o processo de 
    estocagem havia, de alguma forma, alterado a biblioteca. Os clones eram capazes de crescer em meio contendo 100 mg/mL de ampicilina, 
    mas não era possível a obtenção de DNA plasmidial (Relatório FAPESP No 1 - Nov/99). Na tentativa de se minimizar este problema, 
    foi construída uma nova biblioteca (CL4), só que, desta vez utilizou-se a bactéria a XL1-Blue MRF’ (Stratagene) como hospedeira. 
    Desta biblioteca chegaram a ser seqüenciados 1.536 clones, entretanto, ela apresentou problemas semelhantes aos ocorridos com as 
    bibliotecas anteriores. A biblioteca CL5 foi construída no plasmídio pSport-1, mas, cerca de 30-40% dos clones seqüenciados não 
    apresentaram seqüências. Após uma analise detalhada dos resultados, descobriu-se que o DNA plasmidial sofreu algum tipo de 
    recombinação que levou a perda da região que continha o sítio de ligação do primer T7 utilizado nas reações de seqüenciamento. 
    A biblioteca CL7 foi descartada porque apresentou, mesmo com um pequeno número de clones seqüenciados (384), uma baixa Taxa de Novidade.",
    style="text-align:justify;color:black;background-color:lavender;padding:15px;border-radius:10px"),
  hr(),
  h1("Funding"),
  img(src="FAPESP.png"),
  img(src="CNPq.png"),
  img(src="RCG2I.png")
  
  
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
