# Recipe for Angular and ASP.NET Core WebApi on Docker

## Relevant locations
```
./
    |__Client
        |__Dockerfile
        |__.dockerignore
        |__default.conf
    |__WebApi
        |__Dockerfile
        |__.dockerignore
    docker-compose.yml
```

## Client

 - Make sure any services with `HttpClient` reference the WebApi in an environment config file, e.g.:
 ```ts
 // environments/environment.ts
export const environment = {
  production: false,
  version: '0.0.1',
  apiDomain: 'http://localhost:4000'
};
 ```
 ```ts
 // environments/environment.prod.ts
export const environment = {
  production: true,
  version: '0.0.1',
  apiDomain: '/api/'
};
```

Make sure build script is registered in `package.json`:
```json
{
// ...
  "scripts": {
    "ng": "ng",
    "start": "ng serve",
    "build": "ng build --prod=true", // <---
// ...
  },
```

### Docker steps
 1. using node:12.7-alpine
 1. 1. Copy `package.json` and npm install
 1. 2. Copy all other files (put node_modules in `.dockerignore`)
 1. 3. npm run build
 2. using nginx:1.17.1-alpine
 2. 1. Copy default.conf
 2. 2. Copy all artifacts from dist in first step
 2. 3. expose port :80. Container from this image will automatically startup Nginx

 __Dockerfile__
```
### STAGE 1: Build ###
FROM node:12.7-alpine AS build
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/src/app/dist/Client /usr/share/nginx/html
EXPOSE 80
```

__default.conf__
```C
server {
    listen 80;
    server_name hello-client;
    root /usr/share/nginx/html;
    index index.html index.html;

    location /api/ {

        if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        #
        # Custom headers and headers various browsers *should* be OK with but aren't
        #
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        #
        # Tell client that this pre-flight info is valid for 20 days
        #
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain; charset=utf-8';
        add_header 'Content-Length' 0;
        return 204;
     }
     if ($request_method = 'POST') {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
     }
     if ($request_method = 'GET') {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
     }
        proxy_pass http://hello-api:4000/;
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

__.dockerignore__
```
node_modules
dist
```

Command to run the client container on host port :8080: `$ docker run -it -p 8080:80 hello-client`

## WebApi

In `Program.cs`, set Kestrel port to :4000:
```csharp
public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .UseSerilog()
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>()
                        .UseUrls("http://*:4000"); // <----  THIS
                });
```

### Docker steps
 1. Use mcr.microsoft.com/dotnet/core/sdk:3.1 to build project
 2. Use mcr.microsoft.com/dotnet/core/aspnet:3.1 to run project
 3. set ASPNETCORE_URLS to http://+:4000

 __Dockerfile__
 ```
# build
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

# run
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /app/out .

ENV ASPNETCORE_URLS http://+:4000

ENTRYPOINT ["dotnet", "HelloApp.Api.dll"]

 ```

 To run: `$ docker run -it -p 4000:4000 hello-api`

## Docker compose

__docker-compose.yml__:
```yaml
version: '3'
services:
  hello-api:
    build: ./Api
    container_name: hello-api
    ports:
     - 4000:4000
  
  hello-client:
    build: ./Client
    container_name: hello-client
    ports:
     - 8080:80
    links:
     - hello-api

```

To run:
```bash
$ docker-compose build
$ docker-compose up
```