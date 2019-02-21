# function gets current market data for every company
# transforms market data to signal data
# calls Azure web service for a desired tendency
# transforms incoming data from Azure to price movement forecast

# source indicators
source("indicators/StochRSI.R")
source("indicators/TRIX.R")
source("indicators/ADL.R")
source("indicators/ROC.R")
source("indicators/BBands.R")
source("indicators/SAR.R")
source("indicators/ADX.R")
source("indicators/ForceIndex.R")
source("indicators/AROON.R")

# source preprocessing function
source("preprocessDataForAzure.R")

# today we want to predict from past close prices 
yesterday = as.Date(Sys.Date(),format="%Y-%m-%d")-1
startDay = yesterday - 170

# initial values
# datesAndRatesForPredicitons = data.frame(ten3Date = yesterday-40,ten7Date = yesterday-40,ten14Date = yesterday-40,ten30Date = yesterday-40,
#                    AAPLten3Signal = "rise",AAPLten3Accuracy = 50,AAPLten7Signal = "rise",AAPLten7Accuracy = 50,AAPLten14Signal = "rise",AAPLten14Accuracy = 50,AAPLten30Signal = "rise",AAPLten30Accuracy = 50,
#                    BACten3Signal = "rise",BACten3Accuracy = 50,BACten7Signal = "rise",BACten7Accuracy = 50,BACten14Signal = "rise",BACten14Accuracy = 50,BACten30Signal = "rise",BACten30Accuracy = 50,
#                    INTCten3Signal = "rise",INTCten3Accuracy = 50,INTCten7Signal = "rise",INTCten7Accuracy = 50,INTCten14Signal = "rise",INTCten14Accuracy = 50,INTCten30Signal = "rise",INTCten30Accuracy = 50)
# write.csv(datesAndRatesForPredicitons,"data/datesAndRatesForPredicitons.csv",row.names=FALSE)

# vector of companies and tendencies
companies = c("AAPL","BAC","INTC")
tendencies = vector()
tendency = c(1,3,7,14,30)
market = "NASDAQ"

# help vectors for parsing url for yahoo finance
ed = vector()
ed[1] = as.character(format(yesterday,"%b"))
ed[2] = as.numeric(format(yesterday,"%d"))
ed[3] = as.numeric(format(yesterday,"%Y"))

sd = vector()
sd[1] = as.character(format(startDay,"%b")) 
sd[2] = as.numeric(format(startDay,"%d"))
sd[3] = as.numeric(format(startDay,"%Y"))

# read last predicted dates for periods 3,7,14,30
datesAndRatesForPredicitons = read.csv("data/datesAndRatesForPredicitons.csv", as.is = TRUE)

# decide for which tendency we need to make prediction
if((yesterday-as.Date(datesAndRatesForPredicitons[1,"ten3Date"]))>=2){
  tendencies = c(tendencies,3)
}

if((yesterday-as.Date(datesAndRatesForPredicitons[1,"ten7Date"]))>=6){
  tendencies = c(tendencies,7)
}

if((yesterday-as.Date(datesAndRatesForPredicitons[1,"ten14Date"]))>=13){
  tendencies = c(tendencies,14)
}

if((yesterday-as.Date(datesAndRatesForPredicitons[1,"ten30Date"]))>=13){
  tendencies = c(tendencies,30)
}

