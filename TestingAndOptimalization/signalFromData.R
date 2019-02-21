# Sourcing
source("indicators/StochRSI.R")
source("indicators/TRIX.R")
source("indicators/ADL.R")
source("indicators/ROC.R")
source("indicators/BBands.R")
source("indicators/SAR.R")
source("indicators/ADX.R")
source("indicators/ForceIndex.R")
source("indicators/AROON.R")

# Script preprocess raw stock data, call function for optimizing indicator parameters
# and create and save signals from optimized indicators to csv file

###########
# Read data
###########
stockList = c("AAPL","BAC","INTC")

dataset1 = read.csv(paste0("data/RawStockData/",stockList[1],"_daily_10Y.csv"))
dataset1 = read.csv(paste0("data/RawStockData/",stockList[1],"_daily_5Y.csv"))
dataset1 = read.csv(paste0("data/RawStockData/",stockList[1],"_daily_4Y.csv"))
dataset1 = read.csv(paste0("data/RawStockData/",stockList[1],"_daily_3Y.csv"))
dataset1 = read.csv(paste0("data/RawStockData/",stockList[1],"_daily_2Y.csv"))
dataset1 = read.csv(paste0("data/RawStockData/",stockList[1],"_daily_1Y.csv"))

####################
# Preprocessing Data
####################
source("preprocessData.R")
dataset1 = PreprocessData(dataset1)

############################################################
# Test and optimize each indicator strategy for current data
############################################################
# source("optimalization/findOptimalSettings.R")

##############################
# Calling inidicator functions
##############################
tendency = c(1,3,7,14,30)

for(tendencyIndex in 1:length(tendency)){
  dataset1 = ADX(dataset1,tendency[tendencyIndex],validatedDFADX[tendencyIndex,4],validatedDFADX[tendencyIndex,5])
  dataset1 = ForceIndex(dataset1,tendency[tendencyIndex],validatedDFForceIndex[tendencyIndex,4],validatedDFForceIndex[tendencyIndex,5])
  dataset1 = ROC(dataset1,tendency[tendencyIndex],validatedDFROC[tendencyIndex,4],validatedDFROC[tendencyIndex,5],validatedDFROC[tendencyIndex,6],validatedDFROC[tendencyIndex,7])
  dataset1 = StochRSI(dataset1,tendency[tendencyIndex],validatedDFStochRSI[tendencyIndex,4],validatedDFStochRSI[tendencyIndex,5],validatedDFStochRSI[tendencyIndex,6],validatedDFStochRSI[tendencyIndex,7],validatedDFStochRSI[tendencyIndex,8],validatedDFStochRSI[tendencyIndex,9],validatedDFStochRSI[tendencyIndex,10])
  dataset1 = TRIX(dataset1,tendency[tendencyIndex],validatedDFTRIX[tendencyIndex,4],validatedDFTRIX[tendencyIndex,5])
  dataset1 = ADL(dataset1,tendency[tendencyIndex],validatedDFADL[tendencyIndex,4],validatedDFADL[tendencyIndex,5],validatedDFADL[tendencyIndex,6],validatedDFADL[tendencyIndex,7])
  dataset1 = BBands(dataset1,tendency[tendencyIndex],validatedDFBBands[tendencyIndex,4])
  dataset1 = SAR(dataset1,tendency[tendencyIndex],validatedDFSAR[tendencyIndex,4],validatedDFSAR[tendencyIndex,5],validatedDFSAR[tendencyIndex,6])
  dataset1 = AROON(dataset1,tendency[tendencyIndex],validatedDFAROON[tendencyIndex,4],validatedDFAROON[tendencyIndex,5],validatedDFAROON[tendencyIndex,6])
}

dataset1 = dataset1[,c("SignalADX1","SignalForceIndex1","SignalROC1","SignalStochRSI1","SignalTRIX1","SignalADL1","SignalBBands1","SignalSAR1","SignalAROON1","Tendency+1",
                       "SignalADX3","SignalForceIndex3","SignalROC3","SignalStochRSI3","SignalTRIX3","SignalADL3","SignalBBands3","SignalSAR3","SignalAROON3","Tendency+3",
                       "SignalADX7","SignalForceIndex7","SignalROC7","SignalStochRSI7","SignalTRIX7","SignalADL7","SignalBBands7","SignalSAR7","SignalAROON7","Tendency+7",
                       "SignalADX14","SignalForceIndex14","SignalROC14","SignalStochRSI14","SignalTRIX14","SignalADL14","SignalBBands14","SignalSAR14","SignalAROON14","Tendency+14",
                       "SignalADX30","SignalForceIndex30","SignalROC30","SignalStochRSI30","SignalTRIX30","SignalADL30","SignalBBands30","SignalSAR30","SignalAROON30","Tendency+30")]

dataset = read.csv(paste0("data/SignalsForClassification5YO/signalsAPPL5Y.csv"))
