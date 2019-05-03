# Serializing Exceptions as JSON

By default, .netcore mvc returns errors as an html page. It would be better to return webapi errors as JSON.

We can create an ApiError class (`Models/ApiError.cs`) with
`string Message` and `string Details` properties.

We can create a JsonExcpetionFilter class (`Filters/JsonExceptionFilter.cs`). Filters run before or after asp.net core processes.

This one intercepts any exceptions and returns them as a generic response object:
```csharp
public class JsonExceptionFilter : IExceptionFilter
    {
        public void OnException(ExceptionContext ctx)
        {
            var error = new ApiError();
            error.Message = ctx.Exception.Message;
            error.Detail = ctx.Exception.StackTrace;

            ctx.Result = new ObjectResult(error)
            {
                StatusCode = 500
            };
        }
    }
```

We can construct the class with IHostingEnvironment, then modify the error object so that the message is very simple if it's returned in production, but detailed in development:
```csharp
if (_env.IsDevelopment())
{
    error.Message = ctx.Exception.Message;
    error.Detail = ctx.Exception.StackTrace;
}
else
{
    error.Message = "There was an error processing your request";
    error.Detail = ctx.Exception.Message;
}
```

Add the Middleware in the services.AddMvc lambda:
```csharp
services.AddMvc(opts =>
{
    opts.Filters.Add<JsonExceptionFilter>();
}).SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
```

Now we get a Json error message:
```json
{
    "message": "The method or operation is not implemented.",
    "detail": "   at LandonApi.Controllers.RoomsController.GetRooms() in /Users/jeremywells/workspace/tutorials/LandonApi/Controllers/RoomsController.cs:line 13\n   at lambda_method(Closure , Object , Object[] )\n   at Microsoft.Extensions.Internal.ObjectMethodExecutor.Execute(Object target, Object[] parameters)\n   at Microsoft.AspNetCore.Mvc.Internal.ActionMethodExecutor.SyncActionResultExecutor.Execute(IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\n   at Microsoft.AspNetCore.Mvc.Internal.ControllerActionInvoker.InvokeActionMethodAsync()\n   at Microsoft.AspNetCore.Mvc.Internal.ControllerActionInvoker.InvokeNextActionFilterAsync()\n   at Microsoft.AspNetCore.Mvc.Internal.ControllerActionInvoker.Rethrow(ActionExecutedContext context)\n   at Microsoft.AspNetCore.Mvc.Internal.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\n   at Microsoft.AspNetCore.Mvc.Internal.ControllerActionInvoker.InvokeInnerFilterAsync()\n   at Microsoft.AspNetCore.Mvc.Internal.ResourceInvoker.InvokeNextExceptionFilterAsync()"
}
```

