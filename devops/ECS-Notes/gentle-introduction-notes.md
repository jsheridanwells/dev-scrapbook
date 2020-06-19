# A gentle introduction to how ECS works notes

[Via...](https://cdn-media-1.freecodecamp.org/images/wRtGhAtM8NLLnpTkp4PAUc80YHObxKVnFFhM)

## Creating the cluster

1. Create the security group
```bash
$ aws ec2 create-security-group --group-name my-ecs-sg --description my-ecs-sg
```

2. In console, create a cluster with security group from above step

```
Cluster Template" EC2 Linux + Networking
Cluster Name: Your Cluster Name
EC2 Instance Type: t2.micro for now
EC2 AMI ID: AWS Linux 2
Root EBS Volume Size: 30
Key Pair: Choose a keypair you already have so you can SSH into it

VPC: Default for now
Subnets: Both subnets in my default VPC
Security Group: The one from above

Container intance IAM Role: Created new role w/ AmazonEC2ContainerServiceforEC2Role permissions
```

## Creating a task definition

1. Verify that the test docker image works:
```bash
$ docker run -d -p 4567:4567 --name hi tongueroo/sinatra

$ curl localhost:4567 ; echo

# should return 42
```

2. Use this task defintion from `$ curl -o task-defintion.json https://raw.githubusercontent.com/tongueroo/sinatra/master/task-definition.json`.
```json
{
  "family": "sinatra-hi",
  "containerDefinitions": [
    {
      "name": "web",
      "image": "tongueroo/sinatra:latest",
      "cpu": 128,
      "memoryReservation": 128,
      "portMappings": [
        {
          "containerPort": 4567,
          "protocol": "tcp"
        }
      ],
      "command": [
        "ruby", "hi.rb"
      ],
      "essential": true
    }
  ]
}
```

3. Register the task defintion `$ aws ecs register-task-definition --cli-input-json file://task-definition.json`

4. Create an ELB load balancer. Has to have subnets in the same availability zones as the cluster. Don't add a target group yet. Create a new security group for the load balancer.

5. Add security group ingress to connect security group to load balancer
```bash
$ aws ec2 authorize-security-group-ingress --group-name my-ecs-sg --protocol tcp --port 1-65535 --source-group my-elb-sg
```


