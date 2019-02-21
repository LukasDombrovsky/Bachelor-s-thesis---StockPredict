# function tests combination of wide settings for ADX indicator

source("indicators/ADX.R")
source("optimalization/scoreIndicator.R")

testAndValidateADX = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    mainPeriod = c(2,10,20)
    trendBorder = c(15,27,35)
      
      # testing  
      for(a in 1:length(mainPeriod)){
        for(b in 1:length(trendBorder)){
            #test strategy
            data = ADX(data,tendency[indexSR],mainPeriod[a],trendBorder[b])
            
            # success rate
            testIndex = testIndex + 1
            testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("ADX",tendency[indexSR]),tendency[indexSR])
            if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
              bestSuccessRate = testedDF[testIndex,"SuccessRate"]
              bestIndex = testIndex
            }
            
            # save parameters values
            testedDF[testIndex,"MainPeriod"] = mainPeriod[a]
            testedDF[testIndex,"TrendBorder"] = trendBorder[b]                                      
            
            # number of indicator signals
            numberOfSignals = 0
            for(x in 1:nrow(data)){
              if(data[x,paste0("SignalADX",tendency[indexSR])] == "rise" || data[x,paste0("SignalADX",tendency[indexSR])] == "fall")  
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
    validatedDF[indexSR,"MainPeriod"] = testedDF[bestIndex,"MainPeriod"]
    validatedDF[indexSR,"TrendBorder"] = testedDF[bestIndex,"TrendBorder"]
  }
  
  return(validatedDF)
}
