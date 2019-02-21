########################
#TRIX indicator & signal
########################
TRIX = function(dataset1,ten,periodTRIX,periodSignalLine){
  # calculting first SMA & EMAs
  multiplier = 2/(periodTRIX+1)
  
  # single-smoothed EMAs
  sum = 0
  for(j in (3*periodTRIX-2+periodSignalLine):(2*periodTRIX-1+periodSignalLine)){
    sum = sum + dataset1[1,paste0("Close-",j)]
  }
  SMA = sum / periodTRIX
  
  singleEMA = vector()
  index = 1
  singleEMA[index] = SMA
  for(j in (2*periodTRIX-1+periodSignalLine):1){
    name = paste0("Close-",j)
    index = index + 1
    singleEMA[index] =(dataset1[1,name]-singleEMA[index-1])*multiplier+singleEMA[index-1]
  }
  
  # double-smoothed EMAs
  sum = 0
  for(j in 2:(periodTRIX+1)){
    sum = sum + singleEMA[j]
  }
  SMA = sum / periodTRIX
  
  doubleEMA = vector()
  doubleEMA[periodTRIX] = SMA
  for(j in (periodTRIX+1):index){
    doubleEMA[j] = (singleEMA[j]-doubleEMA[j-1])*multiplier+doubleEMA[j-1]
  }
  
  # triple-smoothed EMAs
  sum = 0
  for(j in (periodTRIX+1):(2*periodTRIX)){
    sum = sum + doubleEMA[j]
  }
  SMA = sum / periodTRIX
  
  sumTrix = 0
  tripleEMA = vector()
  tripleEMA[2*periodTRIX] = SMA
  for(j in (2*periodTRIX+1):index){
    tripleEMA[j] = (doubleEMA[j]-tripleEMA[j-1])*multiplier+tripleEMA[j-1]
    trixx = (tripleEMA[j]-tripleEMA[j-1])/(tripleEMA[j-1]/100)
    sumTrix = sumTrix + trixx
  }
  
  SMA = sumTrix / periodSignalLine
  signalMultiplier = 2/(periodSignalLine+1)
  signalLine = (trixx-SMA)*signalMultiplier+SMA
  
  numTrix = vector()
  # TRIX and SignalLine for every row
  for(i in 1:nrow(dataset1)){
    index = index + 1
    singleEMA[index] = (dataset1[i,"Close"]-singleEMA[index-1])*multiplier+singleEMA[index-1]
    doubleEMA[index] = (singleEMA[index]-doubleEMA[index-1])*multiplier+doubleEMA[index-1]
    tripleEMA[index] = (doubleEMA[index]-tripleEMA[index-1])*multiplier+tripleEMA[index-1]
    
    # numTrix
    numTrix[i] = (tripleEMA[index]-tripleEMA[index-1])/(tripleEMA[index-1]/100)
    
    # Signal Line
    signalLine = (numTrix[i]-signalLine)*signalMultiplier+signalLine
      
      #generating signal of numTrix
      if(i>2){
        if(numTrix[i]>0 && numTrix[i]>signalLine &&
           numTrix[i]>numTrix[i-1] &&
           numTrix[i-1]>numTrix[i-2]){
          dataset1[i,paste0("SignalTRIX",ten)] = "rise"
        } else if(numTrix[i]<0 && numTrix[i]<signalLine &&
                  numTrix[i]<numTrix[i-1] &&
                  numTrix[i-1]<numTrix[i-2]){
          dataset1[i,paste0("SignalTRIX",ten)] = "fall"
        } else {
          dataset1[i,paste0("SignalTRIX",ten)] = "silent"
        }
      } else{
        dataset1[i,paste0("SignalTRIX",ten)] = "silent"
      }
  }
  
  return(dataset1)
}