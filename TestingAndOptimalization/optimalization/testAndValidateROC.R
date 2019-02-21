# function tests and self improve settings for ROC indicator

source("indicators/ROC.R")
source("optimalization/scoreIndicator.R")

testAndValidateROC = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    periodROC = c(7,9,11)
    percentage = c(3,10,20)
    periodSMA = c(10,20,30)
    periodClose = c(5,15,30)
    # testPeriod = length(periodROC)*length(percentage)*length(periodSMA)*length(periodClose)
      
      # testing  
      for(a in 1:length(periodROC)){
        for(b in 1:length(percentage)){
          for(c in 1:length(periodSMA)){
            for(d in 1:length(periodClose)){
              #test strategy
              data = ROC(data,tendency[indexSR],periodROC[a],percentage[b],periodSMA[c],periodClose[d])
              
              # success rate
              testIndex = testIndex + 1
              testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("ROC",tendency[indexSR]),tendency[indexSR])
              if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
                bestSuccessRate = testedDF[testIndex,"SuccessRate"]
                bestIndex = testIndex
              }
              
              # save parameters values
              testedDF[testIndex,"PeriodROC"] = periodROC[a]
              testedDF[testIndex,"Percentage"] = percentage[b]
              testedDF[testIndex,"PeriodSMA"] = periodSMA[c]
              testedDF[testIndex,"PeriodClose"] = periodClose[c]
              
              # number of indicator signals
              numberOfSignals = 0
              for(x in 1:nrow(data)){
                if(data[x,paste0("SignalROC",tendency[indexSR])] == "rise" || data[x,paste0("SignalROC",tendency[indexSR])] == "fall")  
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
    validatedDF[indexSR,"PeriodROC"] = testedDF[bestIndex,"PeriodROC"]
    validatedDF[indexSR,"Percentage"] = testedDF[bestIndex,"Percentage"]
    validatedDF[indexSR,"PeriodSMA"] = testedDF[bestIndex,"PeriodSMA"]
    validatedDF[indexSR,"PeriodClose"] = testedDF[bestIndex,"PeriodClose"]
  }
  
  return(validatedDF)
}