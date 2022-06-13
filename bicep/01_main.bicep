// Prerequisites: 
//  - Subscription Exists
//  - Principle deploying has owner role at sub level

// Set Scope
targetScope='subscription'

// Define Parameters
param storageAcctName string 

param rgName string 

// Define Variables
// These are the hard coded GUIDs assocated with roles and are provided here as a convieneince
// Find the available built in roleDefinitionResourceIds here: 
// https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#all
var RBACRoleIds = {
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  userAccessAdministrator: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  saReaderAndDataAccess: 'c12c1c16-33a1-487b-954d-41c89c60f349'
  saContributor: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
  saBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  saBlobDataOwner: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
  saBlobDataReader: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  SQLDBContributor: '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  SQLServerContributor: '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437'
  kvAdministrator: '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  kvContributor: 'f25e0fa2-a7c8-4377-a976-54943a77a395'
  kvReader: '21090545-7ca7-4776-b22c-e363652d74d2'
  kvSecretsOfficer: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  kvSecretsUser: '4633458b-17de-408a-b874-0445c86b69e6'
  kvCryptoUser: '12338af0-0e69-4776-bea7-57ae8d297424'
  kvCryptoServiceEncryptionUser: 'e147488a-f6f5-4113-8e2d-b22465e65bf6'
}
var principalIds = { //TODO:
  AllStaff: 'e9b5ab94-c0c8-4c92-99e6-31d35d951bf8'
  AzureReaders: '9634687c-e6d7-4e13-ba2d-a754580024a1'
  Admin: 'd6c44347-04ec-4878-a943-23ec6d083370'
  DataEngineer: ''
  DataScientist: ''
  me: '815b3665-a5a6-4e13-9963-f9d52b2b210d'
  // MI_StorageAccount: storageAccountSystemManagedIdentity
}
// Add or remove elements of this array to grant permissions to specific roles
var storageAccountRBACRoles = [ 
    {
      principalId: principalIds.AzureReaders
      RBACRoleID: RBACRoleIds.reader
    }
    {
      principalId: principalIds.AllStaff
      RBACRoleID: RBACRoleIds.saBlobDataReader
    }
    {
      principalId: principalIds.Admin
      RBACRoleID: RBACRoleIds.owner
    }
    {
      principalId: principalIds.me
      RBACRoleID: RBACRoleIds.owner
    }
]

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: rgName
}

resource storageAcct 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: storageAcctName
  scope: rg
}

// RBAC Role Assignments
module raStorageAcctModule 'roleAssignmentsStorageAcct.bicep' = {
  name: 'raStorageAcctModule'
  scope: rg
  params: {
    storageAcctName: storageAcctName
    RBACRoles: storageAccountRBACRoles
  }
}
