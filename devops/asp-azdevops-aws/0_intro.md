# Asp.Net Core to Azure DevOps to AWS Pipline

## Intro

The recipes in this folder fit a particular use case: commiting code to an Asp.NetCore project in TFS (using Azure Dev Ops here), 
which creates a build, which sends the artifacts to an AWS S3 bucket, which then deploys it using CodeDeploy to an EC2 instance. The EC2 instance runs Amazon Linux (CentOS) and Apache.

__Contents:__


1. [Prepping an EC2 instance to run Apache](ec2-running-apache.md)
1. [Building the artifacts in Azure DevOps](./2_build-artifacts-in-AzDevOps.md)
1. [Sending the artifacts to an AWS S3 bucket](./3_send-to-AWS-S3-bucket.md)
1. [Using CodeDeploy to stage artifacts from S3 to the EC2 instance](/4_stage_Artifacts_w_code_deploy.md)

Also, to get started install [AWS Tools for VSTS](https://aws.amazon.com/vsts/) on your TFS server or Azure DevOps instance.
