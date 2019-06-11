# EF Core, Configuring Connection String

[from...](https://medium.com/agilix/entity-framework-core-providing-a-connection-string-from-configuration-65ecd2d2f0d9)

This setup assumes EFCore is installed as a separate console application that's injected into a main application.

In Console.App Program.cs #Main() : 

```csharp
        static void Main(string[] args)
        { 
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json");

            var config = builder.Build();
            var connectionString = config.GetConnectionString("MyConnectionString");
            var options = new DbContextOptionsBuilder<MyContext>()
                .UseSqlServer(connectionString)
                .Options;
        }
```

In the main application, appsettings.json:
```json
"connectionStrings": {
  "MyConnectionString": "connect it, yo!"
}
```

In the main Startup.cs #ConfigureServices():
```csharp
services.AddDbContext<MyDbContext>();
```
