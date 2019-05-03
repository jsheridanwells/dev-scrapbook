# Transport Security

__Https__

Asp.net core automatically redirects http to https. We can take this a step further by rejecting http outright, that way ther's no risk of a client leaking sensitive information.

A reverse proxy can be set up to reject http.

In our application, we can create a `RequireHttpsOrCloseAttribute`. In this class we override the default http to https action.

`Filters/RequireHttpsOrCloseAttribute.cs`:
```csharp
public class RequireHttpsOrCloseAttribute : RequireHttpsAttribute
{
    protected override void HandleNonHttpsRequest(AuthorizationFilterContext filterContext)
    {
        filterContext.Result = new StatusCodeResult(400);
    }
}
```

Add it to Startup filters (in ConfigureServices: AddMvc()):
```csharp
opts.Filters.Add<RequireHttpsOrCloseAttribute>();
```

Then delete the `UseHttpsRedirection()` call.
