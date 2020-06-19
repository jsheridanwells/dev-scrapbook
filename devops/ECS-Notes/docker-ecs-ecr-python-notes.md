# How to deploy a Docker Container on AWS Elastic Container Service (ECS) using Elastic Container Registry (ECR)

[Via...](https://towardsdatascience.com/how-to-deploy-a-docker-container-python-on-amazon-ecs-using-amazon-ecr-9c52922b738f)

1. Creating an ECR repository: `$ aws ecr create-repository --repository-name python-app-aws`
1. Repository in ECR console.
1. Process of getting project (w/ Dockerfile) to ECR is:


## Create the repository
 - A- Authenticate  -  Make sure aws cli is authenticated for AWS account, `$aws ecr get-login`. Docker is authenticated to use ECR repo for 12 hours.**
 - B- Build  - `$ docker build -t python-app-aws .`
 - T- Tag - `$ docker tag python-app-aws:latest <--URI-OF-ECR-REPOSITORY-->`
 - P- Push

** problem with output from `get-login`. Workaround is to repeat docker command that is produced, but remove `https://` from the repository URI. [Solution here](https://docs.aws.amazon.com/AmazonECR/latest/userguide/common-errors-docker.html#error-403)

## Deploy container to ECS

1. Create a task definition

This is the task definition I used:
```json
{
    "executionRoleArn": "arn:aws:iam::XXXXXXXXX:role/ecsTaskExecutionRole",
    "containerDefinitions": [
      {
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/python-app-aws",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
          }
        },
        "image": "XXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/python-app-aws:latest",
        "name": "custom"
      }
    ],
    "memory": "1024",
    "compatibilities": [
      "EC2",
      "FARGATE"
    ],
    "taskDefinitionArn": "arn:aws:ecs:us-east-1:XXXXXXXXX:task-definition/python-app-aws:1",
    "family": "python-app-aws",
    "requiresCompatibilities": [
      "FARGATE"
    ],
    "networkMode": "awsvpc",
    "cpu": "256",
    "revision": 1,
    "status": "ACTIVE",
  }
```


