# AWS Deploying and Provisioning

###### [From LikedInLearning](https://www.linkedin.com/learning/aws-deploying-and-provisioning/architect-apps-for-horizontal-scaling?collection=urn%3Ali%3AlearningCollection%3A6404794025735389185&u=78655346)

## EC2

 - Single instances of a server in AWS
 - Located in a region (where AWS resources are physically located, 6 in US)

## AWS Load Balancing

 - High availability
 - Fault Tolerance
 - Cross-zone balancing
 - HTTP health checking
 - Integration w/ AutoScaling groups

ELB Classic provides above scenario, but now we have Application Load Balancer (ALB) and Network Load Balancer (NLB)

### ALB Provides:
 - Level 7
 - Listens for HTTP/S on any port
 - Integrates with AWS Certificate Manager
 - Operates on request level
 - Feature is it can take en/decryption load off of servers

### NLB Provides:
 - Level 4
 - Maps ports to ports
 - Multiple port listeners
 - Millions of requests per second
 - Can be assigned to static IP addresses
 - Multiple ports on a single instance
 - BUT - No TLS termination
 - This is good for end-to-end encryption, packet is encrypted until it reaches the server

## Autoscaling
 - __Vertical Scaling__: changing EC2 type which would require a reboot and downtime
 - __Horizontal Scaling__: adding more identical EC2 instances behind a load balancer
 - __Auto Scaling__: provides this as a service, scaling as a response to conditions
 - __Auto Scaling Group (ASG)__: a container of EC2 instances that are added and removed
 
__ASG__s -> react to -> __Policy Events__ -> take an -> __Action__ -> to remove or add -> __Instances__ -> according to a -> __Launch Configuration__

 - __Launch Configuration__: captures the set of config choices normally made when provisioning a server. Cannot be edited, only replaced with an updated copy.
 - Options include:
 - - AMI (Base Image)
 - - Instance Type
 - - Security Groups
 - - SSH Key
 - - A pre-baked AMI can be created, or it can run a setup script called (confusingly) __User Data__.

## Security Groups
 - reusable network security rules
 - define incoming and outgoing rules
 - can be attached to almost any resource
 - default is deny all incoming and allow all outgoing
 - in AWS, no traffic is allowed to any resource w/o an SG
 - can be configured to trust other SGs, e.g., DB Group is set to trust any request from the WebApp Group. Any resource provisioned in WebAppGroup is then automatically trusted.
 - replaces complex subnet configs

## Cloud Formation
 - Helps replay setup of services rather than having to re-configure from scratch
 - Configuration (in JSON or YAML)
 - - Resource definitions
 - - Parameters
 - - Conditions

 ^-- this is called a Stack File

 - Can be parameterized for other values
 - All resources from the stack can be terminated immediately
 - W/ YAML in project's source control , we get Infrastructure as Code
 - CloudFormation Designer provides a drag and drop template

## Create and Provision w/ Cloud Formation
 - Resources is the only required section
 - Provides params, selection options for team members creating an instance of configured services.

 [This tutorial will provide a better step-by-step in detail](https://medium.com/boltops/a-simple-introduction-to-aws-cloudformation-part-1-1694a41ae59d)

 - Updating modifies the resource in place
 - Creating a change set allows a preview of changes and allows changes to be carried out incrementally.
 
 ### Custom Resources
  - You can execute your own functions
  - Input and output parameters
  - Creates, updates, and destroys resources
  - Can be backed by a lambda function

 They can:
  - configure an AWS resource before CloudFormation support becomes available
  - fetch values
  - perform provisioning steps like seeding a DB
 
 ### Teardown
  - Deleting stack ensures that there aren't unused resources that are being charged.
 


## Architecting for Scaling

 - Application needs:
 - - Small and fast requests
 - - Network and file I/O is minimized
 - - Resource-intensive processes are handled asynchronously
 - Horizontal Scaling:
 - - Fault tolerance
 - - Less expensive
 - - No downtime
 - - But -> -> It must be architected

### Consider:
 - separate app and db servers
 - load balancer
 - avoid using the file system
 - use db-backed or cookie-backed session stores (so requests are uniform no matter the LB direction)
 - Assets to S3 or DB
 - Elastic File System can also scale itself

### Network Security:
 - Public and private subnets (ideally both application server and db server in private subnets)
 - ELB w/ TLS cert, redirects port :80 to :443
 - App in private subnet only communicates with ELB. DB instances accepts no outside connections
 - App uses NAT gateway for any requests to outside, eg, deployment artifacts, updates
 - security group allows web app access on db port (:5432)
 - containers would allow config and setup w/o directly accessing the servers
 - or you would have jumpbox method

### DON'T:
 - make resources world accessible
 - expose unnecessary ports
 - skip TLS

### DO:
 - principle of least privilege
 - client-server security group model
 - keep data in private subnets
 - patch system-use ALB w/ TLS configured





