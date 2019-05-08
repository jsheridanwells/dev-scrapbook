# Setting Up EF Core Entities

- Start with a DB Context:
```csharp
public class ApiContext : DbContext
    {
        public ApiContext(DbContextOptions opts)
            : base(opts) {}
        
        public DbSet<RoomEntity> Rooms { get; set; }
    }
```

The `DbSet` represents a table that will be created in the database.


 - Create an entity. The entity represents all of the propertes of the database table object:
```csharp
public class RoomEntity
{
    public Guid Id { get; set; }
    public string Name { get; set; }
    public int Rate { get; set; }
}
```

 - A regular resource (like before) can represent the actual values made available to the API consumer:
```csharp
public class Room : ResourceBase
{
    public string Name { get; set; }
    public decimal Rate { get; set; }
}
```

- Then, the context can be added at startup:
```csharp
services.AddDbContext<ApiContext>(
    opts => opts.UseInMemoryDatabase("LandonDb")
);
```
The options will change depending on the chosen database adapter.  
