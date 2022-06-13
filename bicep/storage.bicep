targetScope = 'resourceGroup'

@minLength(3)
@maxLength(24)
@description('Provide a name for the storage account using only lowercase letters and numbers. Must be unique across Azure')
param storageAcctName string 

param containerName string = 'dl-synanalytics-01'

param location string = resourceGroup().location

param tags object

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
@description('Storage Account Type')
param saType string = 'Standard_LRS'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAcctName
  location: location  
  kind: 'StorageV2'
  sku: {
    name:saType
  }
  tags: tags
  properties: {
    accessTier: 'Hot'
    isHnsEnabled: true
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageaccount.name}/default/${containerName}'
}

output storageAccountName string = storageaccount.name
