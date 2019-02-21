# Azure Webservice Ten3INTC

library("RCurl")
library("rjson")

# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

h = basicTextGatherer()
hdr = basicHeaderGatherer()


req = list(
  
  Inputs = list(
    
    
    "input1" = list(
      "ColumnNames" = list("SignalADX3", "SignalForceIndex3", "SignalROC3", "SignalStochRSI3", "SignalTRIX3", "SignalADL3", "SignalBBands3", "SignalSAR3", "SignalAROON3"),
      "Values" = list( list( processedData[1,10], processedData[1,11], processedData[1,12], processedData[1,13], processedData[1,14], processedData[1,15], processedData[1,16], processedData[1,17], processedData[1,18] ))
    )                ),
  GlobalParameters = setNames(fromJSON('{}'), character(0))
)

body = enc2utf8(toJSON(req))
api_key = "/98Njty7D3DW0hBSr7nry1roWDw6zcwL8KbGQyT0o8zc3sI+uqAfhxcEE2CHJFhElpUjsu5A3WYp404o/GVK6g==" # Replace this with the API key for the web service
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()
curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/b3777079b3424ee2bed9f97ca8c13c5b/services/97ed50713d8443acb723b0f5f1abfe9c/execute?api-version=2.0&details=true",
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
