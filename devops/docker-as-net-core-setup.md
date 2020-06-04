# Dockerizing and AspNetCore application (What worked for me)

Add `.UserUrls($"http://+:5000")` to `webBuilder` in `Program.cs`
```csharp
 public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>()
                        .UseUrls($"http://+:5000"); // < ---- THIS
                });
```

This dockerfile worked:
```dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

COPY Api/*.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish Api/< MY-PROJECT ></>.Api.csproj -c Release -o out

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as base
WORKDIR /app
COPY --from=build-env /app/out .

EXPOSE 5000

ENTRYPOINT ["dotnet", "< MY-PROJECT >.Api.dll"]

```

And don't forget the `.dockerignore`
```
obj\
bin\
```
