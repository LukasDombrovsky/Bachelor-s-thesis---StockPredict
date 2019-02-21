# Script finds and visualise best time period for classification
# of historical data for a 3 different stocks

# install used packages if required
install.packages(ggplot2)
install.packages(plotly)
install.packages(dplyr)

# read packages
library(ggplot2)
library(plotly)
library(dplyr)

# AAPL

tendency = c(1,3,7,14,30)
numberOfYears = c(1,2,3,4,5,10)
meanAccuracy = data.frame()
counter = 0

for(tendencyIndex in 1:length(tendency)){
  for(numberOfYearsIndex in 1:length(numberOfYears)){
    counter = counter + 1
    DF = read.csv(paste0("data/ClassificationSuccessRatesAPPL/","ten",
                         tendency[tendencyIndex],"PredictionOn",
                         numberOfYears[numberOfYearsIndex],"Ydata.csv"))
    
    DF = DF[order(DF$Accuracy,decreasing = T),]
    
    meanAccuracy[counter,"BestAccuracy"] = DF[1,"Accuracy"]
    
    if(numberOfYears[numberOfYearsIndex]<10)
      meanAccuracy[counter,"NumberOfYears"] = paste0("0",as.character(numberOfYears[numberOfYearsIndex])," years")
    else
      meanAccuracy[counter,"NumberOfYears"] = paste0(as.character(numberOfYears[numberOfYearsIndex])," years")
    
    if(tendency[tendencyIndex]<10)
      meanAccuracy[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
    else
      meanAccuracy[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
  }
}

write.csv(meanAccuracy, file = "data/classificationTestedData/meanAccuracyAAPL.csv",row.names=FALSE)

meanAccuracy %>% group_by(Tendency) %>%
plot_ly(x=~Tendency,y=~BestAccuracy, color=~NumberOfYears ) %>%
        layout(title = "Best time period for classification Apple")

# BAC

tendency = c(1,3,7,14,30)
numberOfYears = c(1,2,3,4,5,10)
meanAccuracy = data.frame()
counter = 0

for(tendencyIndex in 1:length(tendency)){
  for(numberOfYearsIndex in 1:length(numberOfYears)){
    counter = counter + 1
    DF = read.csv(paste0("data/ClassificationSuccessRatesBAC/","ten",
                         tendency[tendencyIndex],"BAC",
                         numberOfYears[numberOfYearsIndex],"Y.csv"))
    
    DF = DF[order(DF$Accuracy,decreasing = T),]
    
    meanAccuracy[counter,"BestAccuracy"] = DF[1,"Accuracy"]
    
    if(numberOfYears[numberOfYearsIndex]<10)
      meanAccuracy[counter,"NumberOfYears"] = paste0("0",as.character(numberOfYears[numberOfYearsIndex])," years")
    else
      meanAccuracy[counter,"NumberOfYears"] = paste0(as.character(numberOfYears[numberOfYearsIndex])," years")
    
    if(tendency[tendencyIndex]<10)
      meanAccuracy[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
    else
      meanAccuracy[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
  }
}

write.csv(meanAccuracy, file = "data/classificationTestedData/meanAccuracyBAC.csv",row.names=FALSE)

meanAccuracy %>% group_by(Tendency) %>%
  plot_ly(x=~Tendency,y=~BestAccuracy, color=~NumberOfYears, type = 'bar' ) %>%
  layout(title = "Best time period for classification Bank of America")

# INTC

tendency = c(1,3,7,14,30)
numberOfYears = c(1,2,3,4,5,10)
meanAccuracy = data.frame()
counter = 0

for(tendencyIndex in 1:length(tendency)){
  for(numberOfYearsIndex in 1:length(numberOfYears)){
    counter = counter + 1
    DF = read.csv(paste0("data/ClassificationSuccessRatesINTC/","ten",
                         tendency[tendencyIndex],"INTC",
                         numberOfYears[numberOfYearsIndex],"Y.csv"))
    
    DF = DF[order(DF$Accuracy,decreasing = T),]
    
    meanAccuracy[counter,"BestAccuracy"] = DF[1,"Accuracy"]
    
    if(numberOfYears[numberOfYearsIndex]<10)
      meanAccuracy[counter,"NumberOfYears"] = paste0("0",as.character(numberOfYears[numberOfYearsIndex])," years")
    else
      meanAccuracy[counter,"NumberOfYears"] = paste0(as.character(numberOfYears[numberOfYearsIndex])," years")
    
    if(tendency[tendencyIndex]<10)
      meanAccuracy[counter,"Tendency"] = paste0("+0",tendency[tendencyIndex],"days")
    else
      meanAccuracy[counter,"Tendency"] = paste0("+",tendency[tendencyIndex],"days")
  }
}

write.csv(meanAccuracy, file = "data/classificationTestedData/meanAccuracyINTC.csv",row.names=FALSE)

meanAccuracy %>% group_by(Tendency) %>%
  plot_ly(x=~Tendency,y=~BestAccuracy, color=~NumberOfYears, type = 'bar' ) %>%
  layout(title = "Best time period for classification Intel")


