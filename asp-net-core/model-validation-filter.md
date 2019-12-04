# A Simple Model Validation Filter

[Source....](https://www.jerriepelser.com/blog/validation-response-aspnet-core-webapi/)

1. Set up `Filters/ModelValidationAttribute.cs`:
```csharp
    public class ValidateModelAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            if (!context.ModelState.IsValid)
                context.Result = new BadRequestObjectResult(context.ModelState);
        }
    }
```

2. Add it as an attribute to any controller endpoint:
```csharp
[HttpPost("MyResource")]
[ValidateModel]  // <-- here
public async Task<IActionResult> ValidateWhatIPost([FromBody] WhatIPost whatIPost)
{
  // [etc...]
}
```

If the model is invalid `(!ModelState.IsValid)`, it gets kicked back before it gets to the controller.
