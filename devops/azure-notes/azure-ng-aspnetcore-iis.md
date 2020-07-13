# Angular + .NET Core + SQL on Azure

[from here](https://jasonwatmore.com/post/2020/01/08/angular-net-core-sql-on-azure-how-to-deploy-a-full-stack-app-to-microsoft-azure)

## Create a new Windows Server on Microsoft Azure

In Azure
 - Create new VM
 - new resource group
 - new vm name
 - image: Windows 2019 DataCenter
 - size: I used smallest available
 - Username password - whatever i want
 - Public ports: Allowed Http :80 and RDP :3389


## Connect to Azure Windows Server instance via RDP

In VM Overview page:
 - click Connect
 - click download RDP
 - open and connect with username from previous step


## Setup web server with IIS (Internet Information Services)

 - In IIS Server Manager, click __Add roles and features__
 - Installation type: __Role-Based...__
 - Server selection : default
 - Server Roles: Check box for __WebServer IIS__
 - Features: default
 - Web Server Role (IIS): default
 - Role services: default
 - Confirmation: click install

 - Download .net core installer: https://www.microsoft.com/net/permalink/dotnetcore-current-windows-runtime-bundle-installer. (Change IE security settings [to allow downloads](https://answers.microsoft.com/en-us/ie/forum/all/your-current-security-settings-do-not-allow-this/c9d76601-77ac-4716-b264-a03dcfb9b426))

 - Restart IIS : `net stop was /y && net start w3svc`

 - Install IIS URL Rewrite module: https://www.iis.net/downloads/microsoft/url-rewrite.

## Create Azure SQL Database

 - In SQL Databases section, click __new__ or __create__
 - Resource Group: same as VM
 - Database Name: whatever i want
 - Server -> __Create New__
   - Server Name: whatever
   - Server admin login - also whatever
   - Location: same as VM
 - Computer & STorage: Basic
 - Networking -> 
   - Connectivity Method: __public endpoint__
   - Allow Azure Services:... Yes
 - Review and Create

## Build and Deploy ASP.NET Core Back-end API

 _TODO : figure out how to use user-secrets in Windows Server, or w/ key vaults_
 - Update db connection string (trying in appsettings.prod)
 - publish: `$ dotnet publish --configuration Release`
 - Copy `./bin/Release/netcoreaspp3.1/publish/` to server (this one was in `c:\Project\back-end`)


## Build and Deploy Angular Front-end app
## Configure IIS to serve API and front-end
## Test the Angular + ASP.NET Core + SQL Server app in a browser