# function scores a success of an indicator

scoreIndicator = function(data,indicator,g){
    countRiseSignal = 1
    countPositiveRise = 0
    countFallSignal = 1
    countPositiveFall = 0
    rowIndex = 1
    
    for(rowIndex in 1:nrow(data)){
      if(data[rowIndex,paste0("Signal",indicator)] == "rise" && data[rowIndex,paste0("Tendency+",g)] == "rise"){
        countPositiveRise = countPositiveRise + 1
      } 
      if(data[rowIndex,paste0("Signal",indicator)] == "rise"){
        countRiseSignal = countRiseSignal + 1 
      }
    }
    
    for(rowIndex in 1:nrow(data)){
      if(data[rowIndex,paste0("Signal",indicator)] == "fall" && data[rowIndex,paste0("Tendency+",g)] == "fall"){
        countPositiveFall = countPositiveFall + 1
      } 
      if(data[rowIndex,paste0("Signal",indicator)] == "fall"){
        countFallSignal = countFallSignal + 1 
      }
    }
    
    successRate = (countPositiveRise+countPositiveFall)/(countRiseSignal+countFallSignal)
    return(successRate)
}