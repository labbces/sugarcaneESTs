getNumberTranscripts<-function(data, minCPM, libGroup, pctLibs, libraries){
  keep<-(rowSums(data != 0)/ncol(data)*100)>=pctLibs
  expresedpct<-data[keep,]
  ntxpExpresed<-expresedpct[rowSums(expresedpct[,libraries[which(libraries$LibraryTissue == libGroup),
                                                               'Library']] > minCPM)>0,]
  return(nrow(ntxpExpresed))
}

getTranscriptNames<-function(data, minCPM, libGroup, pctLibs, libraries){
  keep<-(rowSums(data != 0)/ncol(data)*100)>=pctLibs
  expresedpct<-data[keep,]
  ntxpExpresed<-expresedpct[rowSums(expresedpct[,libraries[which(libraries$LibraryTissue == libGroup),
                                                           'Library']] > minCPM)>0,]
  return(rownames(ntxpExpresed))
}