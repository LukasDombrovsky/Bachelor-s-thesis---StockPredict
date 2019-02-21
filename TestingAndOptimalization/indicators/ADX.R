##########################
# ADX indicator and signal
##########################
ADX = function(dataset1,ten,mainPeriod,trendBorder){
  upTrend = FALSE
  downTrend = FALSE
  signal = "silent"
  
  # first row
  TR1 = vector()
  posDM1 = vector()
  negDM1 = vector()
  periodPosDM = 0
  periodNegDM = 0
  periodPosDI = 0
  periodNegDI = 0
  DX = vector()
  
  for(i in (2*mainPeriod-1):1){
    # TR
    HL=dataset1[1,paste0("High-",i)]-dataset1[1,paste0("Low-",i)]
    HCP=abs(dataset1[1,paste0("High-",i)]-dataset1[1,paste0("Close-",i+1)])
    LCP=abs(dataset1[1,paste0("Low-",i)]-dataset1[1,paste0("Close-",i+1)])
    TR1 = c(TR1,max(HL,HCP,LCP))
    
    # DM
    highsDif = dataset1[1,paste0("High-",i)]-dataset1[1,paste0("High-",i+1)]
    lowsDif = dataset1[1,paste0("Low-",i+1)]-dataset1[1,paste0("Low-",i)] 
    
    if(highsDif<0) highsDif = 0
    if(lowsDif<0) lowsDif = 0
    
    if(highsDif>lowsDif){
      posDM1 = c(posDM1, highsDif)
      negDM1 = c(negDM1, 0)
    } else {
      posDM1 = c(posDM1, 0)
      negDM1 = c(negDM1, lowsDif)
    }
   
    if(i < (mainPeriod+1)){
      # periodTR
      if(i==mainPeriod) periodTR = sum(TR1) 
      else periodTR = periodTR - (periodTR/mainPeriod) + TR1[i]
      
      # periodPosDM
      if(i==mainPeriod) periodPosDM = sum(posDM1) 
      else periodPosDM = periodPosDM - (periodPosDM/mainPeriod) + posDM1[i]
      
      # periodNegDM
      if(i==mainPeriod) periodNegDM = sum(negDM1) 
      else periodNegDM = periodNegDM - (periodNegDM/mainPeriod) + negDM1[i]
      
      # periodPosDI
      periodPosDI = (periodPosDM/periodTR)*100
      
      # negDI14
      periodNegDI = (periodNegDM/periodTR)*100
      
      # DX
      DX = c(DX,abs(periodPosDI-periodNegDI)/sum(periodPosDI,periodNegDI)*100)
    }  
  }
  
  ADX = vector()
  breakpoint = 0
  
  # other rows
  for(i in 1:nrow(dataset1)){
    # TR
    HL=dataset1[i,"High"]-dataset1[i,"Low"]
    HCP=abs(dataset1[i,"High"]-dataset1[i,"Close-1"])
    LCP=abs(dataset1[i,"Low"]-dataset1[i,"Close-1"])
    TR1[i] = max(HL,HCP,LCP)
    
    # DM
    highsDif = dataset1[i,"High"]-dataset1[i,"High-1"]
    lowsDif = dataset1[i,"Low-1"]-dataset1[i,"Low"] 
    
    if(highsDif<0) highsDif = 0
    if(lowsDif<0) lowsDif = 0
    
    if(highsDif>lowsDif){
      posDM1[i] = highsDif
      negDM1[i] = 0
    } else {
      posDM1[i] = 0
      negDM1[i] = lowsDif
    }
    
    # smooth the TR, +DM and -DM
      # periodTR
      periodTR = periodTR - (periodTR/mainPeriod) + TR1[i]
      
      # periodPosDM
      periodPosDM = periodPosDM - (periodPosDM/mainPeriod) + posDM1[i]
      
      # periodNegDM
      periodNegDM = periodNegDM - (periodNegDM/mainPeriod) + negDM1[i]
      
      # periodPosDI
      periodPosDI = (periodPosDM/periodTR)*100
      
      # periodNegDI
      periodNegDI = (periodNegDM/periodTR)*100
      
      # DX
      DX = c(DX,abs(periodPosDI-periodNegDI)/sum(periodPosDI,periodNegDI)*100)
    
    # ADX
      if(i==1) ADX[i] = sum(DX[2:mainPeriod])/mainPeriod
      else ADX[i] = ((mainPeriod-1)*ADX[i-1]+DX[i])/mainPeriod
      
      # signal ADX
      if(ADX[i]>trendBorder && signal=="silent" &&
         periodPosDI>periodNegDI){
        breakpoint = dataset1[i,"Low"]
        signal = "rise"
      }
      
      if(signal=="rise" && dataset1[i,"Close"]<breakpoint){
        signal = "silent"
      }
      
      if(ADX[i]>trendBorder && signal=="silent" &&
         periodNegDI>periodPosDI){
        breakpoint = dataset1[i,"High"]
        signal = "fall"
      }
      
      if(signal=="fall" && dataset1[i,"Close"]>breakpoint){
        signal = "silent"
      }
      
      dataset1[i,paste0("SignalADX",ten)] = signal
  }
  return(dataset1)
}