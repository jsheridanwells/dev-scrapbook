# CORS

CORS middleware can be added in Startup.cs

The policy needs a name:
```csharp
private readonly string _devCorsPolicy = "devPolicy";
```

Configure it in services:
```csharp
services.AddCors(opts => 
{
    opts.AddPolicy(_devCorsPolicy,
        policy => policy
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader()
    );
});
```

Then add it to the Configure() method:
```csharp
app.UseCors(_devCorsPolicy);
```

Note, in production, it would be more restrictive. The MS docs can help you with that.
