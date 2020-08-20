# Understanding a Dockerfile and Basic Commands

[From this resource](https://linuxhint.com/understand_dockerfile/)

### The Dockerfile

 - __FROM__ states the OS for the base image
 - __ENV__ sets environment variables
 - __EXPOSE__ sets port for outside connections. If there's no port, the container can't communicate
 - __RUN__ runs commands to build the image
 - __COPY__ copies files from Docker host to Docker image
 - __WORKDIR__ allows switching to directories in the image
 - __CMD__ sets the default process to run (e.g., `["dotnet", "MY-ASP_NET-APP.dll"]`) 
 - __ENTRYPOINT__ process to run, similar to CMD but can only be explicitly overrun.

Note, container shuts down once main process stops.

### Commands

 - `$ docker build -t MY_CONTAINER_NAME . ` builds the container. `-t` sets the name. Don't forget `.` to find the Dockerfile
 - `$ docker run -ip 5000:5000 MY_CONTAINER_NAME:latest` runs the container. `-i` means interactive. `-p` maps the port HOST_PORT:CONTAINER_PORT


