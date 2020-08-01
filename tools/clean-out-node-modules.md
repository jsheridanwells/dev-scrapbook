# Cleaning out all node_modules in a workspace

[(Which comes from this article)](https://medium.com/@MarkPieszak/how-to-delete-all-node-modules-folders-on-your-machine-and-free-up-hd-space-f3954843aeda)

Check the size of all directories with a node_modules:
```bash
$ cd workspace # or wherever
$ find . -name "node_modules" -type d -prune | xargs du -chs
```

Remove them (_cuidado!_):
```bash
find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
```


__Or for windows__
```cmd
FOR /d /r . %d in (node_modules) DO @IF EXIST "%d" echo %d"
```

```cmd
FOR /d /r . %d in (node_modules) DO @IF EXIST "%d" rm -rf "%d"
```
