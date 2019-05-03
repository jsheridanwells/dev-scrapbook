# Setup

### RootController.cs

__Basic Root Controller Template:__
```csharp
[Route("/")]
    [ApiController]
    // for versioning, adds version# to response headers
    [ApiVersion("1.0")]
    public class RootController : ControllerBase
    {
        [HttpGet(Name = nameof(GetRoot))]
        [ProducesResponseType(200)]
        public IActionResult GetRoot()
        {
            var response = new
            {
                // creates route url for the resource,
                // first entry is the resource that is returned
                href = Url.Link(nameof(GetRoot), null),
                // resources will be listed here
                rooms = new 
                {
                    href = Url.Link(
                        nameof(RoomsController.GetRooms),
                        null
                    )
                }
            };

            return Ok(response);
        }
    }
```

__Startup and Middlewares__:
```csharp
// configure services

// lowercase urls make api more adaptable to
// different kinds of consumers
services.AddRouting(opts => opts.LowercaseUrls = true);

// api versioning middlewares
// using using Microsoft.AspNetCore.Mvc.Versioning;
services.AddApiVersioning(opts => 
{
    opts.DefaultApiVersion = new ApiVersion(1, 0);
    opts.ApiVersionReader = new MediaTypeApiVersionReader();
    opts.AssumeDefaultVersionWhenUnspecified = true;
    opts.ReportApiVersions = true;
    opts.ApiVersionSelector = new CurrentImplementationApiVersionSelector(opts);
});

// in Configure,
// add swagger (Nuget NSwag)
if (env.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwaggerUi3WithApiExplorer(opts => 
    {
        opts.GeneratorSettings.DefaultPropertyNameHandling = NJsonSchema.PropertyNameHandling.CamelCase;
    });
}
```
