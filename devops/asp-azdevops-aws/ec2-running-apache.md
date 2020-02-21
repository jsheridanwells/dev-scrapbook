# Prepping an EC2 instance to run Apache

I. Set up instance

 - Launch Instance
 - Amazon Linux 2 AMI
 - Pick whatever instance type you need
 - Configuration
 - - VPC: CIDR 10.0.0.0/16
 - - Subnet: CIDR 10.0.0.0/24
 - - IAM Role: Create a role with these permissions:
 ```json
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
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
                "arn:aws:s3:::aws-demo-work-artifacts",
                "arn:aws:s3:::aws-codedeploy-us-east-3/*",
                "arn:aws:s3:::aws-codedeploy-us-east-2/*",
                "arn:aws:s3:::aws-codedeploy-us-east-1/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:GetAccessPoint",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:ListJobs",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        }
    ]
} 
 ```
 - Add a tag that will be used in your CodeDeploy deployment group
 - Create a security group with these rules (this is probably insecure, but works for prototyping):
 
 HTTP | TCP | 80 | 0.0.0/0
 
 HTTP | TCP | 80 | ::/0
 
 SSH | TCP | 22 | < Add Your IP >
 
 II. Installing Apache
  - Install it `sudo yum update` | `sudo yum install httpd`
   - Start it to see if it works: `sudo systemctl start httpd`
   - Set it to start on system reboot: `sudo systemctl enable httpd`
   - Add port :80 to firewall: `firewall-cmd --permanent --zone=public --add-service=http`
  
III. Set up proxy server configuration
- In __/etc/httpd/conf.d/ create MY_APP.conf:
```xml
<VirtualHost *:80>
  ProxyPreserverHost On
  ProxyPass / http://127.0.0.1:5000/
  ProxyPassReverse / http://127.0.0.1:5000
</VirtualHost>
```
(There's more, but this will work for now)

Restart Apache

IV. Set up dotnet runtime (Follow MS's CentOS instructions)
```bash
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

sudo yum install dotnet-sdk-3.1

sudo yum install aspnetcore-runtime-3.1

sudo yum install dotnet-runtime-3.1
```



 
 
