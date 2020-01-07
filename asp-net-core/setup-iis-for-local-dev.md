# Setting up IIS for Local Dev

From [this](https://enterprise.arcgis.com/en/web-adaptor/latest/install/iis/enable-iis-8-components-server.htm) and [this](https://devblogs.microsoft.com/aspnet/development-time-iis-support-for-asp-net-core-applications/)

1. From Windows Key, search for __"Turn windows features on or off"__

1. Enable IIS

1. In Visual Studio, Tools > Get Tools and and Features.... Look under Installation details > ASP.NET and Web Development > Select __Development Time IIS Support__

1. Update launch settings for project to add IIS support. You can do this via Project > Properties or adding this to launch settings:

```json
{
    "iisSettings": {
        "windowsAuthentication": false,
        "anonymousAuthentication": true,
        "iis": {
            "applicationUrl": "http://localhost/MyWebApplication",
            "sslPort": 0
        }
    },
    "profiles": {
        "IIS": {
            "commandName": "IIS",
            "launchBrowser": "true",
            "launchUrl": "http://localhost/MyWebApplication",
            "environmentVariables": {
                "ASPNETCORE_ENVIRONMENT": "Development"
            }
        }
    }
}
```
