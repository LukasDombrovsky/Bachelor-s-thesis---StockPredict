#################################
# ForceIndex indicator and signal
#################################
ForceIndex = function(dataset1,ten,periodFI, periodEMA){
  # first ForceIndex
    FI_1 = vector()
    for(j in periodFI:1){
      FI_1 = c(FI_1,(dataset1[1,paste0("Close-",j-1)] - dataset1[1,paste0("Close-",j)])*dataset1[1,paste0("Volume-",j-1)])
    }
    FI = sum(FI_1) / periodFI
    
  # first EMA
    EMA_1 = vector()
    for(j in periodEMA:1){
      EMA_1 = c(EMA_1,dataset1[1,paste0("Close-",j)]) 
    }
    EMA = sum(EMA_1) / periodEMA
  
  # multipliers      
  MP_FI = (2/(periodFI + 1))
  MP_EMA = (2/(periodEMA + 1))
  
  # ForceIndex(periodFI) and EMA(periodEMA) for every row
  for(i in 1:nrow(dataset1)){
    # FI
    FI = ((dataset1[i,"Close"] - dataset1[i,"Close-1"])*dataset1[i,"Volume"] - FI)*MP_FI + FI
    
    # EMA
    EMA_prev = EMA
    EMA = (dataset1[i,"Close"] - EMA)*MP_EMA + EMA
    
    # SignalForce
    if(EMA_prev < EMA && FI<0){
      dataset1[i,paste0("SignalForceIndex",ten)] = "rise"
    } else if(EMA_prev > EMA && FI>0){
      dataset1[i,paste0("SignalForceIndex",ten)] = "fall"
    } else
      dataset1[i,paste0("SignalForceIndex",ten)] = "silent"
  }
  return(dataset1)
}