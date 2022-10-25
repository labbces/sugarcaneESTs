library(reshape2)
library(ggplot2)
rm(list=ls())
setwd("~/Downloads/")

dataCNT<-read.delim("SUCEST_ESTs_LIBS.NUMREADS.txt",dec='.',header=TRUE)

head(dataCNT)

data2cnt<-melt(dataCNT)

head(data2cnt)


#SCCCST2001G02.g Ubiquitina, sent by Menossi
colnames(data2cnt)<-c('Transcript','Library','NumberReads')
data2cnt[which(data2cnt$Transcript == 'SCCCST2001G02.g'),]

#Computing sequencing depth for each library
seqDepth=as.data.frame(matrix(nrow = length(unique(data2cnt$Library)),ncol=2))
colnames(seqDepth)<-c('Library','NumberReadsDepth')
countLib<-1
for (librarySUCEST in unique(data2cnt$Library)){
  totalDepth=sum(data2cnt[which(data2cnt$Library == librarySUCEST),'NumberReads'])
  seqDepth[countLib,'Library']<-librarySUCEST
  seqDepth[countLib,'NumberReadsDepth']<-totalDepth
  countLib=countLib+1
}

#Computing counts per 10000
data2cnt$CPT10<-0
head(data2cnt)
dim(data2cnt)
data2cnt[which(data2cnt$Transcript == 'SCCCST2001G02.g'),]
for (pos in seq(1:dim(data2cnt)[1])){
  if (pos %% 100000 == 0){
   print(pos)
  }
  if (data2cnt[pos,'NumberReads'] >= 0){
    totalLib=seqDepth[which(seqDepth$Library == data2cnt[pos,'Library']),'NumberReadsDepth']
    cpt=data2cnt[pos,'NumberReads']*1e4/totalLib
    data2cnt[pos,'CPT10']<-cpt
  }
}

data2cnt$libratyTissue<-gsub("[0-9]+$","",data2cnt$Library)
transcript='SCACLR1036B06.g'
#transcript=SCCCST2001G02.g
#transcript=SCACAD1035A01.g
ggplot(data2cnt[which(data2cnt$Transcript == transcript),], 
       aes(x=Library, y=CPT10, fill=libraryTissue)) + 
  theme_bw() +
  theme(legend.position = 'none') +
  geom_col() +
  ylab("Counts per 10.000 - Log10")+
  scale_y_log10() 



dataCPT10<-acast(data2cnt,Transcript~Library, value.var= 'CPT10')
dim(dataCPT10)
head(dataCPT10)

#Keeping only transcripts expressed in 30% of the libraries
keep<-(rowSums(dataCPT10 != 0)/ncol(dataCPT10)*100)>=30
table(keep)
expresed30pct<-dataCPT10[keep,]
dim(expresed30pct)
#Keeping only transcripts expressed in 30% of the libraries, and with at least one CL library with reads
callusExpresed<-expresed30pct[rowSums(expresed30pct[,c('CL1','CL2','CL3','CL4','CL5','CL6','CL7')] != 0)>0,]
dim(callusExpresed)


dataCPT10['SCACLR2029C07.g',]

# ggplot(data2tpm[which(data2tpm$value > -1 & data2tpm$variable %in% c('CL1','CL2','CL3','CL4','CL5','CL6','CL7')),], 
#        aes(y=value, x=variable,group=Name)) + 
#   geom_point(alpha = 0.3, aes(color = value > 100)) +
#   geom_line(aes(group = Name), size = 0.5, alpha = 0.5, color = data2tpm$variable)+
#   scale_y_log10() 

ggplot(data2tpm[which(data2tpm$value > 10),], 
       aes(y=value, x=variable,group=Name)) + 
  geom_point() +
  geom_line()+
  scale_y_log10() 



