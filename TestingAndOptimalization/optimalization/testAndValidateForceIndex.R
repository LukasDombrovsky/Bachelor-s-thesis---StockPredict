# function tests and self improve settings for ForceIndex indicator

source("indicators/ForceIndex.R")
source("optimalization/scoreIndicator.R")

testAndValidateForceIndex = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    periodFI = c(3,5,12)
    periodEMA = c(15,22,35)
      
      # testing  
      for(a in 1:length(periodFI)){
        for(b in 1:length(periodEMA)){
          # test strategy
          data = ForceIndex(data,tendency[indexSR],periodFI[a],periodEMA[b])
          
          # success rate
          testIndex = testIndex + 1
          testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("ForceIndex",tendency[indexSR]),tendency[indexSR])
          if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
            bestSuccessRate = testedDF[testIndex,"SuccessRate"]
            bestIndex = testIndex
          }
          
          # save parameters values
          testedDF[testIndex,"PeriodFI"] = periodFI[a]
          testedDF[testIndex,"PeriodEMA"] = periodEMA[b]                                      
          
          # number of indicator signals
          numberOfSignals = 0
          for(x in 1:nrow(data)){
            if(data[x,paste0("SignalForceIndex",tendency[indexSR])] == "rise" || data[x,paste0("SignalForceIndex",tendency[indexSR])] == "fall")  
              numberOfSignals = numberOfSignals + 1 
          }
          testedDF[testIndex,"NumberOfSignals"] = numberOfSignals
          if(testedDF[testIndex,"NumberOfSignals"]>maxNumberOfSignals)
            maxNumberOfSignals = testedDF[testIndex,"NumberOfSignals"]
        }
      }
    
    # validation more volatile
    bestIndex = 1
    for(validationIndex in 2:nrow(testedDF)){
      if(testedDF[validationIndex,"NumberOfSignals"]>(0.35*maxNumberOfSignals) &&
         testedDF[bestIndex,"SuccessRate"] < testedDF[validationIndex,"SuccessRate"]){
        bestIndex = validationIndex        
      }
    }
    
    
    # best settings for a current tendency
    validatedDF[indexSR,"Period"] = tendency[indexSR]
    validatedDF[indexSR,"SuccessRate"] = testedDF[bestIndex,"SuccessRate"]
    validatedDF[indexSR,"NumberOfSignals"] = testedDF[bestIndex,"NumberOfSignals"]
    validatedDF[indexSR,"PeriodFI"] = testedDF[bestIndex,"PeriodFI"]
    validatedDF[indexSR,"PeriodEMA"] = testedDF[bestIndex,"PeriodEMA"]
  }
  
  return(validatedDF)
}