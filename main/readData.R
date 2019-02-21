# function read the data to environment for shiny

# silentRow data
silentRows = data.frame()
silentRows = read.csv("data/optimalizationTestedData/silentRows.csv")
silentRows$numberOfSilentIndicators = as.character(silentRows$numberOfSilentIndicators)
silentRows$columnIndex = as.character(silentRows$columnIndex)

# best time period for classification Apple data
meanAccuracyAAPL = data.frame()
meanAccuracyAAPL = read.csv("data/optimalizationTestedData/meanAccuracyAAPL.csv")

# best time period for classification Bank of America data
meanAccuracyBAC = data.frame()
meanAccuracyBAC = read.csv("data/optimalizationTestedData/meanAccuracyBAC.csv")

# best time period for classification Intel data
meanAccuracyINTC = data.frame()
meanAccuracyINTC = read.csv("data/optimalizationTestedData/meanAccuracyINTC.csv")

# best algorithms and tendencies for classification Apple data
aAndTAAPL = data.frame()
aAndTAAPL = read.csv("data/optimalizationTestedData/aAndTAAPL.csv")

# best algorithms and tendencies for classification Bank of America data
aAndTBAC = data.frame()
aAndTBAC = read.csv("data/optimalizationTestedData/aAndTBAC.csv")

# best algorithms and tendencies for classification Intel data
aAndTINTC = data.frame()
aAndTINTC = read.csv("data/optimalizationTestedData/aAndTINTC.csv")
