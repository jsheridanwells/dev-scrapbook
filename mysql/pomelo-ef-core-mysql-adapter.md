# MySql EF Core Adapter

Here's the [project page](https://github.com/PomeloFoundation/Pomelo.EntityFrameworkCore.MySql).

- Install from NuGet. Currently, v 2.1.4 is compatible w/ AspNetCore App 2.1.8 & EFCore 2.1.* :
```bash
$ dotnet add package Pomelo.EntityFrameworkCore.MySql --version 2.1.4
```

- Make sure charset is utf8mb4: `>> show variables 'character_set_database';`

- I added the server name, database name, database user, and user password as project secrets, then built up the database connection like this (maybe there's a more elegant way, but it works):
```csharp

// DbConfig.cs
public class DbConfig
{
    public string Server { get; set; }
    public string Database { get; set; }
    public string User { get; set; }
    public string Password { get; set; }
}

// Startup.cs ConfigureServices()
var dbConfig = Configuration.GetSection("Db")
        .Get<DbConfig>();

    services.AddDbContextPool<ApiContext>(
        opts => opts.UseMySql(
            $"Server={dbConfig.Server};"
            + $"Database={dbConfig.Database};"
            + $"User={dbConfig.User};"
            + $"Password={dbConfig.Password};"
        ,
        mySqlOptions => 
        {
            mySqlOptions.ServerVersion(new Version(8, 0, 15), ServerType.MySql);
        }
    ));
```

