# Learning Nginx

## Nginx vs Apache

 - Both are open source
 - Both take advantage of dynamic modules that can be loaded at runtime
 - Both are often employedas proxy servers
 - Both use __event-based processing__ - 


|Apache|Nginx|
|---|---|
|XML config|Config uses C-like syntax|
|distributed .htaccess - individual directories can override default config|config is centralized|
|Dynamic content modules are bundled natively|Dynamic content requires external libraries|

## Installation (Ubuntu)

 - `$ apt update `<br>
 - `$ apt upgrade `<br>
 - `$ apt install nginx `<br>
 - `$ nginx -v ` to confirm.<br>
 - `$ systemctl status nginx` to confirm it's running
 - in a browser, `http://<SERVER IP>` should return the nginx welcome page
 - `$ curl http://localhost:80` should return welcome page internally

## Files and Directories

- `/etc/nginx/` : config for all of nginx
- `/etc/nginx/conf.d/`
- `/etc/nginx/sites-available/`
- `/etc/nginx/sites-enabled/` :: all contain specific configurations - `sites-available` contains default
- `/var/log` : all logs, `access.log` and `error.log` available by default
- `/var/www/` : all static files that get served (by default).

## CLI

- `$ systemctl stop nginx` : stops server
- `$ systemctl start nginx` : starts service
- `$ systemctl is-active nginx` : confirms it's active
- `$ systemctl status nginx` : more detailed status report, especially to confirm reloads have happened or failing states
- `$ systemctl reload nginx` : dynamically reloads configuration
- `$ nginx -t` : tests config to makes sure syntax it's okay before loading
- `$ nginx -T | less` : test config and prints ALL configurations, piped to `less` for paging.

## nginx.conf

- rarely modified
- single line directives end in `;`, multi-line in `{}` blocks
- `user www-data;` shows nginx is running under this user.
- `http` all directives for HTTP requests configured under this block
- `include /etc/nginx/conf.d/*.conf;` specific configurations can be loaded from here.
- `include /etc/nginx/sites-enabled/*` usually stores symlinks to configuration in other locations.

## Setting up a host

Unlink defa/ult:
```bash
$ cd /etc/nginx/sites-enabled/
$ unlink default
```

In `/etc/nginx/conf.d`, `$ touch my-new-site.conf`

Inside:
```
server {
  listen 80;
  root /var/www/my-new-site.local;
}
```

verify: `$ nginx -t`, then reload `systemctl reload nginx`

More config:
```
server {
  listen 80;
  server_name my-new-site.local www.my-new-site.local;
  index index.html index.htm index.php;
  root /var/www/my-new-site.local
}
```

## Adding files to root dir

Once static files are added, they must be modified so that:
 - they are only readable to clients, but not writeable
 - directories are executable so they can be accessed

 - Run: `$ find /var/www/my-new-site.local/ -type -f -exec chmod 644 {} \;`
 - Run: `$ find /var/www/my-new-site.local/ -type -d -exec chmod 755 {} \;`

## Configure locations

 - allows configurations to be extended based on request URI
 - new directives can be included, same as `server` blocks

The following handles default location, and serves `404` if not match is found
```
server {
  # ...
  location / {
      try_files $uri $uri/ =404;
  }
  location /images {
      autoindex on; # allows files to be listed in browser
  }
  error_page 404 /404.html;
  location = /404.html {
      internal; # specifies that it's an INTERNAL redirect
  }
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
      internal;
  }
}
```

## Configure logs

By default, `nginx.conf` contains entries for access logs and error logs. These can also be added to specific config files on a per-site basis. Can also be added to handle logs for a locatio. Can also be added to handle logs for a location.
```
access_log /var/log/nginx/my-new-site.local.access.log;
error_log /var/log/nginx/my-new-site.local.error.log;
```

## Security

 - update OS and software
 - restrict access
 - passwords
 - SSL

### Allow and Deny Directives

in config:
```
location /my-super-secret-path {
    allow 111.111.1.1/24;
    allow 10.0.0.0/8;
    deny all; # this returns 403 to any other user
}
```

### Simple password manager

 - Install apache utils: `$ apt install apache2-utils -y`
 - create a password file: `$ htpasswd -c /etc/nginx/passwords <ADMIN USERNAME>`
 - add a user: `$ htpasswd /etc/nginx/passwords <ADMIN USERNAME>`
 - remove a user: `$ htpasswd -D /etc/nginx/passwords <ADMIN USERNAME>`
 - make nginx the sole owner: `$ chown www-data /etc/nginx/passwords`
 - make nginx the sole reader: `$ chmod 600 www-data /etc/nginx/passwords`

Implement it in nginx:
```
location /my-super-secret-path {
    auth_basic "Authentication is required, yo...";
    auth_basic_user_file /etc/nginx/passwords;
    allow 111.111.1.1/24;
    allow 10.0.0.0/8;
    deny all;
}
```


## SSL / TLS

(note, this is for self-signed. Not for prod)

__Creating the cert__
 - Install Open SSL: `$ apt install openssl`
 - create the cert, valid for one year: `$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt`

__Installing cert on Nginx__

Configure server to redirect all port :80 traffic
```
server {
    listen 80 default_server;
    return 301 https://#server_addr$request_uri;
}

server {
    list 443 ssl default_server;
    ssl_certificate /etc/ssl/certs/nginx.crt;
    ssl_certificate_key /etc/ssl/private/nginx.key;
}
```
Browser will still show a strong warning, but content will be delivered via TLS.


## Reverse Proxying and Load Balancing

Both RPs and LBs sit between client traffic and app servers. RPs are for one app server instance, LBs are for multiple instances.

__Upstream__ module is used to make this happen.

Add a conf for the app server
```
upstream my_app_server {
    server 127.0.0.1:7000; # specify port app is listening on
}

server {
    listen 80;
    location /proxy { # declare a location to route requests to the app
        # trailing slash is VERY important - this routes request to the root of the 
        # app server, otherwise it would look for a location called 'proxy'
        proxy_pass http://my_app_server/;
    }
}
```

In load balancing, four methods can be used:
|method|directive|application|
|---|---|---|
|Round Robin| - |Default, upstream servers are connected to one at a time|
|Least Connections|least_conn|Prefer upstream server with least connections|
|IP Hash|ip_hash|Persist client IP address in connection, used for saving a session|
|(All)|weight|Configure weight to different servers that can account for things like CPU or # of connections|

Add a conf for the app servers and load balancer:
```
upstream my_round_robin_app_servers {
    server 127.0.0.1:7001;
    server 127.0.0.1:7002;
    server 127.0.0.1:7003;
}

server {
    listen 80;
    location /roundrobin {
        proxy_pass http://roundrobin/;
    }
}
```


