# RBAC Deployment Via Bicep Templates
This repo contains 2 bicep templates 
## bicep\00_main.bicep 
Creates a resource group and storage account in your subscription.
## bicep\01_main.bicep 
Applies RBAC to the newly created storage account 

What's neat about this method is the variables in bicep\01_main.bicep: RBACRoleIds, principalIds, & storageAccountRBACRoles
These allow you to define roles in one place and have they dynamically applied utilizing for loops in bicep\roleAssignmentsStorage.bicep

# Requirements
az cli installed

bicep installed

# Procedure
1) Login: az login
2) Ensure you are using the correct subscription: az account set --subscription <subscription_name or GUID> (az account set --subscription 33020c4d-8650-4d9c-8a6f-48423915bf63)
3) Confirm correct subscription:az account show
4) Set GUIDs associated with your AD groups in the variable **principalIds** in bicep\01_main.bicep
5) Assign your storage account RBAC assignments in variable **storageAccountRBACRoles** in bicep\01_main.bicep
6) Modify any parameters in bicep\deployment.ps1 or the bicep templates
7) Run bicep\deployment.ps1