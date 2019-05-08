# Shhhhh!

[Ref](https://docs.microsoft.com/en-us/aspnet/core/security/app-secrets?view=aspnetcore-2.2&tabs=linux)

This is a *nix file system path for secrets:
```bash
$ ~/.microsoft/usersecrets/<user_secrets_id>/secrets.json
```

The secrets Id for a project is found in the `.csproj` file.

Any value can work as an id, but it's usually a GUID:
```xml
<PropertyGroup>
  <TargetFramework>netcoreapp2.1</TargetFramework>
  <UserSecretsId>79a3edd0-2092-40a2-a04d-dcb46d5ca9ed</UserSecretsId>
</PropertyGroup>
```

setting a secret:
```bash
$ dotnet user-secrets set "Movies:ServiceApiKey" "12345"
```

or referencing another project:
```bash
$ dotnet user-secrets set "Movies:ServiceApiKey" "12345" --project "C:\apps\WebApp1\src\WebApp1"
```

In the project, the secrets can be accessed in the Configuration object:

```csharp
public void ConfigureServices(IServiceCollection services)
{
    _moviesApiKey = Configuration["Movies:ServiceApiKey"];
}
```

It's also helpful to map more complex configurations to a POCO, especially if it's being called from other classes:
```csharp
public class MovieSettings
{
    public string ConnectionString { get; set; }

    public string ServiceApiKey { get; set; }
}
```

```csharp
var moviesConfig = Configuration.GetSection("Movies")
                                .Get<MovieSettings>();
_moviesApiKey = moviesConfig.ServiceApiKey;
```

Connection string secrets can be pulled out using a `SqlConnecitonStringBuilder`:
```csharp
public void ConfigureServices(IServiceCollection services)
{
    var builder = new SqlConnectionStringBuilder(
        Configuration.GetConnectionString("Movies"));
    builder.Password = Configuration["DbPassword"];
    _connection = builder.ConnectionString;
}
```
