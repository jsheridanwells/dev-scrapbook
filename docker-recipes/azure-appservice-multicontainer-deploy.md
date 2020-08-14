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

5. Delete group to remove everyrthing:
```bash
$ az group delete --name myResourceGroup
```