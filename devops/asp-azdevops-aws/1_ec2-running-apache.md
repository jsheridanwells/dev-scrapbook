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
- In `/etc/httpd/conf.d/` create MY_APP.conf:
```xml
<VirtualHost *:80>
  ProxyPreserverHost On
  ProxyPass / http://127.0.0.1:5000/
  ProxyPassReverse / http://127.0.0.1:5000
</VirtualHost>
```
(There's more below, but this will work for now)

 - Test the config:
 ```bash
 sudo service httpd configtest
 ```
 - Restart Apache `sudo systemctl restart httpd`

 IV. Use systemd to manage Kestrel processes:<br>
 - Create the definition file:
 ```bash
sudo vi /etc/systemd/system/kestrel-helloapp.service
 ```
 - Example file
 ```
[Unit]
Description=Example .NET Web API App running on CentOS 7

[Service]
WorkingDirectory=/var/www/helloapp
ExecStart=/usr/local/bin/dotnet /var/www/helloapp/helloapp.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-example
User=apache
Environment=ASPNETCORE_ENVIRONMENT=Production 

[Install]
WantedBy=multi-user.target
 ```
- enable the Kestrel app service:
```bash
sudo systemctl enable kestrel-helloapp.service
```

- viewing logs - journalctrl w/ arguments can filter all service logs for those related to the .net app:
```bash
sudo journalctl -fu kestrel-helloapp.service --since "2016-10-18" --until "2016-10-18 04:00"
```
`-fu` for specifying name of service, `--since` and `--until` for date ranges

IV. Set up dotnet runtime ([Follow MS's CentOS instructions](https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-centos7))
```bash
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

sudo yum install dotnet-sdk-3.1

sudo yum install aspnetcore-runtime-3.1

sudo yum install dotnet-runtime-3.1
```

_sources:_<br>
[docs.microsoft.com](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-apache?view=aspnetcore-3.1)




(Here's a longer Apache .conf file as an example):
```xml
<VirtualHost *:*>
    RequestHeader set "X-Forwarded-Proto" expr=%{REQUEST_SCHEME}
</VirtualHost>

<VirtualHost *:80>
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:5000/
    ProxyPassReverse / http://127.0.0.1:5000/
    ServerName www.example.com
    ServerAlias *.example.com
    ErrorLog ${APACHE_LOG_DIR}helloapp-error.log
    CustomLog ${APACHE_LOG_DIR}helloapp-access.log common
</VirtualHost>
```



