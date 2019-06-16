# Remoting into a Raspberry Pi GUI

Everything you need to know [is here](https://www.raspberrypi.org/documentation/remote-access/).

1. Get your RPI IP address `$ hostname -I`

1A. You can remote into the RPI command line: `$ ssh pi@<HOSTNAME FROM STEP 1>`

2. Install VNC
```
$ sudo apt-get update
$ sudo apt-get install realvnc-vnc-server realvnc-vnc-viewer
```

3. Enable VNC:
```
$ sudo raspi-config
- Navigate to Interfacing Options.

- Scroll down and select VNC > Yes.
```

4. Install VNC on remote computer [from here](https://www.realvnc.com/download/viewer/).

5. Open VNC and connect using IP address from step 1.

