# Consuming Json Config Files

You can make an extra config file:
```json
{
  "name": "myName",
  "secretCode": "shhhhhhh"
}
```

Create a class to map the values to:
```csharp
public class MyConfig
{
  public string Name { get; set; }
  public string Secret { get; set; }
}
```

Create some sort of handler to deserialize the file:
```csharp
public MyConfig GetConfig(string jsonPath)
{
  MyConfig config;
  using (StreamReader reader = new StreamReader(jsonPath))
  {
    string json = reader.ReadToEndAsync();
    config = JsonConverter.Deserialize<MyConfig>(json);
  }
  
  return config;
}
```

And extract it like so:
```csharp
var config = ConfigClass.GetConfig("path_to/config.json");
```

The location of the json file is relative to the directory where the `.csproj` lives.
