# Sending an AzDevOps artifact to an AWS S3 bucket

The following config specifies AWS S3 bucket to send build artifacts. This can store versions of releases in case a rollback is needed. Note, MY_ARTIFACT_NAME in `sourceFolder` matches artifact name in pipeline artifact step:
```yaml
steps:
- task: AmazonWebServices.aws-vsts-tools.S3Upload.S3Upload@1
  displayName: 'upload artifact to S3'
  inputs:
    awsCredentials: 'MY_AWS_DEV_OPS_USER'
    regionName: 'us-east-2'
    bucketName: 'MY_S3_BUCKET'
    sourceFolder: '$(System.DefaultWorkingDirectory)/Build Artifact/MY_ARTIFACT_NAME_$(Build.BuildNumber)'
    globExpressions: '**/*.zip'
    targetFolder: MY_S3_FOLDER