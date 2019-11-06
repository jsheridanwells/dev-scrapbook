# Clean out bin and obj directories using Bash

[From this SO](https://stackoverflow.com/questions/755382/i-want-to-delete-all-bin-and-obj-folders-to-force-all-projects-to-rebuild-everyt)

One line in bash:
```bash
find . -iname "bin" -o -iname "obj" | xargs rm -rf
```

Remove bin or obj independently
```bash
find . -iname "bin" | xargs rm -rf
find . -iname "obj" | xargs rm -rf
```

Also, Powershell
```powershell
Get-ChildItem .\ -include bin,obj -Recurse | foreach ($_) { remove-item $_.fullname -Force -Recurse }
```

And [this person](https://medium.com/volosoft/deleting-all-bin-obj-folders-in-a-solution-93e401372e69) wrote a .bat script, but it hasn't worked for me:
```
@echo off
@echo Deleting all BIN and OBJ folders…
for /d /r . %%d in (bin,obj) do @if exist “%%d” rd /s/q “%%d”
@echo BIN and OBJ folders successfully deleted :) Close the window.
pause > nul
```
