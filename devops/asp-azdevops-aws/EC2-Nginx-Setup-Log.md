# EC2 Nginx Setup Log

Add forwarded headers options in Startup.cs
```csharp
app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
});
```

change Angular build repo from /dist to ../Api/wwwroot in angular.json
```json
...
"projects": {
    "Client": {
      ...
      "architect": {
        "build": {
          ...
          "options": {
            "outputPath": "../Api/wwwroot",
```


Publish dotnetcore binaries and angular files, then zip and upload to S3
```bash
$ dotnet publish Api/EBWalkingSkeleton.Api.csproj -c Release -o ./artifacts -r linux-x64
$ ng build
```

uploaded the zip to an S3 bucket, also dropped client code in the .zip

Create VPC first

VPC:
 - Name: eb-walking-skeleton-sg
 - IPv4 CIDR block: 10.0.0.0/16
 - No IPv6 block, default tenancy

Create Internet Gateway and attach to above VPC

Route Table:
 - Add Route: 0.0.0.0/0 and ::0 to internet gateway from above

Subnet:
 -  Name : eb-walking-skeleton-subnet
 - VPC: <AS ABOVE>
 - Availability Zone: US East 1
 - CIDR Block: 10.0.0.0/24

EC2 instance:

AMI: AWS Linux 2

Type: t2.micro

Auto assign public IP: Enable (was disable nd it couldn't be reached publicly)

IAM role: eb-walking-skeleton-ec2-role (w/ EC2 full access policy)

Tags:  Name: eb-waking-skeleton

Security Group : 
 - Name : eb-walking-skeleton-ec2-sg
 - SSH : TCP :22 Source ::/0 (for now)
 - HTTP : TCP :80 Source ::/0 (for now)
 - HTTPS : TCP :443 Source ::/0 (for now)

Key Pair : eb-walking-skeleton-kp (stored in .ssh)

download to key pair locally (.ssh)

ssh: `$ ssh -i "eb-walking-skeleton-kp.pem" ec2-user@<IP--->`

__On EC2 Instance:

Install dotnetcore sdk.

Add signing key:
```bash
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
```

Install
```bash
sudo yum install dotnet-sdk-3.1
```

Install runtime:
```bash
sudo yum install dotnet-runtime-3.1
```

Install AWS code deploy agent ([from here](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html))
```bash
sudo yum update
sudo yum install ruby
sudo yum install wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
```

## Nginx Setup

### Installing on an AWX Linux box

First you have to enable latest nginx release from amazon-linux-extras:
```bash
sudo amazon-linux-extras enable nginx1
```

Then update and install nginx from yum: `$ yum clean metadata` and `$ yum install nginx`

You can use [this tool](https://www.digitalocean.com/community/tools/nginx) to create a set of nginx conf files.

After all of the settings there is a CopyToClipboard link that will create a Base64 string. Paste that string into ssh terminal and it will create a .zip with the config files.

go to `/etc/nginx`

back up the current configuration: `$ tar -czvf nginx_$(date +'%F_%H-%M-%S').tar.gz nginx.conf sites-available/ sites-enabled/ nginxconfig.io/`

install unzip: `$ yum install -y unzip`

and unzip it: `$ unzip -o nginxconfig.io-example.com.zip`

start nginx: `$ systemctl start nginx`

verify it's running: `$ systemctl status nginx`

enable it so it launches at startup `$ systemctl enable nginx`

install and enable firewalld
```bash
$ systemctl start nginx
$ sudo systemctl start firewalld
$ sudo systemctl enable firewalld
$ sudo systemctl status firewalld
```

Alow htp and https traffic through firewall
```bash
$ firewall-cmd --zone=public --permanent --add-service=http
$ firewall-cmd --zone=public --permanent --add-service=https
```

Navigate to IP in browser and it should be working.


Add the following inside of etc/nginx/nginx.conf:
```text
 location /api/ {
            proxy_pass http://localhost:5000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection keep-alive;
            proxy_set_header Host $http_host;
            proxy_cache_bypass $http_upgrade;
        }

```

Create a service file for the asp.netcore app
```service
[Unit]
Description= EB Walking Skeleton
After=network.target

[Service]
ExecStart=/usr/share/dotnet/dotnet /var/EBWalkingSkeleton/EBWalkingSkeleton.Api.dll 5000
Restart=on-failure

# [Install]
# WantedBy=multi-user.target
# EOF

```

configure and start the aspnetcore service
```bash
sudo cp eb-walkingskeleton.service /lib/systemd/system
sudo systemctl daemon-reload 
sudo systemctl enable eb-walkingskeleton
sudo systemctl start eb-walkingskeleton
sudo systemctl status eb-walkingskeleton

```

Lastly, if restarting is an issue, this worked:
[from here](https://www.virtualmin.com/node/41514) and [here](https://serverfault.com/a/706585)

 - Open `/etc/sysctl.conf`

 - Add `fs.inotify.max_user_watches = 262144` (or some other high number)

 - Reboot the machine.