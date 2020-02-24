# Stage Artifacts on EC2 Instance with CodeDeploy

(_source:_ [mostly these AWS docs](https://docs.aws.amazon.com/codedeploy/latest/userguide/tutorials-windows.html))

I. Permissions setup

A. Create a new IAM user responsible for CodeDeploy from S3 to EC2 instances. Give it these permissions:
```json
{
  "Version": "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "autoscaling:*",
        "codedeploy:*",
        "ec2:*",
        "iam:AddRoleToInstanceProfile",
        "iam:CreateInstanceProfile",
        "iam:CreateRole",
        "iam:DeleteInstanceProfile",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:GetInstanceProfile",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListInstanceProfilesForRole",
        "iam:ListRolePolicies",
        "iam:ListRoles",
        "iam:PassRole",
        "iam:PutRolePolicy",
        "iam:RemoveRoleFromInstanceProfile", 
        "s3:*"
      ],
      "Resource" : "*"
    }    
  ]
}
```
Refine resources and policies as needed.

B. Create service role for CodeDeploy
 - IAM -> Roles -> Create Role
 - Choose AWS Service -> CodeDeploy
 - Use Case: CodeDeploy (for EC2 / On-Prem) (permissions should be there already)
 - Name it (eg. `CodeDeployServiceRole`)
 - Trust Relationship -> Edit Trust Relationship
 - Right now, it has access to all CodeDeploy endpoints, but you can limit it to just your region, eg:
 ```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.us-east-2.amazonaws.com",
                    "codedeploy.us-east-1.amazonaws.com",
                    "codedeploy.us-west-1.amazonaws.com",
                    "codedeploy.us-west-2.amazonaws.com",
                    "codedeploy.eu-west-3.amazonaws.com",
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
 ```
C. Create an IAM instance profile for EC2 instances
 - IAM -> Policies - Create Policy
 - Give it these permissions:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": [
                "ARN_WITH_YOUR_S3_BUCKET_NAME",
                "arn:aws:s3:::aws-codedeploy-us-east-2/*",
                "ANY_OTHER_CODEDEPLOY_REGIONS"
            ]
        }
    ]
}
```
 - Give it a policy name (eg. `CodeDeploy-EC2-Permissions`)
 - Choose Roles -> Create Role
 - Choose AWS Service -> EC2, Select Use Case -> EC2
 - Permissions: Add policy from previous step.
 - Role Name (Eg. `CodeDeply-EC2-Instance-Profile`)

D. Create an AzureDevOps user to run AWS services from AzureDevOps
 - In IAM, create a user, (eg. `AWS_AzureDevOpsUser`)
 - Give them this policy (note this is the same as the EC2 policy created on [page 1]('./1_ec2-running-apache.md')):
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetLifecycleConfiguration",
                "s3:GetBucketTagging",
                "s3:GetInventoryConfiguration",
                "s3:GetObjectVersionTagging",
                "s3:ListBucketVersions",
                "s3:GetBucketLogging",
                "s3:ListBucket",
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketPolicy",
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketObjectLockConfiguration",
                "s3:GetBucketRequestPayment",
                "s3:GetAccessPointPolicyStatus",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetMetricsConfiguration",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketPolicyStatus",
                "s3:ListBucketMultipartUploads",
                "s3:GetObjectRetention",
                "s3:GetBucketWebsite",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetObjectLegalHold",
                "s3:GetBucketNotification",
                "s3:GetReplicationConfiguration",
                "s3:ListMultipartUploadParts",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:DescribeJob",
                "s3:GetBucketCORS",
                "s3:GetAnalyticsConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetBucketLocation",
                "s3:GetAccessPointPolicy",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:*:*:accesspoint/*",
                "arn:aws:s3:::*/*",
                "arn:aws:s3:*:*:job/*",
                "arn:aws:s3:::MY_BUCKET_NAME"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:GetRole",
                "s3:GetAccessPoint",
                "iam:GetInstanceProfile",
                "s3:ListAccessPoints",
                "s3:ListJobs",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:ListRoles",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "autoscaling:*",
                "iam:AddRoleToInstanceProfile",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "iam:DeleteRolePolicy",
                "codedeploy:*",
                "ec2:*",
                "s3:HeadBucket",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy"
            ],
            "Resource": [
                "arn:aws:s3:*:*:accesspoint/*",
                "arn:aws:s3:::*/*",
                "arn:aws:s3:*:*:job/*",
                "arn:aws:s3:::MY_BUCKET_NAME"
            ]
        }
    ]
}
```


II. CodeDeploy Setup

A. Create CodeDeploy Application and Deployment Group
 - Go to CodeDeploy
 - Applications -> Create Application
 - Give it a name. For __Compute Platform__ choose `EC2/On-Premises` and  click the __Create Application__ button.

 - Click the application and the __Create Deployment Group__ button
 - Give it a name.
 - Enter a service role: Assign the service role created in step B (eg. `CodeDeployServiceRole`)
 - Choose how to deploy (In-Place or Blue/Green)
 - Select groups. For mine, __Amazon EC2 Instances__ and add a key/value from the EC2 instance (see step 1).
 - Choose the other options as you see fit, but these should work for a simple example.

III. Create a Release in Azure DevOps

. This step will send the artifact to S3. Note that awsCredentials were created in step I. D.

```yaml
steps:
- task: AmazonWebServices.aws-vsts-tools.S3Upload.S3Upload@1
  displayName: 'upload artifact to S3'
  inputs:
    awsCredentials: 'AWS_AzureDevOpsUser'
    regionName: 'us-east-2'
    bucketName: 'MY_ARTIFACTS_BUCKET'
    sourceFolder: '$(System.DefaultWorkingDirectory)/Build Artifact/MY_APP_ARTIFACTS_DIR'
    globExpressions: '**/*.zip'
    targetFolder: MY_S3_BUCKET_FOLDER
```

B. This step will run the deployment to EC2 instances through CodeDeploy:
```yaml
steps:
- task: AmazonWebServices.aws-vsts-tools.CodeDeployDeployApplication.CodeDeployDeployApplication@1
  displayName: 'aws code deploy'
  inputs:
    awsCredentials: 'AWS_AzureDevOpsUser'
    regionName: 'us-east-2'
    applicationName: 'MY_CODEDEPLOY_APPLICATION'
    deploymentGroupName: 'MY_CODEDEPLOY_APPLICATION_DEPLOYMENT_GROUP'
    deploymentRevisionSource: s3
    bucketName: 'MY_S3_BUCKET'
    bundleKey: MY_AZDEVOPS_ARTIFACT_LOCATION/s.zip
    fileExistsBehavior: OVERWRITE
    logRequest: true
    logResponse: true

```

