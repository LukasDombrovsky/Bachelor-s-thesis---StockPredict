# function tests and self improve settings for ADL indicator

source("indicators/ADL.R")
source("optimalization/scoreIndicator.R")

testAndValidateADL = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    periodADL = c(3,8,15)
    multiplierReversalValue = c(0.2,0.5,0.8)
    multiplierContValue = c(0.2,0.5,0.8)
    volumeRelChangeValue = c(0.2,0.5,0.8)
      
      # testing 
      for(d in 1:length(periodADL)){
        for(a in 1:length(multiplierReversalValue)){
          for(b in 1:length(multiplierContValue)){
            for(c in 1:length(volumeRelChangeValue)){
              #test strategy
              data = ADL(data,tendency[indexSR],periodADL[d],multiplierReversalValue[a],
                         multiplierContValue[b],volumeRelChangeValue[c])
              
              # success rate
              testIndex = testIndex + 1
              testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("ADL",tendency[indexSR]),tendency[indexSR])
              if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
                bestSuccessRate = testedDF[testIndex,"SuccessRate"]
                bestIndex = testIndex
              }
              
              # save parameters values
              testedDF[testIndex,"PeriodADL"] = periodADL[d]
              testedDF[testIndex,"MultiplierReversalValue"] = multiplierReversalValue[a]
              testedDF[testIndex,"MultiplierContValue"] = multiplierContValue[b]                                      
              testedDF[testIndex,"VolumeRelChangeValue"] = volumeRelChangeValue[c]
              
              # number of indicator signals
              numberOfSignals = 0
              for(x in 1:nrow(data)){
                if(data[x,paste0("SignalADL",tendency[indexSR])] == "rise" || data[x,paste0("SignalADL",tendency[indexSR])] == "fall")  
                  numberOfSignals = numberOfSignals + 1 
              }
              testedDF[testIndex,"NumberOfSignals"] = numberOfSignals
              if(testedDF[testIndex,"NumberOfSignals"]>maxNumberOfSignals)
                maxNumberOfSignals = testedDF[testIndex,"NumberOfSignals"]
            }
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
    validatedDF[indexSR,"Period"] = tendency[indexSR]
    validatedDF[indexSR,"SuccessRate"] = testedDF[bestIndex,"SuccessRate"]
    validatedDF[indexSR,"NumberOfSignals"] = testedDF[bestIndex,"NumberOfSignals"]
    validatedDF[indexSR,"PeriodADL"] = testedDF[bestIndex,"PeriodADL"]
    validatedDF[indexSR,"MultiplierReversalValue"] = testedDF[bestIndex,"MultiplierReversalValue"]
    validatedDF[indexSR,"MultiplierContValue"] = testedDF[bestIndex,"MultiplierContValue"]
    validatedDF[indexSR,"VolumeRelChangeValue"] = testedDF[bestIndex,"VolumeRelChangeValue"]
  }
  
  return(validatedDF)
}


