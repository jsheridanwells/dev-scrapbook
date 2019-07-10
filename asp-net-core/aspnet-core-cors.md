# Settings CORS in AspNetCore

In `Startup.cs`:
```csharp

// set name of policy.  this can be anything.
private string _myCORS = "mycors";

// in ConfigureServices()
services.AddCors(opts => 
{
  opts.AddPolicy( // creates policy w/ name from above
    _myCORS, 
    builder => 
    {
      builder.WithOrigins("http://localhost:4200")
        .AllowAnyHeader()
        .AllowAnyMethod() // note: this is stupid
    }
})

// then in Configure()
app.UseCors();  // applies policy to entire application

```

