# Azure Devops : Upload Build to AWS S3 Bucket

## Setting up an AWS S3 bucket to hold build artifacts from Azure Dev Ops

1. Create the bucket. It does not need any policies or special permissions yet.
1. Create a policy for remotely adding objects to bucket, attached to AzureDevOps Group and/or user:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowRemoteAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Sid": "AllowArtifactUploadToBucket",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::MY-LOVELY-BUCKET",
                "arn:aws:s3:::MY-LOVELY-BUCKET"
            ]
        }
    ]
}
```

Create a special user with this policy attached and AWS cli access.

## Set up an Az Dev Ops Release task:

Make sure [AWS Tools for VSTS](https://aws.amazon.com/vsts/) are on your TFS server or Azure DevOps instance.

1. In project settings, add AWS services with your account or master account for project.
1. Add artifact trigger from build pipeline (_MY ARTIFACT)
1. Add Stage 1 Agent Job w/ this config:
```yaml
steps:
- task: AmazonWebServices.aws-vsts-tools.S3Upload.S3Upload@1
  displayName: 'S3 Upload: my-artifacts'
  inputs:
    awsCredentials: MY-AWS-DEVOPS_USER
    regionName: 'us-east-2'
    bucketName: 'MY-LOVELY-BUCKET'
    sourceFolder: '$(System.DefaultWorkingDirectory)/_MyAzDevOpsApp/MY_ARTIFACT'
    targetFolder: MY-S3-FOLDER
```
