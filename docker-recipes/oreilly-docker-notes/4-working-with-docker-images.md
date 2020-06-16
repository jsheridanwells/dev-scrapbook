# Notes from Oreilly, Docker Up and Running
## Working with Docker images

[Here](https://learning.oreilly.com/library/view/docker-up/9781492036722/ch04.html)

A __DockerFile__:

```
FROM node:11.11.0
# declares base image and optional version
```

```
LABEL "maintainer"="anna@example.com"
LABEL "rating"="Five Stars" "class"="First Class"
# For Metadata
```

```
USER root
# root by default, but another user can be specified
```

```
ENV AP /data/app
ENV SCPATH /etc/supervisor/conf.d
# allows shell variables to be set
```

```
RUN apt-get -y update

# The daemons
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor
# RUN is for commands

# Note: not a good idea to do apt-get update like this,
# better to base it on images in known states
```

```
# Supervisor Configuration
ADD ./supervisord/conf.d/* $SCPATH/

# Application Code
ADD *.js* $AP/

# ADD allows copying from URL or filesystem to image
# COPY works for just filesystem
```

```
WORKDIR $AP

RUN npm install
# Change the directory
```

```
CMD ["supervisord", "-n"]
# CMD is the final step, the command that launches the process that will run the container
```

```bash 
$ docker build -t example/docker-node-hello:latest .
# builds the container

$ docker run --rm -ti 8a773166616c /bin/bash
# with 'bash' at the end, the process launches with an interactive terminal
```

```bash
$ docker run -d -p 8080:8080 example/docker-node-hello:latest
# runs the image with local port 8080 connected to port 8080 on docker container

$ echo $DOCKER_HOST
tcp://127.0.0.1:2376
# this prints the IP address of the docker container
```

If an application in a container depends on a variable...
```js
var DEFAULT_WHO = "World";
var WHO = process.env.WHO || DEFAULT_WHO;

app.get('/', function (req, res) {
  res.send('Hello ' + WHO + '. Wish you were here.\n');
});
```

... it can be passed in like so...
```
$ docker run -d -p 8080:8080 -e WHO="Sean and Karl" \
    example/docker-node-hello:latest
```

## Pushing images to a Docker registry

Make sure you `$ docker login`

```bash
$ docker build -t ${<myuser>}/docker-node-hello:latest .
```
`$(myuser)` is the Docker Hub username.

```bash
$ docker image ls ${<myuser>}/docker-node-hello
# verfies that the image is on the Docker server
```

```bash
$ docker push ${<myuser>}/docker-node-hello:latest
# pushes the image to Docker Hub
```

