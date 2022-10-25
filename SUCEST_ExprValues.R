library(reshape2)
library(R.utils)
library(edgeR)
rm(list=ls())
setwd("/data/diriano/sugarcaneESTs//")

dataCNT<-read.delim(gunzip("SUCEST_ESTs_LIBS.NUMREADS.txt.gz", remove=FALSE, overwrite=TRUE),dec='.',header=TRUE, row.names=1)


head(dataCNT)


dataCPM<-as.data.frame(cpm(dataCNT, normalized.lib.sizes=FALSE,log=FALSE, prior.count = 0))
head(dataCPM)
is.data.frame(dataCPM)
dataCPM$Transcript<-rownames(dataCPM)
head(dataCPM)
cpm2long<-melt(dataCPM)
colnames(cpm2long)<-c('Transcript','Library','CPM')
cpm2long$libraryTissue<-gsub("[0-9]+$","",cpm2long$Library)
head(cpm2long)
dataCPM$Transcript<-NULL
#transcript='SCACLR1036B06.g'
transcript='SCCCST2001G02.g' #SCCCST2001G02.g Ubiquitin, sent by Menossi
#transcript=SCACAD1035A01.g
ggplot(cpm2long[which(cpm2long$Transcript == transcript),], 
       aes(x=Library, y=CPM, fill=libraryTissue)) + 
  theme_bw() +
  theme(legend.position = 'none') +
  geom_col() +
  ylab("CPM - Log10")+
  scale_y_log10() +
  ggtitle(transcript)


keep<-(rowSums(dataCPM != 0)/ncol(dataCPM)*100)>=30
table(keep)
expresed30pct<-dataCPM[keep,]
dim(expresed30pct)
#Keeping only transcripts expressed in 30% of the libraries, and with at least one CL library with reads
callusExpresed<-expresed30pct[rowSums(expresed30pct[,c('CL1','CL2','CL3','CL4','CL5','CL6','CL7')] != 0)>0,]
dim(callusExpresed)

