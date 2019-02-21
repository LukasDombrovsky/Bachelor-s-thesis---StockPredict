#############################
# StochRSI indicator & signal
#############################
StochRSI = function(dataset1,ten,periodRSI,highSMA,lowSMA,bottomValue,
                    ceilingValue,uptrendValue,downtrendValue){
  lowSMAString = paste0("SMA(",lowSMA,")")
  highSMAString = paste0("SMA(",highSMA,")")
  
  # calculating first RSI
  sumGain = 0
  sumLoss = 0
  for(j in ((periodRSI*2)-2):(periodRSI-1)){
    difference = dataset1[1,paste0("Close-",j)]-dataset1[1,paste0("Close-",j+1)]
    if(difference > 0){
      sumGain = sumGain + difference 
    } else{
      sumLoss = sumLoss + (-1)*difference
    }
  }
  avgGain = sumGain / periodRSI
  avgLoss = sumLoss / periodRSI
  
  RS = avgGain / avgLoss
  
  # first RSI
  index = 1
  RSI = vector()
  RSI[index] = 100 - (100/(1+RS))
  
  # next RSIs
  for(j in (periodRSI-2):1){
    difference = dataset1[1,paste0("Close-",j)]-dataset1[1,paste0("Close-",j+1)]
    if(difference > 0){
      gain = difference
      loss = 0
    } else{
      loss = (-1)*difference
      gain = 0
    }
    
    avgGain = (avgGain*(periodRSI-1)+gain)/periodRSI
    avgLoss = (avgLoss*(periodRSI-1)+loss)/periodRSI
    
    RS = avgGain / avgLoss
    
    # RSI
    index = index + 1
    RSI[index] = 100 - (100/(1+RS))
  }
  
  bottomCatched = FALSE
  ceilingCatched = FALSE
  SignalStochRSI = "silent"
  
  # RSI and StochRSI for next periodRSIs
  for(i in 1:nrow(dataset1)){
    difference = dataset1[i,"Close"]-dataset1[i,"Close-1"]
    if(difference > 0){
      gain = difference
      loss = 0
    } else{
      loss = (-1)*difference
      gain = 0
    }
    
    avgGain = (avgGain*(periodRSI-1)+gain)/periodRSI
    avgLoss = (avgLoss*(periodRSI-1)+loss)/periodRSI
    
    RS = avgGain / avgLoss
    
    # current RSI
    index = index + 1
    RSI[index] = 100 - (100/(1+RS))
    
    # LL and HH for period day
    lowestLow = RSI[index-periodRSI+1]
    highestHigh = RSI[index-periodRSI+1]
    
    for(j in (index-periodRSI+2):(index)){
      if(RSI[j] < lowestLow){
        lowestLow = RSI[j]
      } else if(RSI[j] > highestHigh){
        highestHigh = RSI[j]
      } 
    }
    
    StochRSI = (RSI[index]-lowestLow)/(highestHigh-lowestLow)
    
    # generating signal of stochRSI
    
    # catching an uptrend
    if(dataset1[i,lowSMAString]>dataset1[i,highSMAString]  &&
       StochRSI < bottomValue){
      bottomCatched = TRUE
      ceilingCatched = FALSE
    }
    
    if(dataset1[i,lowSMAString]>dataset1[i,highSMAString] &&
       StochRSI > uptrendValue &&
       bottomCatched == TRUE &&
       SignalStochRSI != "rise"){
      SignalStochRSI = "rise"
    }
    
    # catching a downtrend
    if(dataset1[i,lowSMAString]<dataset1[i,highSMAString]  &&
       StochRSI > ceilingValue){
      ceilingCatched = TRUE
      bottomCatched = FALSE
    }
    
    if(dataset1[i,lowSMAString]<dataset1[i,highSMAString] &&
       StochRSI < downtrendValue &&
       ceilingCatched == TRUE &&
       SignalStochRSI != "fall"){
      SignalStochRSI = "fall"
    }
    
    # breaking an uptrend
    if(StochRSI < 0.5 &&
       SignalStochRSI == "rise"){
      SignalStochRSI = "silent"
      bottomCatched = FALSE
    }
    
    # breaking a downtrend
    if(StochRSI > 0.5 &&
       SignalStochRSI == "fall"){
      SignalStochRSI = "silent"
      ceilingCatched = FALSE
    }
    
    dataset1[i,paste0("SignalStochRSI",ten)] = SignalStochRSI
  }
  
  return(dataset1)
}