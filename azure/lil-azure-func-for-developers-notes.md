# Azure Functions For Developers Notes

Evolution of cloud services: `On-Prem -> Iaas -> PaaS -> Serverless : ` All provisioning is done by cloud provider and client is only responsible for code that runs.

__Benefits__: Simple, flexible programming model. Less code. Less cost - only charges for execution, not for resources.

__Hosting Plans__: Consumption plan is default. Pay only for computing and scales automatically, but has cold starts which could impact performance in latency-critical applications. Premium plan is perpetually warm, with unlimited exec duration. Dedicated (App Service) plan uses dedicated plans and it's not really serverless.

__Anatomy:__
 - Code + Config 
 - Runtime
 - WebJobs Script Runtime
 - WebJobs Core
 - WebJobs Extensions
 - App Service Dynamic Runtime

__AzFunc apps use the following core files:__
 - `host.json` - global config
 - `function.json` - metadata for a particular function (triggers, bindings, etc.)
 - `local.settings.json` - local config. Don't check it into .git and AzFunc deployments will ignore this. Env vars and secrets can be put in here.

__Function App Anatomy:__
FunctionApp
 - host.json
 - Func1 - function.json
 - Func2 - function.json
 - SharedCode
 - bin

## Creating a Function App via CLI

```powershell
> $rg = 'myresourcegroup'
> $l = 'southcentralus' # or wherever you want the rg location to be
> $s = 'mystorageaccountname'

> az group create --name $rg --location $l
> az storage account create --name $s --location $l -g $rg --sku Standard_LR
> az functionapp create MyFunctionAppName --storage-account $s --consumption-plan-location $l --resource-group $rg --function-version 3
```

## ARM Templates

A deployment can be created with an ARM template like so:
```powershell
> az deployment group create -g $rg --template-file .\template.json --parameters \.parameters.json
> # wait...
```


## Coding the function

Using the CLI:
```bash
$ mkdir MyFuncApp && cd $_
$ func init
```
Choose runtime and it will scaffold a project (dotnet, Java, TS, JS, Python, etc.)

```bash
$ func new
```
...will scaffold a new function with options

Using VS Code:

Azure Functions is really really helpful for creating and debugging AzFunc projects.

Using Visual Studio:

Provides an Azure Functions template. Select runtime and triggers. You may have to update the version in the `.csproj` file to the latest.

## Triggers

 - Specify how a function is invoked.
 - Each function has only one trigger
 - Has associated data

## Bindings
 - Connect data to and from a function
 - E.g., storage binding, CosmosDB bindings let functions connect to other services without needing to specify how.

## Dependency Injection
 - - A class that inherits from `FunctionStartup` can implement DI
 ```csharp
public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddSingleton<IAnalyzerService, ComputerVisionAnalyzerService>();
        }
    }

 ```
- - After removing static properties of function classes (new feature), the classes can use constructors for DI.

## Deploying

__(Quick and dirty .zip)__

```powershell
> dotnet publish -c Release
## go to published dir
> Compress-Archive * MyArtifact.zip
> az functionapp deployment source config-zip -g MyResourceGroup --name MyApp --src MyArtifact.zip
```

Application settings can be saved in the Azure Portal > Function > Configuration

__From Visual Studio__

Publish command gives all options when connected to Azure account. 

VS will manage configuration automatically

__CI/CD__

In Azure DevOps, you can create a pipeline.

## Durable functions

 - Orchestrators run with `IDurableOrchestrationContext`. 
 - Child functions are triggered with an `ActivityTrigger` object which comes from orchestrator.
 - Requests to the orchestrator return `202 ACCEPTED` result, usually with status of child functions.
 - All state is managed by the orchestrator.

## App Secrets

 - Provision a KeyVault in Azure
 - Create an identity for the function
 - Create a KV policy to allow function to access secrets
 - In KV Secrets, create a secret (Name and value) and add the value. KV will then only show the name and the version history. the value is one-way encrypted.
 - Then in config settings, paste the KV secret identifier

## Proxies
 - a `proxies.json` file in the project can define routes, then forward them to a backend uri (the actual function uri).
 - In portal,. under Functions blade, open __Proxies__. The proxies will be visible when deployed. 
 - The functions can then be access with the new routes.