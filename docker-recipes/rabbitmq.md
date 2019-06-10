# RabbitMQ Docker Image

Biblio:<br>
[Here](https://hub.docker.com/_/rabbitmq/)...<br>
[And here](http://www.andyfrench.info/2017/08/quick-rabbitmq-using-docker.html)...

download and run:
```bash
$ docker run -d --hostname my-rabbit --name some-rabbit rabbitmq:3
```

or better:
```bash
$ docker run -d --hostname my-rabbit --name some-rabbit -p 15672:15672 -p 5672:5672 rabbitmq:3-management
```

RMQ admin page should be available on localhost:15672 . -  default username and password is `guest`.
