# Representing Resources

 - ION/HATEOAS models can inherit from 
a base model with an Href property, which takes the place of an ID.

```csharp
public class ResourceBase
{
    [JsonProperty(Order = -2)]
    public string Href { get; set; }
}
```

The Newtonsoft Json attribute makes it the 
first item in the Json output.

- The rest of the models can inherit from this and they're regular POCO classes.

If data is static, it can be mapped into Json, tied to a class , then made available at Startup.

We'll stick some static data in the appsettings:
```json
"Info": {
"title": "The London Hotel",
"tagline": "You'll feel like home here.",
"location": {
    "street": "123 Oxford",
    "city": "London",
    "country": "UK"
},
"email": "info@londhotel.com",
"website": "www.landonhotel.com"
}
```

This is tied to the following POCO:
```csharp
namespace LandonApi.Models
{
    public class HotelInfo : ResourceBase
    {
        public string Title { get; set; }
        public string Tagline { get; set; }
        public string Email { get; set; }
        public string Website { get; set; }
        public Address Location { get; set; }
    }

    public class Address
    {
        public string Street { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
    }
}  // note inherits Href prop from ResourceBase
```

Made available in Startup.Configure:
```csharp
services.Configure<HotelInfo>(
    Configuration.GetSection("Info")
); // note "Info" is the property at the 1st level of appsettings
```

Then injected into a controller constructor:
```csharp
private readonly HotelInfo _hotelInfo;
public InfoController(IOptions<HotelInfo> hotelInfoWrapper)
{
    _hotelInfo = hotelInfoWrapper.Value;
}
[HttpGet(Name = nameof(GetInfo))]
public ActionResult<HotelInfo> GetInfo()
{
    _hotelInfo.Href = Url.Link(nameof(GetInfo), null);
    return _hotelInfo;
}
```
