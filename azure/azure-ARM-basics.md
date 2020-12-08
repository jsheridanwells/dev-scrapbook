# Basics of working with Azure ARM templates

[Desde...](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-create-first-template?tabs=azure-powershell)

## Templates

All templates start with three properties:

 - `$schema` - This is the schema version from Azure as a URL
 - `contentVersion` - This is your own versioning tag
 - `resources` - This is an array of whatever it is you're provisioning

Basic Template:
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": []
}
```

## Basic Commands
To start:
```powershell
Connect-AzAccount # to log in
Set-AzContext # specify subscription name or id if account has multiple subscriptions

New-AzResourceGroup -Name <MY RESOURCE GROUP> # create a resource group 

# deploy
$templateFile = "{provide-the-path-to-the-template-file}"
New-AzResourceGroupDeployment `
  -Name <MY DEPLOYMENT NAME>`
  -ResourceGroupName <MY RESOURCE GROUP> `
  -TemplateFile $templateFile
```

## Resources

Resources are objects in `resources` array with at least these properties:

 - `type` - Type of resource as namespace + resource type (`Microsoft.Storage/storageAccounts`)
 - `apiVersion` - Each resource has it's own API versions
 - `name` - This is where you name the resource

A resource looks like:
```json
{
    "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2019-04-01",
      "name": "<MY STORAGE ACCOUNT NAME>",
      "location": "eastus",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "StorageV2",
      "properties": {
        "supportsHttpsTrafficOnly": true
      }
    }
  ]
}
```

## Parameters

Parameters can be added at the top level:
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageName": {    // <----- HERE!
      "type": "string",
      "minLength": 3,
      "maxLength": 24
    }
  },
  // ...
```

Then used with the `parameters` function:
```json
"resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2019-04-01",
      "name": "[parameters('storageName')]", // <-----HERE! 
      "location": "eastus",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "StorageV2",
      "properties": {
        "supportsHttpsTrafficOnly": true
      }
    }
  ]
```

In the deployment, you can add the value that gets passed in through the parameters.
```powershell
New-AzResourceGroupDeployment `
  -Name addskuparameter `
  -ResourceGroupName myResourceGroup `
  -TemplateFile $templateFile `
  -storageName "{your-unique-name}"
```
If `storageName` isn't entered, then the command will prompt you or use a default if specified



## Functions

There are built-in functions that can also be used to extract values (`parameters` is one of them)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // ...
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"  // <--- the function
    }
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2019-04-01",
      "location": "[parameters('location')]",      // <-- used here
      "kind": "StorageV2",
      "properties": {
        "supportsHttpsTrafficOnly": true
      }
    }
  ]
}

```
[These are all of the functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions)

## Variables

Variables can hold values to be used for several resources:
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storagePrefix": {  // <-- we'll use this
      "type": "string",
      "minLength": 3,
      "maxLength": 11
    },    
  },
  "variables": {
    "uniqueStorageName": "[concat(parameters('storagePrefix'), uniqueString(resourceGroup().id))]" // <-- create a unique name here
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2019-04-01",
      "name": "[variables('uniqueStorageName')]",  // <--- use the unique name with the variables function
      "location": "[parameters('location')]",
        // ... 
    }
  ]
}
```

## Outputs

Every resource created becomes an object with properties. The resource can be accessed with the `reference` function by passing the name of the resource. The properties of the object can then be output back to the console.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storagePrefix": {
      "type": "string",
      "minLength": 3,
      "maxLength": 11
    // ...
  "variables": {
    "uniqueStorageName": "[concat(parameters('storagePrefix'), uniqueString(resourceGroup().id))]" // <--- we'll use the unique storage name ...
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2019-04-01",
      "name": "[variables('uniqueStorageName')]",
      // ...
    }
  ],
  "outputs": {
    "storageEndpoint": { // <--- ...to create a storage endpoint object to output to the console
      "type": "object",
      "value": "[reference(variables('uniqueStorageName')).primaryEndpoints]" // <-- that is populated from the resource created, accessed with the unique name
    }
  }
}

```
