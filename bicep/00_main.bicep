// Set Scope
targetScope='subscription'


// Define Parameters
param location string = 'southcentralus'

@allowed([
  'dev'
  'test'
  'prod'
])
@description('Are we deploying to dev / test / prod?')
param environmentType string = 'dev'

param iteration string

// Define Variables
var workloadName = 'webinar'

var generalTags = {
  Environment: environmentType
  Owner: 'TODO: owner email'
  Stakeholders: 'TODO: list of stakeholder emails'
  WorkloadName: workloadName
  Criticality: 'TODO: Define these in documentation and update here'
  CostCenter: 'TODO: Define these in documentation and update here'
}

var rgTags = {
  BusinessUnit: 'BI'
}

var storageAccountContainersDatabasesTags = {
  DataClassification: 'General'
}

var rgName = 'rg-${workloadName}-${environmentType}-${location}-${iteration}'
// Has to be globally unique
var storageAcctName = substring('stsynapsedl${uniqueString(guid(subscription().id, iteration))}', 0, 24)

// Create RG
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: union(generalTags, rgTags)
}

// Create Azure Storage Account
module storageAcct 'storage.bicep' = {
  name: 'storageModule'
  scope: rg
  params: {
    saType: environmentType == 'prod' ? 'Standard_ZRS' : 'Standard_LRS'
    location: rg.location
    storageAcctName: storageAcctName
    tags: union(generalTags, storageAccountContainersDatabasesTags)
  }
}

output storageAccountName string = storageAcct.outputs.storageAccountName
output rgName string = rg.name
