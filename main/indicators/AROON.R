############################
# AROON indicator and signal
############################
AROON = function(dataset1,ten,period,highValue,lowValue){
  for(i in 1:nrow(dataset1)){
    
    # AARON-up
    highestHigh = dataset1[i,"High"]
    index = 0
    for(j in 1:period){
      curHigh = paste0("High-",j)
      if(dataset1[i,curHigh]>highestHigh){
        highestHigh = dataset1[i,curHigh]
        index = j
      }
    }
    AroonUp = ((period - index)/period) * 100
    
    # AARON-down
    lowestLow = dataset1[i,"Low"]
    index = 0
    for(j in 1:period){
      curLow = paste0("Low-",j)
      if(dataset1[i,curLow]<lowestLow){
        lowestLow = dataset1[i,curLow]
        index = j
      }
    }
    AroonDown = ((period - index)/period) * 100
    
    # if(AroonUp<AroonDown) newUptrendPossible = TRUE
    # else newDowntrendPossible = FALSE
    
    # signals from AARONs
    if(AroonUp>highValue && AroonDown<lowValue) dataset1[i,paste0("SignalAROON",ten)]="rise"
    else if(AroonDown>highValue && AroonUp<lowValue) dataset1[i,paste0("SignalAROON",ten)]="fall"
    else dataset1[i,paste0("SignalAROON",ten)]="silent"
  }
  return(dataset1)
}