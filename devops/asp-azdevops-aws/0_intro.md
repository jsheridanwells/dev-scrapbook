# Asp.Net Core to Azure DevOps to AWS Pipline

## Intro

The recipes in this folder fit a particular use case: commiting code to an Asp.NetCore project in TFS (using Azure Dev Ops here), 
which creates a build, which sends the artifacts to an AWS S3 bucket, which then deploys it using CodeDeploy to an EC2 instance.

__Contents:__

1. [Setting up an Asp.Net Core WebApi and Tests]()
1. [Prepping an EC2 instance to run Apache]()
1. [Creating a release for Linux]()
1. [Building the artifacts in Azure DevOps]()
1. [Sending the artifacts to an AWS S3 bucket]()
1. [Using CodeDeploy to stage artifacts from S3 to the EC2 instance]()

