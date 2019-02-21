###############################################
# Preprocessing Data For Azure Machine Learning
###############################################
PreprocessDataForAzure = function(dataset1){
  # reverse dataframe
  dataset1 = dataset1[rev(rownames(dataset1)),]
  
  # we need only these columns for calculation
  dataset1 = dataset1[,c("High","Low","Close","Volume")]
  
  ##########################################################
  # Adding close, high, low prices, volumes and medium trend
  # of periods before and after current period
  ##########################################################
  for(i in 62:nrow(dataset1)){
    count = 62
    for(j in (i-61):(i-1)){
      count = count - 1
      name = paste0("Volume-", count)
      dataset1[i,name] = dataset1[j,"Volume"]
      name = paste0("High-", count)
      dataset1[i,name] = dataset1[j,"High"]
      name = paste0("Low-", count)
      dataset1[i,name] = dataset1[j,"Low"]
      name = paste0("Close-",count)
      dataset1[i,name] = dataset1[j,"Close"]
      
    }
    
    # SMAs
    for(j in 60:2){
      SMA = 0
      for(k in (i-j):1){
        SMA = SMA + dataset1[k,"Close"]
      }
      dataset1[i,paste0("SMA(",j,")")] = SMA/j
    }
  }
  
  # delete first 61 rows, because we dont have previous periods for them
  dataset1 = dataset1[62:nrow(dataset1),]
  
  return(dataset1)
}