# process data for Azure ML
if(length(tendencies>0)){
  for(companiesIndex in 1:length(companies)){
    processedData = data.frame()
    
    if(companies[companiesIndex] == "BAC")
      market = "NYSE"
    else
      market = "NASDAQ"
    
    processedData = read.csv(url(paste0("http://www.google.com/finance/historical?q=",market,":",companies[companiesIndex],
                                        "&startdate=",sd[1],"+,",sd[2],"%2C+",sd[3],
                                        "&enddate=",ed[1],"+",ed[2],"%2C+",ed[3],"&output=csv")))
  
    processedData = PreprocessDataForAzure(processedData)
    
    processedData = processedData[(nrow(processedData)-1):nrow(processedData),]
    
    optimalizedIndicatorsParam = read.csv(paste0("data/backupOptimizedParameters/backupSignals",companies[companiesIndex],".csv"))
    
    
    # process dataFrame for Azure
    for(tendencyIndex in 1:length(tendency)){
      
      processedData = ADX(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,4],optimalizedIndicatorsParam[tendencyIndex,5])
      processedData = ForceIndex(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,9],optimalizedIndicatorsParam[tendencyIndex,10])
      processedData = ROC(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,14],optimalizedIndicatorsParam[tendencyIndex,15],optimalizedIndicatorsParam[tendencyIndex,16],optimalizedIndicatorsParam[tendencyIndex,17])
      processedData = StochRSI(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,27],optimalizedIndicatorsParam[tendencyIndex,28],optimalizedIndicatorsParam[tendencyIndex,29],optimalizedIndicatorsParam[tendencyIndex,30],optimalizedIndicatorsParam[tendencyIndex,31],optimalizedIndicatorsParam[tendencyIndex,32],optimalizedIndicatorsParam[tendencyIndex,33])
      processedData = TRIX(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,44],optimalizedIndicatorsParam[tendencyIndex,45])
      processedData = ADL(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,37],optimalizedIndicatorsParam[tendencyIndex,38],optimalizedIndicatorsParam[tendencyIndex,39],optimalizedIndicatorsParam[tendencyIndex,40])
      processedData = BBands(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,55])
      processedData = SAR(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,49],optimalizedIndicatorsParam[tendencyIndex,50],optimalizedIndicatorsParam[tendencyIndex,51])
      processedData = AROON(processedData,tendency[tendencyIndex],optimalizedIndicatorsParam[tendencyIndex,21],optimalizedIndicatorsParam[tendencyIndex,22],optimalizedIndicatorsParam[tendencyIndex,23])
    }
    
    processedData = processedData[,c("SignalADX1","SignalForceIndex1","SignalROC1","SignalStochRSI1","SignalTRIX1","SignalADL1","SignalBBands1","SignalSAR1","SignalAROON1",
                                     "SignalADX3","SignalForceIndex3","SignalROC3","SignalStochRSI3","SignalTRIX3","SignalADL3","SignalBBands3","SignalSAR3","SignalAROON3",
                                     "SignalADX7","SignalForceIndex7","SignalROC7","SignalStochRSI7","SignalTRIX7","SignalADL7","SignalBBands7","SignalSAR7","SignalAROON7",
                                     "SignalADX14","SignalForceIndex14","SignalROC14","SignalStochRSI14","SignalTRIX14","SignalADL14","SignalBBands14","SignalSAR14","SignalAROON14",
                                     "SignalADX30","SignalForceIndex30","SignalROC30","SignalStochRSI30","SignalTRIX30","SignalADL30","SignalBBands30","SignalSAR30","SignalAROON30")]
    
    processedData = processedData[nrow(processedData),]
    
    for(tendenciesIndex in 1:length(tendencies)){
      # call Azure Web Service
      source(paste0("azureWebservices/webserviceTen",tendencies[tendenciesIndex],companies[companiesIndex],".R"))
      datesAndRatesForPredicitons[1,paste0(companies[companiesIndex],"ten",tendencies[tendenciesIndex],"Signal")] = Result[1]
      datesAndRatesForPredicitons[1,paste0(companies[companiesIndex],"ten",tendencies[tendenciesIndex],"Accuracy")] = as.numeric(Result[2])
      datesAndRatesForPredicitons[1,paste0("ten",tendencies[tendenciesIndex],"Date")] = as.character(yesterday)
    }
  }
  write.csv(datesAndRatesForPredicitons, file = "data/datesAndRatesForPredicitons.csv",row.names=FALSE)
}

