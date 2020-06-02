# AWS Elastic Beanstalk Notes

##### From [this tutorial](https://www.linkedin.com/learning/aws-deploying-and-provisioning/)

## Elastic Beanstalk

A Platform as a Service - tools for deployment, configuration, and scaling

## ELB Concepts
 - Define the application
   - Name: < My APP >
   - Stack: < MY CLOUD FORMATION STACK >
   - Stack Options: < VARIOUS KINDS OF STACK CONFIG >
 - ELB then...
   - creates an autoscaling group
   - automatically associates a load balancer
   - creates an agent to monitor the environment
   - option to create an RDS database
   - sources (artifacts) ca be moved to an S3 bucket or Git repo
   - Can perform rolling deployment (no downtime, limited capacity as one server group udpates at a time)
   - Or immutable deployment (copy entire server fleet, update the first fleet, then terminate the copy)

## Initialize the application
 - From AWS CLI (best practice is to do it as a sub-user)
   - `$ eb init --profile <MY SUB USER>`
   - it can create an SSH key pair if necessary
   - it can guess your environment

## Create an EB environment
 - `$ eb create <ENV NAME>-<APP NAME> -i m1.small`
 - best to have application name + environment name as EB environment name because they'll be listed w/o context (w/ 5 environments all named 'staging' this would be confusing)
 - this will automatically load a zipped artifact into an S3 bucket (named elastic-beanstalk-<REGION NAME>)
 - this will automatically create
   - load balancer found in EC2
   - auto scaling group (also under EC2)
   - Cloud Watch alarms
   - User Data script to create your stack

## Deploying
 - run `$ eb open <env-name>` and a browser will open pointed to application from that environment
 - run `$ eb logs <env-name>` to see logs (this will open a vim-navigable text file)
 - to set any environment variables, run `$ eb setenv MY_KEY_NAME=MY_SECRET_VALUE -e <env-name>`
 - to update, commit the changes in Git (not sure yet how this would work with TFS), and run `$ eb deploy <env-name>`

## Elastic Beanstalk Database
 - Go to EB Configuration Options -> Data Tier
   - Here you can create a database (but it will be heavily tied to the application - for bigger applications, better to create RDS instance independently to preserve the templatefor other work).
   - Master Username / Master Password thatis set will be injected into the application (best to save it too).
   - Configuration (connection strings, etc) done at app level.

## Autoscaling
 - Go to EB Configuration -> Scaling
 - Best to make changes in EB console rather than EC2 because EB will be more aware of overall changes
 - In EC2, you can see load balancer health check settings set to TCP by default. This will need to be changed to HTTP, serving the root index.
 - In CLI: `$ eb config <env name>` will pull up a config file that can be edited with vim. Search for `AutoScaling` property that can be set. Also `HealthCheck` field. Change `URL` field to `'/'` and the TCP -> HTTP change will have been made.

## Customizing
 - Three ways:
   - Custom AMI (slowest)
   - User Data scripts (already used by EB)
   - EB Extensions -> place an `./.ebextensions` directory in application root. All files will be evaluated in alphabetical order.
     - Configurable fields include:
      - `packages`: (any installations)
      - `option_settings`: (env variables, be careful to not check secrets into the commit history)
      - `container_commands`: <COMMAND NAME> : `command` : <command (eg. rake db:seed) or scripts (eg. install.sh)>
