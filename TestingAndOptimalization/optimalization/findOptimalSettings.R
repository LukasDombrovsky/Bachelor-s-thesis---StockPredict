# Indicators source files
source("indicators/StochRSI.R")
source("indicators/TRIX.R")
source("indicators/ADL.R")
source("indicators/ROC.R")
source("indicators/BBands.R")
source("indicators/SAR.R")
source("indicators/ADX.R")
source("indicators/ForceIndex.R")

# Script is for validating and optimalization of parameters for every indicator
data = dataset1

###############################
# ADX testing & validating
###############################
validatedDFADX = data.frame()
source("optimalization/testAndValidateADX.R")
validatedDFADX = testAndValidateADX()

###############################
# ForceIndex testing & validating
###############################
validatedDFForceIndex = data.frame()
source("optimalization/testAndValidateForceIndex.R")
validatedDFForceIndex = testAndValidateForceIndex()

###############################
# ROC testing & validating
###############################
validatedDFROC = data.frame()
source("optimalization/testAndValidateROC.R")
validatedDFROC = testAndValidateROC()

###############################
# AROON testing & validating
###############################
validatedDFAROON = data.frame()
source("optimalization/testAndValidateAROON.R")
validatedDFAROON = testAndValidateAROON()

###############################
# StochRSI testing & validating
###############################
validatedDFStochRSI = data.frame()
source("optimalization/testAndValidateStochRSI.R")
validatedDFStochRSI = testAndValidateStochRSI()

##########################
# ADL testing & validating
##########################
validatedDFADL = data.frame()
source("optimalization/testAndValidateADL.R")
validatedDFADL = testAndValidateADL()

###############################
# TRIX testing & validating
###############################
validatedDFTRIX = data.frame()
source("optimalization/testAndValidateTRIX.R")
validatedDFTRIX = testAndValidateTRIX()

###############################
# SAR testing & validating
###############################
validatedDFSAR = data.frame()
source("optimalization/testAndValidateSAR.R")
validatedDFSAR = testAndValidateSAR()

###############################
# BBands testing & validating
###############################
validatedDFBBands = data.frame()
source("optimalization/testAndValidateBBands.R")
validatedDFBBands = testAndValidateBBands()

# Optimalized parameters for stocks
optimalizedIndicatorsParam = list(ADX = validatedDFADX,ForceIndex = validatedDFForceIndex,ROC = validatedDFROC,AROON = validatedDFAROON,StochRSI = validatedDFStochRSI,ADL = validatedDFADL,TRIX = validatedDFTRIX,SAR = validatedDFSAR,BBands = validatedDFBBands)

write.csv(optimalizedIndicatorsParam, file = "data/backupOptimizedParameters/backupSignals.csv",row.names=FALSE)