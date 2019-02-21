# function tests and self improve settings for SAR indicator

source("indicators/SAR.R")
source("optimalization/scoreIndicator.R")

testAndValidateSAR = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    startAF = c(0.01,0.02,0.03)
    increaseAF = c(0.02,0.03,0.04)
    maxAF = c(0.1,0.2,0.3)
      
      # testing  
        for(a in 1:length(startAF)){
          for(b in 1:length(increaseAF)){
            for(c in 1:length(maxAF)){
              #test strategy
              data = SAR(data,tendency[indexSR],startAF[a],increaseAF[b],maxAF[c])
              
              # success rate
              testIndex = testIndex + 1
              testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("SAR",tendency[indexSR]),tendency[indexSR])
              if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
                bestSuccessRate = testedDF[testIndex,"SuccessRate"]
                bestIndex = testIndex
              }
              
              # save parameters values
              testedDF[testIndex,"StartAF"] = startAF[a]
              testedDF[testIndex,"IncreaseAF"] = increaseAF[b]
              testedDF[testIndex,"MaxAF"] = maxAF[c]
              
              # number of indicator signals
              numberOfSignals = 0
              for(x in 1:nrow(data)){
                if(data[x,paste0("SignalSAR",tendency[indexSR])] == "rise" || data[x,paste0("SignalSAR",tendency[indexSR])] == "fall")  
                  numberOfSignals = numberOfSignals + 1 
              }
              testedDF[testIndex,"NumberOfSignals"] = numberOfSignals
              if(testedDF[testIndex,"NumberOfSignals"]>maxNumberOfSignals)
                maxNumberOfSignals = testedDF[testIndex,"NumberOfSignals"]
            }
          }
        }
    
    # validation
    bestIndex = 1
    
    for(validationIndex in 2:nrow(testedDF)){
      if(testedDF[validationIndex,"NumberOfSignals"]>(0.35*maxNumberOfSignals) &&
         testedDF[bestIndex,"SuccessRate"] < testedDF[validationIndex,"SuccessRate"]
      ){
        bestIndex = validationIndex        
      }
    }
    
    # best settings for a current tendency
    validatedDF[indexSR,"PeriodTendency"] = tendency[indexSR]
    validatedDF[indexSR,"SuccessRate"] = testedDF[bestIndex,"SuccessRate"]
    validatedDF[indexSR,"NumberOfSignals"] = testedDF[bestIndex,"NumberOfSignals"]
    validatedDF[indexSR,"StartAF"] = testedDF[bestIndex,"StartAF"]
    validatedDF[indexSR,"IncreaseAF"] = testedDF[bestIndex,"IncreaseAF"]
    validatedDF[indexSR,"MaxAF"] = testedDF[bestIndex,"MaxAF"]
  }
  
  return(validatedDF)
}