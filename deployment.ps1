# Deploy the 00_main.bicep template
$iteration='01'
$location = 'southcentralus'
$outputs = az deployment sub create --location $location --template-file .\bicep\00_main.bicep --parameters iteration=$iteration  --query properties.outputs
# Capture needed outputs
$outputsJSON = $outputs | ConvertFrom-Json
$storageAccountName = $outputsJSON.storageAccountName.value
$rgName = $outputsJSON.rgName.value

# Deploy the 01_main.bicep template with the outputs from the previous template (the storage account name and resource group name) to create RBAC permissions
az deployment sub create --location $location --template-file .\bicep\01_main.bicep --parameters storageAcctName=$storageAccountName rgName=$rgName 

