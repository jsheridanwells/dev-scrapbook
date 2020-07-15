# Windows Server 2019: Deploying Containers

[Desde...](https://www.linkedin.com/learning/windows-server-2019-deploying-containers)


## Intro and Terms

### Benefits of containers

 - portable
 - better security (only limited specific communication is allowed between container and host os)
 - consistency in different environments
 - flexible between linux and windows
 - interchangeable
 - scalable
 - stackable

### Benefits of VMs
 - better isolation
 - traditionally-architected applications can run as-is. otherwise, they would need to be containerized
 - more mature ecosystem

### Architecture

A __server__ -> runs an __OS__ -> which runs a __Docker Engine__ -> which runs several __Containers__ -> and a __Docker Client__ |^ communications with the __Docker Engine__

Also, a __laptop/pc__ -> with an __OS__ -> runs a __Docker Client__ -> which communicates with the above __Docker__Engine

### Terms

 - __Image__ : a package of an application(s), executables, runtimes, libraries, configs etc.
 - __Container__ : when the _Image_ is executed, it's a _Container_
 - __Cluster__ : a group of container hosts. (A container host could be an EC2 instance). A cluster could be a Dev cluster, UAT cluster, Prod cluster etc.
 - __Node__ : a host in a _cluster_ is a _node_
 - __Service__ : a single container performing a single function (eg. logging, a cron job)
 - __Stacks__ : groups of related services (eg. app server, database server) that can be replicated and scaled

## Installing Docker EE on Windows Server 2019

__Editions__:
 - Docker Engine
 - Docker Enterprise (EE) - Paid, runs on Linux and Windows, included in Windows Server 2019 license.
 - Docker Desktop (CE) - Free, runs on PCs
 - Docker also supports various related open source projects

### Installation

 - Install updates, then disable auto-updates
```powershell
# if installing on core
# Use SCONFIG, OPTION 6, to install updates

# Then,
Start powershell
Install-Module -Name DockerMsftProvider -Repository PSGallery –Force
Install-Package -Name docker -ProviderName DockerMsftProvider –Force
Restart-Computer -force
Start powershell
Start-Service docker 
```

## Docker config on Windows server

There are two ways to configure docker

## __1.__

Docker server runs as dockerd.exe in `C:\Program Files\docker\`

It can be stopped from __Services__ menu. It can then be re-run in Powershell with options.

## __2.__

Also, there is a hidden directory: `C:\ProgramData\docker\config\`
You can add `daemon.json` with config, and the `docker` command will run with the config

## Controlling containers in Windows

### Docker commands

|Command|Description|
|---|---|
|`docker ps`|list running containers|
|`docker ps --all`|list all containers|
|`docker attach <container name>`|enter a container to run commands|
|`docker exec <CONTAINER NAME> <COMMAND NAME>`|runs the command on the container, then steps out|
|`docker image ls`|list images|
|`docker image rm <NAME>`|remove an image. (also `docker rmi <NAME>`)|
|`docker image save <IMAGE NAME>`|save an image locally as a tarball|
|`docker image import <IMAGE NAME>`|load an image from a tarball|
|`docker image prune`|remove all unused images|
|`docker network ls`|list docker networks|
|`docker volume create <VOLUME NAME>`|creates a local volume on host for persistent storage|
|`docker run -it <TAG> -v <VOLUME NAME>:<DIR ON CONTAINER>`|binds container to volume on host system|

