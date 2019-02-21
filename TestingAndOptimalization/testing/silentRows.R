# function counts silent rows in 10 year Apple data

# install used packages if required
install.packages(ggplot2)
install.packages(plotly)
install.packages(dplyr)

# read packages
library(ggplot2)
library(plotly)
library(dplyr)

dataset1 = data.frame()
dataset1 = read.csv("data/SignalsForClassification5YO/signalsAPPL10Y.csv")

tendency = c(1,3,7,14,30)
silentIndicators = c(9,8,7,6,5)
silentRows = data.frame()
silentIndicatorsInRow = data.frame()

  for(rowIndex in 1:nrow(dataset1)){
    column = -9
    for(tendencyIndex in 1:5){
      column = column + 10
      count = 0
      for(columnIndex in column:(column+8)){
        if("silent" == dataset1[rowIndex,columnIndex]){
          count = count + 1
        }
      }
      silentIndicatorsInRow[rowIndex,tendencyIndex] = count
    }
  }

counter = 0
for(silentIndicatorsIndex in 1:length(silentIndicators)){
 for(columnIndex in 1:5){
   count = 0
   for(rowIndex in 1:nrow(silentIndicatorsInRow)){
     if(silentIndicatorsInRow[rowIndex,columnIndex] == silentIndicators[silentIndicatorsIndex]){
       count = count + 1
     }
   }
   counter = counter + 1
   silentRows[counter,"silentRows"] = count
   silentRows[counter,"numberOfSilentIndicators"] = as.character(silentIndicators[silentIndicatorsIndex])
   silentRows[counter,"columnIndex"] = as.character(tendency[columnIndex])
 }
}

write.csv(silentRows, file = "data/classificationTestedData/silentRows.csv",row.names=FALSE)

silentRows %>% group_by(columnIndex) %>%
  plot_ly(x=~columnIndex,y=~silentRows, color=~numberOfSilentIndicators, type = "bar") %>%
  layout(title = "Number of silent rows by number of silent indicators, grouped by tendency",
         xaxis = list(title = "Tendency")) %>%
  add_annotations( text="NumberOfSilentIndicators", xref="paper", yref="paper",
                   x=0.90, xanchor="left",
                   y=0.9, yanchor="bottom",    # Same y as legend below
                   legendtitle=TRUE, showarrow=FALSE ) %>%
  layout( legend=list(y=0.9, yanchor="top") )
