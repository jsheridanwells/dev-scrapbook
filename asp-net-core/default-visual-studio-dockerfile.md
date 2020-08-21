## Default Visual Studio Dockerfile

This is, mostly, what the Visual Studio boilerplate Dockerfile consists of:
```
#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["AspNetCoreConfigExample.csproj", ""]
RUN dotnet restore "./AspNetCoreConfigExample.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AspNetCoreConfigExample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspNetCoreConfigExample.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV Secret:SuperDuperSecret="Artie is my friend in the Dockerfile"
ENTRYPOINT ["dotnet", "AspNetCoreConfigExample.dll"]
```

This is added to `launchSettings.json`
```json
    "Docker": {
      "commandName": "Docker",
      "launchBrowser": false,
      "launchUrl": "{Scheme}://{ServiceHost}:{ServicePort}/weatherforecast",
      "publishAllPorts": true,
      "useSSL": true
    }
```
