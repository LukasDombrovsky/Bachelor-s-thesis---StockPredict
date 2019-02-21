# Azure Webservice Ten30AAPL

library("RCurl")
library("rjson")

# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

h = basicTextGatherer()
hdr = basicHeaderGatherer()


req = list(
  
  Inputs = list(
    
    
    "input1" = list(
      "ColumnNames" = list("SignalADX30", "SignalForceIndex30", "SignalROC30", "SignalStochRSI30", "SignalTRIX30", "SignalADL30", "SignalBBands30", "SignalSAR30", "SignalAROON30"),
      "Values" = list( list( processedData[1,37], processedData[1,38], processedData[1,39], processedData[1,40], processedData[1,41], processedData[1,42], processedData[1,43], processedData[1,44], processedData[1,45] ))
    )                ),
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)

body = enc2utf8(toJSON(req))
api_key = "UiTJul4AsINtHz7xdN2JrrOXwHxawxBQ0PBZNagWStWKh7dlxrssY5yOv3GcDyKOlyjj1uLjcGfmgxupBivGFA==" # Replace this with the API key for the web service
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()
curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/b3777079b3424ee2bed9f97ca8c13c5b/services/c921853bece841b69a20afcfd69923ef/execute?api-version=2.0&details=true",
            httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
            postfields=body,
            writefunction = h$update,
            headerfunction = hdr$update,
            verbose = TRUE
)

headers = hdr$value()
httpStatus = headers["status"]
if (httpStatus >= 400)
{
  print(paste("The request failed with status code:", httpStatus, sep=" "))
  
  # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
  print(headers)
}

result = h$value()
result = print(fromJSON(result))

Result <- result$Results$output1$value$Values[[1]][10:11]
