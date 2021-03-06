# C# Custom Exceptions Best Practices

__Sources:__
[Stackify](https://stackify.com/csharp-exception-handling-best-practices/)

[Gurock](https://blog.gurock.com/articles/creating-custom-exceptions-in-dotnet/#minimal)

[Doug Seelinger](https://blogs.msdn.microsoft.com/agileer/2013/05/17/the-correct-way-to-code-a-custom-exception-class/)



Exceptions in C# are basically `try catch finally throw`.

### Exception Filters

Exception filters help respond to different aspects of the same exception:

```chsarp
WebClient wc = null;
try
{
   wc = new WebClient(); //downloading a web page
   var resultData = wc.DownloadString("http://google.com");
}
catch (WebException ex) when (ex.Status == WebExceptionStatus.ProtocolError)
{
   //code specifically for a WebException ProtocolError
}
catch (WebException ex) when ((ex.Response as HttpWebResponse)?.StatusCode == HttpStatusCode.NotFound)
{
   //code specifically for a WebException NotFound
}
catch (WebException ex) when ((ex.Response as HttpWebResponse)?.StatusCode == HttpStatusCode.InternalServerError)
{
   //code specifically for a WebException InternalServerError
}
finally
{
   //call this if exception occurs or not
   wc?.Dispose();
```

### Common Exceptions

- Null Reference
- Index Out of Range
- IO (for file system problems)
- Web Exception (for http calls)
- SqlClient.SqlException - SQL Server exceptions
- Invalid Operation Exception - generic exception found in many libraries
- Object Disposed Exception - calling  method on an object that isn't there.

A custom exception that takes a message w/ details from the method that threw it:
```csharp
[Serializable]
public class LoginException: Exception
{
   
   public string Username { get; set; }
   
   public LoginException() {}
   public LoginException(string message) : base(message) {}
   public LoginException(string message, Exception innerException) : base(message, innerException) {}
   protected LoginException(SerializationInfo info, StreamingContext context) : base(info, context)
   {
      if (info != null)
         this.Username = info.GetString("fUsername");
   }
   
   public override void GetObjectData(SerializationInfo info, StreamingContext context)
   {
      base.GetObjectData(info, context);
      if (info != null)
         info.AddValue("fUsername", this.Username);
   }
}
```

__Serialization__:

1. Override `GetObjectData` and call `Base.GetObjectData()` to get error messages, stacktraces, etc.
1. Store whatever fields you need with the `SerializationInfo.AddValue()` method.

__Deserialization__:
1. In the constructor, we restore whatever fields we need.

Calling the exception
```csharp
public async Task Login(string username, string password)
{
   try
   {
      // do the thing to log in.
   }
   catch(Exception e)
   {
      throw new LoginException("log in failed", e) { Username = username };
   }
}
```

