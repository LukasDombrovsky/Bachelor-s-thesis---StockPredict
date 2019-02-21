##########################
# SAR indicator and signal
##########################
SAR = function(dataset1,ten,startAF,increaseAF,maxAF){
  period = 4
  # first calculation
  highest = dataset1[1,"High"]
  lowest = dataset1[1,"Low"]
  
  for(j in 1:period){
    high = paste0("High-",j)
    if(dataset1[1,high]>highest) highest=dataset1[1,high]
    low = paste0("Low-",j)
    if(dataset1[1,low]<lowest) lowest=dataset1[1,low]
  }
  
  if(dataset1[1,"Close"]>lowest){
    SAR = lowest
    EP = highest
    AF = startAF
    upTrend = TRUE
    downTrend = FALSE
    dataset1[1,paste0("SignalSAR",ten)] = "rise"
  } else {
    SAR = highest
    EP = lowest
    AF = startAF
    upTrend = FALSE
    downTrend = TRUE 
    dataset1[1,paste0("SignalSAR",ten)] = "fall"
  }
  
  # uptrend or downtrend calculation?
  for(i in 2:nrow(dataset1)){
    # uptrend
    if(dataset1[i,"Close"]>SAR){
      if(downTrend == TRUE){
        AF = startAF
        downTrend = FALSE
        upTrend = TRUE
      }
      if(dataset1[i,"High"]>EP && AF<maxAF){
        EP = dataset1[i,"High"]
        AF = AF + increaseAF
      }
      SAR = SAR+AF*(EP-SAR)
      if(SAR>dataset1[i,"Low-1"]) SAR = dataset1[i,"Low-1"]
      if(SAR>dataset1[i,"Low-2"]) SAR = dataset1[i,"Low-2"]
      dataset1[i,paste0("SignalSAR",ten)] = "rise"
    }
    
    # downtrend
    else {
      if(upTrend == TRUE){
        AF = startAF
        downTrend = TRUE
        upTrend = FALSE
      }
      if(dataset1[i,"Low"]<EP && AF<maxAF){
        EP = dataset1[i,"Low"]
        AF = AF + increaseAF
      }
      SAR = SAR-AF*(SAR-EP)
      if(SAR<dataset1[i,"High-1"]) SAR = dataset1[i,"High-1"]
      if(SAR<dataset1[i,"High-2"]) SAR = dataset1[i,"High-2"]
      dataset1[i,paste0("SignalSAR",ten)] = "fall"
    }
  }
  return(dataset1)
}