param RBACRoles array 

param storageAcctName string


// Define the resources/scopes we are going to apply roles to
resource sa 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: storageAcctName
}

resource rd 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = [for Role in RBACRoles: {
  name: Role.RBACRoleID
}]

// rg resource assignments:
resource ra 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = [for (Role, i) in RBACRoles: {
  name: guid(resourceGroup().id, Role.principalId, rd[i].id)
  // This is the scope of the role assignment
  scope: sa
  properties: {
    principalId: Role.principalId
    roleDefinitionId: rd[i].id
  }
}]


// resource raStorageAccoutBlobDataContributor 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
//   name: guid(subscription().id, principalIds.DataEngineer, RBACRoles.saBlobDataContributor)
//   scope: sa
//   properties: {
//     principalId: principalIds.DataEngineer
//     roleDefinitionId: RBACRoles.saBlobDataContributor
//   }
// }
