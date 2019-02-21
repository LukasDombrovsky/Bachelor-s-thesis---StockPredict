########################
# ADL indicator & signal
########################
ADL = function(dataset1,ten,periodADL,multiplierReversalValue,multiplierContValue,volumeRelChangeValue){
  result = "silent"
  
  for(i in 1:nrow(dataset1)){
    # calculate previous ADL
    closePrevious = paste0("Close-",periodADL)
    lowPrevious = paste0("Low-",periodADL)
    highPrevious = paste0("High-",periodADL)
    volumePrevious = paste0("Volume-",periodADL)
    
    moneyFlowMultiplierPrevious = ((dataset1[i,closePrevious]-dataset1[i,lowPrevious])-(dataset1[i,highPrevious]-dataset1[i,closePrevious])) / (dataset1[i,highPrevious]-dataset1[i,lowPrevious])
    moneyFlowVolumePrevious = moneyFlowMultiplierPrevious * dataset1[i,volumePrevious]
    ADLPrevious = moneyFlowVolumePrevious
    
    # calculate current ADL    
    close = "Close"
    low = "Low"
    high = "High"
    volume = "Volume"
    
    moneyFlowMultiplier = ((dataset1[i,close]-dataset1[i,low])-(dataset1[i,high]-dataset1[i,close])) / (dataset1[i,high]-dataset1[i,low])
    moneyFlowVolume = moneyFlowMultiplier * dataset1[i,volume]
    ADL = moneyFlowVolume
    
    # interpretation of ADL as categorical values
    
    # relative change of volume
    volumeRelChange = abs(moneyFlowVolume / ADLPrevious)
    
    # uptrend reversal
    if(closePrevious>close && moneyFlowMultiplier< -multiplierReversalValue &&
       volumeRelChange>volumeRelChangeValue && result == "rise"){
      result = "fall"
    }
    # downtrend reversal
    else if(closePrevious<close && moneyFlowMultiplier>multiplierReversalValue &&
              volumeRelChange>volumeRelChangeValue && result == "fall"){
      result = "rise"
    } 
    # continuation of downtrend
    else if((moneyFlowMultiplier< -multiplierContValue && ADL<ADLPrevious &&
               (result == "silent"|| result == "fall"))){
      
      result = "fall"
    } 
    # continuation of uptrend
    else if((moneyFlowMultiplier>multiplierContValue && ADL>ADLPrevious &&
               (result == "silent" || result == "rise"))){
      
      result = "rise"
    } else {
      result = "silent"
    }
  
    dataset1[i,paste0("SignalADL",ten)] = result
  }
  
  return(dataset1)
}