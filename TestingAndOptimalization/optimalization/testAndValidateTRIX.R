# function tests and self improve settings for TRIX indicator

source("indicators/TRIX.R")
source("optimalization/scoreIndicator.R")

testAndValidateTRIX = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    periodTRIX = c(4,8,12)
    periodSignalLine = c(2,4,6)
    
      # testing  
      for(a in 1:length(periodTRIX)){
        for(b in 1:length(periodSignalLine)){
          # test strategy
          data = TRIX(data,tendency[indexSR],periodTRIX[a],periodSignalLine[b])
          
          # success rate
          testIndex = testIndex + 1
          testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("TRIX",tendency[indexSR]),tendency[indexSR])
          if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
            bestSuccessRate = testedDF[testIndex,"SuccessRate"]
            bestIndex = testIndex
          }
          
          # save parameters values
          testedDF[testIndex,"PeriodTRIX"] = periodTRIX[a]
          testedDF[testIndex,"PeriodSignalLine"] = periodSignalLine[b]                                      
          
          # number of indicator signals
          numberOfSignals = 0
          for(x in 1:nrow(data)){
            if(data[x,paste0("SignalTRIX",tendency[indexSR])] == "rise" || data[x,paste0("SignalTRIX",tendency[indexSR])] == "fall")  
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
    validatedDF[indexSR,"PeriodTRIX"] = testedDF[bestIndex,"PeriodTRIX"]
    validatedDF[indexSR,"PeriodSignalLine"] = testedDF[bestIndex,"PeriodSignalLine"]
  }
  
  return(validatedDF)
}