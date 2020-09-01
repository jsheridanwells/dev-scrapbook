# Some Docker usefulness to remember...

Remove all exited containers
```bash
$ docker rm $(docker ps -a -q -f status=exited))
```
