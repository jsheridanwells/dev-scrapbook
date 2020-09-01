# Some Docker usefulness to remember...

Remove all exited containers
```bash
$ docker rm $(docker ps -a -q -f status=exited))
```
_-q means "IDs only," -f means "filter"_

`$ docker container prince` will do the same thing.

`--it` flag initates a tty session to run several commands in a container, otherwise it just does the command specified with `docker run`

`--rm` flag automatically removes the image when it stops
