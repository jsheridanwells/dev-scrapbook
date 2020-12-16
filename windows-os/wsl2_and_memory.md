# WSL2 Memory

Right now, `vmmem`, the WSL2 virtual machine can cause RAM spikes :(

Read more [here](https://github.com/microsoft/WSL/issues/4166)

For now, I can limit the RAM used to 1/2 of the 8GB available by adding `.wslconfig` in the `%USERPROFILE%` directory:
```
[wsl2]
memory=4GB
swap=0
localhostForwarding=true
```
