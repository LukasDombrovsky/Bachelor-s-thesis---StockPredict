# Script finds and visualise best time period for classification
# of historical data for a 3 different stocks

# # install used packages if required
# install.packages(ggplot2)
# install.packages(plotly)
# install.packages(dplyr)

# read packages
library(ggplot2)
library(plotly)
library(dplyr)

# AAPL

tendency = c(1,3,7,14,30)
numberOfYears = 1
aAndT = data.frame()
counter = 0

for(tendencyIndex in 1:length(tendency)){
    DF = read.csv(paste0("data/ClassificationSuccessRatesAPPL/","ten",
                         tendency[tendencyIndex],"PredictionOn",
                         numberOfYears,"Ydata.csv"))
    
    DF = DF[order(DF$Accuracy,decreasing = T),]
    
    counter = counter + 1
    aAndT[counter,"Accuracy"] = mean(DF[1:2,"Accuracy"])
    if(tendency[tendencyIndex]<10)
      aAndT[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
    else
      aAndT[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
    aAndT[counter,"Algorithm"] = "Mean of two best algotithms" 
    
    for(algorithmIndex in 1:6){
      counter = counter + 1
      aAndT[counter,"Accuracy"] = DF[algorithmIndex,"Accuracy"]
      if(tendency[tendencyIndex]<10)
        aAndT[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
      else
        aAndT[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
      aAndT[counter,"Algorithm"] = as.character(DF[algorithmIndex,"Algorithm"])
  }
}

write.csv(aAndT, file = "data/classificationTestedData/aAndTAAPL.csv",row.names=FALSE)

aAndT %>% group_by(Tendency) %>%
  plot_ly(x=~Tendency,y=~Accuracy, color=~Algorithm, type = 'scatter',
          mode = 'markers', marker = list(size = 15)) %>%
  layout(title = "Best tendencies and algorithms for classification Apple")


# BAC

tendency = c(1,3,7,14,30)
numberOfYears = 1
aAndT = data.frame()
counter = 0

for(tendencyIndex in 1:length(tendency)){
  DF = read.csv(paste0("data/ClassificationSuccessRatesBAC/","ten",
                       tendency[tendencyIndex],"BAC",
                       numberOfYears,"Y.csv"))
  
  DF = DF[order(DF$Accuracy,decreasing = T),]
  
  counter = counter + 1
  aAndT[counter,"Accuracy"] = mean(DF[1:2,"Accuracy"])
  if(tendency[tendencyIndex]<10)
    aAndT[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
  else
    aAndT[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
  aAndT[counter,"Algorithm"] = "Mean of two best algotithms" 
  
  for(algorithmIndex in 1:6){
    counter = counter + 1
    aAndT[counter,"Accuracy"] = DF[algorithmIndex,"Accuracy"]
    if(tendency[tendencyIndex]<10)
      aAndT[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
    else
      aAndT[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
    aAndT[counter,"Algorithm"] = as.character(DF[algorithmIndex,"Algorithm"])
  }
}

write.csv(aAndT, file = "data/classificationTestedData/aAndTBAC.csv",row.names=FALSE)

aAndT %>% group_by(Tendency) %>%
  plot_ly(x=~Tendency,y=~Accuracy, color=~Algorithm, type = 'scatter',
  mode = 'markers', marker = list(size = 15)) %>%
  layout(yaxis = list(range=c(0.3,1)),title = "Best tendencies and algorithms for classification Bank of America")

# INTC

tendency = c(1,3,7,14,30)
numberOfYears = 1
aAndT = data.frame()
counter = 0

for(tendencyIndex in 1:length(tendency)){
  DF = read.csv(paste0("data/ClassificationSuccessRatesINTC/","ten",
                       tendency[tendencyIndex],"INTC",
                       numberOfYears,"Y.csv"))
  
  DF = DF[order(DF$Accuracy,decreasing = T),]
  
  counter = counter + 1
  aAndT[counter,"Accuracy"] = mean(DF[1:2,"Accuracy"])
  if(tendency[tendencyIndex]<10)
    aAndT[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
  else
    aAndT[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
  aAndT[counter,"Algorithm"] = "Mean of two best algotithms" 
  
  for(algorithmIndex in 1:6){
    counter = counter + 1
    aAndT[counter,"Accuracy"] = DF[algorithmIndex,"Accuracy"]
    if(tendency[tendencyIndex]<10)
      aAndT[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
    else
      aAndT[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
    aAndT[counter,"Algorithm"] = as.character(DF[algorithmIndex,"Algorithm"])
  }
}

write.csv(aAndT, file = "data/classificationTestedData/aAndTINTC.csv",row.names=FALSE)

aAndT %>% group_by(Tendency) %>%
  plot_ly(x=~Tendency,y=~Accuracy, color=~Algorithm, type = 'scatter',
          mode = 'markers', marker = list(size = 15)) %>%
  layout(title = "Best tendencies and algorithms for classification Intel")


