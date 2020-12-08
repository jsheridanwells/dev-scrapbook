# Basic Serverless Azure Functions + API Manager + Client in Blob Storage Setup

_(Note, the security is MINIMAL in this setup - just for POC. Not for any sort of production scenario whatsoever)_

## Database

 - Create and migrate SQL database(s). You can create a SQL Server and Resource Group in this step as well
 - Set the DB/DBServer Firewall to accept connections from other Azure services.
 - Copy and save the connection string.

## Function App
 - Publish function app from VS (So far, Windows runtime was the only one that worked, not Linux)
 - Add DB connection strings(s) in Configuration
 - Test function vs. database

## API Manager
 - Under APIs, add the function app

## Client
 - Set up storage account as General Purpose V2
 - Look for - Storage Explorer -> BLOB CONTAINER -> ?$web
 - Artifacts can be manually uploaded from here.