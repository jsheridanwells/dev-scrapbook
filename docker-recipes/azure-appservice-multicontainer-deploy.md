# Multi-Container Deployment on Azure App Service

[Mostly from here...](https://docs.microsoft.com/en-us/azure/app-service/quickstart-multi-container)

1. Create resource group if it's not there:
```bash
$ az group create --name myResourceGroup --location "eastus"
```

2. Create App Service plan:
```bash
$ az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku S1 --is-linux
```

3. Create a web app that draws from local `docker-compose.yml`:
```bash
$ az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name <app_name> --multicontainer-config-type compose --multicontainer-config-file compose-wordpress.yml
```

4. Output will include domain -- navigate there in browser to confirm it's running

5. Delete group to remove everything:
```bash
$ az group delete --name myResourceGroup
```


## Migrating w/ custom containers


[Mostly from here...](https://docs.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux)


 - Create a resource group (if it doesn't exist)
```bash
$ az group create --name AppSvc-DockerTutorial-rg --location westus2
```

 - Push the image
 - - Create container registry
```bash
$ az acr create --name <registry-name> --resource-group AppSvc-DockerTutorial-rg --sku Basic --admin-enabled true
```

 - - Retrieve registry credentials and pass to local Docker
```bash
$ az acr credential show --resource-group AppSvc-DockerTutorial-rg --name <registry-name>
$ docker login <registry-name>.azurecr.io --username <registry-username>
```

 - - Tag local image for registry
```bash
$ docker tag appsvc-tutorial-custom-image <registry-name>.azurecr.io/appsvc-tutorial-custom-image:latest
```

 - - Push the image
```bash
$ docker push <registry-name>.azurecr.io/appsvc-tutorial-custom-image:latest
```

 - - Verify the push
```bash
$ az acr repository list -n <registry-name>
```

 - Create app service (if it doesn't exist)
```bash
$ az appservice plan create --name AppSvc-DockerTutorial-plan --resource-group AppSvc-DockerTutorial-rg --is-linux
```

 - Create the web app if it hasn't been created
 ```bash
 $ az webapp create --resource-group AppSvc-DockerTutorial-rg --plan AppSvc-DockerTutorial-plan --name <app-name> --deployment-container-image-name <registry-name>.azurecr.io/appsvc-tutorial-custom-image:latest
 ```

 - Use this command to add any environment settings
```bash
$ az webapp config appsettings set --resource-group AppSvc-DockerTutorial-rg --name <app-name> --settings WEBSITES_PORT=8000
```

 - Enable managed identity. The `.tsv` output will be used in a later step
```bash
$ az webapp identity assign --resource-group AppSvc-DockerTutorial-rg --name <app-name> --query principalId --output tsv
```

 - Retrieve subscription id
 ```bash
$ az account show --query id --output tsv
 ```

 - Give permission to the app to access the container registry
```bash
$ az role assignment create --assignee <principal-id> --scope /subscriptions/<subscription-id>/resourceGroups/AppSvc-DockerTutorial-rg/providers/Microsoft.ContainerRegistry/registries/<registry-name> --role "AcrPull"
```

Replace the following values:

`<principal-id>` with the service principal ID from the az webapp identity assign command

`<registry-name>` with the name of your container registry

`<subscription-id>` with the subscription ID retrieved from the az account show command

 - Add container location to the web app config
 ```bash
$ az webapp config container set --name <app-name> --resource-group AppSvc-DockerTutorial-rg --docker-custom-image-name <registry-name>.azurecr.io/appsvc-tutorial-custom-image:latest --docker-registry-server-url https://<registry-name>.azurecr.io
 ```

To update, rebuild, retag, and push image, then
```bash
$ az webapp restart --name <app_name> --resource-group AppSvc-DockerTutorial-rg
```
