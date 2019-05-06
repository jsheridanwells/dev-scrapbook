# Recipe: Creating a Dev Server For .NetCore Applications w/ Raspberry Pi and Nginx

### __Helpful RPI Commands__:

In GUI, Raspberry Pi Preferences, enable SSH.

From terminal: `$ ssh pi@raspberry` will enable remote connection.

Default root login: User: pi, Password: raspberry

Start GUI from commandline: `$ sudo startx`

Killing the GUI from the command line: `$ pkill x`



### __Installing Nginx__

`$ sudo apt-get update`

Install: `$ sudo apt-get install nginx`

Run it: `$ /etc/init.d/nginx start`

You should see the default page at `http://localhost`

Get the network address `$ hostname -I` (eg. `10.0.0.171`)

From another computer on the network, you should see it on `http://10.0.0.171`


### __Setting Up .NETCore and Kestrel__

[...]
