#############################################
# Bolinger Bands indicator and signal
# calculating 3 bands(upper,lower,middle)
# observing to which one price is the closest
# and deviation from this band
#############################################
BBands = function(dataset1,ten,period){
  for(i in 1:nrow(dataset1)){
    sum = 0
    closeValues = vector()
    for(j in period:1){
      sum = sum + dataset1[i,paste0("Close-",j)]
      closeValues = c(closeValues,dataset1[i,paste0("Close-",j)])
    }
    middleBand = sum/period
    upperBand = middleBand +(sd(closeValues)*2)
    lowerBand = middleBand -(sd(closeValues)*2)
    
    diffM = dataset1[i,"Close"] - middleBand
    diffU = dataset1[i,"Close"] - upperBand
    diffL = dataset1[i,"Close"] - lowerBand
    
    if(abs(diffM)<abs(diffU)){
      if(abs(diffM)<abs(diffL)){
        dataset1[i,paste0("SignalBBands",ten)] = "silent" 
      } else{
        if(diffL<(lowerBand+sd(closeValues)/2)){
          dataset1[i,paste0("SignalBBands",ten)] = "rise" 
        } else {
          dataset1[i,paste0("SignalBBands",ten)] = "silent" 
        }
      }
    }
    else if(abs(diffU)<abs(diffL)){
      if(diffU<(upperBand-sd(closeValues)/2)){
        dataset1[i,paste0("SignalBBands",ten)] = "fall" 
      } else {
        dataset1[i,paste0("SignalBBands",ten)] = "silent" 
      }
    } else {
      if(diffL<(lowerBand+sd(closeValues)/2)){
        dataset1[i,paste0("SignalBBands",ten)] = "rise" 
      } else {
        dataset1[i,paste0("SignalBBands",ten)] = "silent" 
      }
    } 
  }
  return(dataset1)
}