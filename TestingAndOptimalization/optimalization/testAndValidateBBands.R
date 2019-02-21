# function tests and self improve settings for BBands indicator

source("indicators/BBands.R")
source("optimalization/scoreIndicator.R")

testAndValidateBBands = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    period = c(5,23,50)
      
      # testing  
      for(a in 1:length(period)){
            #test strategy
            data = BBands(data,tendency[indexSR],period[a])
            
            # success rate
            testIndex = testIndex + 1
            testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("BBands",tendency[indexSR]),tendency[indexSR])
            if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
              bestSuccessRate = testedDF[testIndex,"SuccessRate"]
              bestIndex = testIndex
            }
            
            # save parameters values
            testedDF[testIndex,"Period"] = period[a]
            
            # number of indicator signals
            numberOfSignals = 0
            for(x in 1:nrow(data)){
              if(data[x,paste0("SignalBBands",tendency[indexSR])] == "rise" || data[x,paste0("SignalBBands",tendency[indexSR])] == "fall")  
                numberOfSignals = numberOfSignals + 1 
            }
            testedDF[testIndex,"NumberOfSignals"] = numberOfSignals
            if(testedDF[testIndex,"NumberOfSignals"]>maxNumberOfSignals)
              maxNumberOfSignals = testedDF[testIndex,"NumberOfSignals"]
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
  }
  
  return(validatedDF)
}