# function tests and finds best settings for StochRSI indicator

source("indicators/StochRSI.R")
source("optimalization/scoreIndicator.R")

testAndValidateStochRSI = function(){
  validatedDF = data.frame()
  tendency = c(1,3,7,14,30)
  
  for(indexSR in 1:5){
    testedDF = data.frame()
    testIndex = 0
    bestSuccessRate = 0
    maxNumberOfSignals = 0
    bestIndex = 1
    
    # initial values
    periodRSI = c(4,11,15)
    highSMA = c(7,14,30)
    lowSMA = c(highSMA[1]%/%2,highSMA[2]%/%2,highSMA[3]%/%2)
    bottomValue = c(0.2,0.35,0.40)
    ceilingValue = c(1-bottomValue[1],1-bottomValue[2],1-bottomValue[3])
    downtrendValue = c(0.40,0.30,0.35)
    uptrendValue = c(1-downtrendValue[1],1-downtrendValue[2],1-downtrendValue[3])
      
      # testing  
      for(a in 1:length(periodRSI)){
        for(b in 1:length(highSMA)){
            for(c in 1:length(bottomValue)){
                  for(d in 1:length(downtrendValue)){
                    #test strategy
                    data = StochRSI(data,tendency[indexSR],periodRSI[a],highSMA[b],lowSMA[b],bottomValue[c],
                               ceilingValue[c],uptrendValue[d],downtrendValue[d])
                    
                    # number of indicator signals
                    testIndex = testIndex + 1
                    numberOfSignals = 0
                    for(x in 1:nrow(data)){
                      if(data[x,paste0("SignalStochRSI",tendency[indexSR])] == "rise" || data[x,paste0("SignalStochRSI",tendency[indexSR])] == "fall")  
                        numberOfSignals = numberOfSignals + 1 
                    }
                    testedDF[testIndex,"NumberOfSignals"] = numberOfSignals
                    if(testedDF[testIndex,"NumberOfSignals"]>maxNumberOfSignals)
                      maxNumberOfSignals = testedDF[testIndex,"NumberOfSignals"]
                    
                    # success rate
                    testedDF[testIndex,"SuccessRate"] = scoreIndicator(data,paste0("StochRSI",tendency[indexSR]),tendency[indexSR])
                    if(testedDF[testIndex,"SuccessRate"]>bestSuccessRate){
                      bestSuccessRate = testedDF[testIndex,"SuccessRate"]
                      bestIndex = testIndex
                    }
                    
                    # save parameters values
                    testedDF[testIndex,"PeriodRSI"] = periodRSI[a]
                    testedDF[testIndex,"HighSMA"] = highSMA[b]
                    testedDF[testIndex,"LowSMA"] = lowSMA[b]
                    testedDF[testIndex,"BottomValue"] = bottomValue[c]
                    testedDF[testIndex,"CeilingValue"] = ceilingValue[c]
                    testedDF[testIndex,"UptrendValue"] = uptrendValue[d]
                    testedDF[testIndex,"DowntrendValue"] = downtrendValue[d]
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
    validatedDF[indexSR,"PeriodTendency"] = tendency[indexSR]
    validatedDF[indexSR,"SuccessRate"] = testedDF[bestIndex,"SuccessRate"]
    validatedDF[indexSR,"NumberOfSignals"] = testedDF[bestIndex,"NumberOfSignals"]
    validatedDF[indexSR,"PeriodRSI"] = testedDF[bestIndex,"PeriodRSI"]
    validatedDF[indexSR,"HighSMA"] = testedDF[bestIndex,"HighSMA"]
    validatedDF[indexSR,"LowSMA"] = testedDF[bestIndex,"LowSMA"]
    validatedDF[indexSR,"BottomValue"] = testedDF[bestIndex,"BottomValue"]
    validatedDF[indexSR,"CeilingValue"] = testedDF[bestIndex,"CeilingValue"]
    validatedDF[indexSR,"UptrendValue"] = testedDF[bestIndex,"UptrendValue"]
    validatedDF[indexSR,"DowntrendValue"] = testedDF[bestIndex,"DowntrendValue"]
  }
  
  return(validatedDF)
}


