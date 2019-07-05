# C# Custom Exceptions Best Practices

[Source](https://stackify.com/csharp-exception-handling-best-practices/)

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

More [from here](https://blog.gurock.com/articles/creating-custom-exceptions-in-dotnet/#minimal)....

