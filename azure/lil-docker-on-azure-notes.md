# Docker on Azure Notes

[desde...](https://www.linkedin.com/learning/docker-on-azure/from-virtual-machines-to-containers?collection=urn%3Ali%3AlearningCollection%3A6445383652925853696&u=78655346)


## Creating a container registry

 - __Registry Name__ : (must be unique)
 - Define resource group and other params

Log in to registry via Azure CLI:
```bash
$ az acr login --name <REGISTRY NAME>
```

Add local image to registry. (From same directory as DockerFile):
```bash
$ docker build . -t <RESISTRYNAME>.azurecr.io/<IMAGE-NAME>:latest
$ docker push <RESISTRYNAME>.azurecr.io/<IMAGE-NAME>:latest
```

Now image can be pulled and run from registry location:
```bash
$ docker run --rm --name <IMAGE_NAME> -d -p 8080:80 <REGISTRYNAME>.azurecr.io/<IMAGE_NAME>:latest
```

## Connect Azure Repos

 - Create or update AzDevOps repo however way you want.
 - in Pipelines, build a pileline using the Docker Container template
 - once set up, this will push image to container registery as part of CI/CD process

## Azure Cloud Deployment Models

Docker on VMs vs. Azure Container Instances (ACIs)

VMs: Billed as VM costs, VMs managed by Azure user, standard Docker management process

ACIs: CPU-based billing, template and pipelin integration, more direct integration w/ Azure DevOps processes

