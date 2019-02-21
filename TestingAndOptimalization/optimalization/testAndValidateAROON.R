# function tests and self improve settings for AROON indicator

source("indicators/AROON.R")
source("optimalization/scoreIndicator.R")

testAndValidateAROON = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    period = c(5,27,30)
    highValue = c(90,85,80)
    lowValue = c(10,15,20)

      # testing  
      for(a in 1:length(period)){
        for(b in 1:length(highValue)){
          for(c in 1:length(lowValue)){
            #test strategy
            data = AROON(data,tendency[indexSR],period[a],highValue[b],lowValue[c])
            
            # success rate
            testIndex = testIndex + 1
            testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("AROON",tendency[indexSR]),tendency[indexSR])
            if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
              bestSuccessRate = testedDF[testIndex,"SuccessRate"]
              bestIndex = testIndex
            }
            
            # save parameters values
            testedDF[testIndex,"Period"] = period[a]
            testedDF[testIndex,"HighValue"] = highValue[b]
            testedDF[testIndex,"LowValue"] = lowValue[c]
            
            # number of indicator signals
            numberOfSignals = 0
            for(x in 1:nrow(data)){
              if(data[x,paste0("SignalAROON",tendency[indexSR])] == "rise" || data[x,paste0("SignalAROON",tendency[indexSR])] == "fall")  
                numberOfSignals = numberOfSignals + 1 
            }
            testedDF[testIndex,"NumberOfSignals"] = numberOfSignals
            if(testedDF[testIndex,"NumberOfSignals"]>maxNumberOfSignals)
              maxNumberOfSignals = testedDF[testIndex,"NumberOfSignals"]
          }
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
    validatedDF[indexSR,"PeriodTendency"] = tendency[indexSR]
    validatedDF[indexSR,"SuccessRate"] = testedDF[bestIndex,"SuccessRate"]
    validatedDF[indexSR,"NumberOfSignals"] = testedDF[bestIndex,"NumberOfSignals"]
    validatedDF[indexSR,"Period"] = testedDF[bestIndex,"Period"]
    validatedDF[indexSR,"HighValue"] = testedDF[bestIndex,"HighValue"]
    validatedDF[indexSR,"LowValue"] = testedDF[bestIndex,"LowValue"]
  }
  
  return(validatedDF)
}