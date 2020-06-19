# A beginner's guide to AWS ECS

[Via...](https://www.freecodecamp.org/news/amazon-ecs-terms-and-architecture-807d8c4960fd/)

## Terms:

### Task Definition:
Describes the docker-based application
 - \# of containers
 - images
 - CP/Memory
 - Environment Variables
 - Ports
 - Container Interaction

### Task:
Created by a task definition. A task definition can run several tasks.

### Service:
Manages min and max number of tasks, autoscaling, and load balancing.

### ECS Container Instance:
an EC2 instance w/ the container. Instances can run different tasks.

### ECS Container Agent:
Communicates between ECS and the instance.

### ECS Cluster:
A group of ECS Container instances

This diagram was awesome:

![ECS Diagram](https://cdn-media-1.freecodecamp.org/images/wRtGhAtM8NLLnpTkp4PAUc80YHObxKVnFFhM)