##########################################
# ROC indicator & signal
# using for indetifing oversold
# or overbought extremes
##########################################
ROC = function(dataset1,ten,periodROC,percentage,periodSMA,periodClose){
  SMA = paste0("SMA(",periodSMA,")")
  # calculating numerical ROC
  name = paste0("Close-",periodROC)
  numROC = vector()
  firstROC = ((dataset1[1,"Close-1"]-dataset1[1,paste0("Close-",periodROC+1)])/dataset1[1,paste0("Close-",periodROC+1)])*100
  
  for(i in 1:nrow(dataset1)){
    numROC[i] = ((dataset1[i,"Close"]-dataset1[i,name])/dataset1[i,name])*100   
  }
  
  situation = "silent"
  for(i in 1:nrow(dataset1)){
    if(i==1){
      if(numROC[i]>firstROC && dataset1[i,"Close"]>dataset1[i,paste0("Close-",periodClose)] &&
         dataset1[i,"Close"]>dataset1[i,SMA]){
        situation = "rise"
      } else if(numROC[i]>percentage && dataset1[i,"Close"]>dataset1[i,paste0("Close-",periodClose)]){
        situation = "rise"
      } else if(numROC[i]<firstROC && dataset1[i,"Close"]<dataset1[i,paste0("Close-",periodClose)] &&
                dataset1[i,"Close"]<dataset1[i,SMA]){
        situation = "fall"
      } else if(numROC[i]< -percentage && dataset1[i,"Close"]<dataset1[i,paste0("Close-",periodClose)]){
        situation = "fall"
      } else{
        situation = "silent"
      }
    } else {
      if(numROC[i]>numROC[i-1] && dataset1[i,"Close"]>dataset1[i,paste0("Close-",periodClose)] &&
         dataset1[i,"Close"]>dataset1[i,SMA]){
        situation = "rise"
      } else if(numROC[i]>percentage && dataset1[i,"Close"]>dataset1[i,paste0("Close-",periodClose)]){
        situation = "rise"
      } else if(numROC[i]<numROC[i-1] && dataset1[i,"Close"]<dataset1[i,paste0("Close-",periodClose)] &&
                dataset1[i,"Close"]<dataset1[i,SMA]){
        situation = "fall"
      } else if(numROC[i]< -percentage && dataset1[i,"Close"]<dataset1[i,paste0("Close-",periodClose)]){
        situation = "fall"
      } else{
        situation = "silent"
      }
    }
    dataset1[i,paste0("SignalROC",ten)] = situation
  }
  return(dataset1)
}
