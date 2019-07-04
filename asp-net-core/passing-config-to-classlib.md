# Passing Configuration From Asp.NetCore to ClassLib

In library, create a POCO as a config class, por ejemplo:
```csharp
    public class FirebaseConfig
    {
        public string BaseUrl { get; set; }
        public string AuthKey { get; set; }
    }
```

In Startup.cs, the configuration object can be initialized with AppSettings or user secrets values:
```csharp
            var firebaseConfigVals = Configuration.GetSection("Firebase");
            services.Configure<FirebaseConfig>(firebaseConfigVals);
```

The consuming class can be injected via DI the normal way:
```csharp
            services.AddTransient<IRepo, Repo>();
```

Then, the settings can be passed in and used in the constructor like so:
```csharp
        private readonly FirebaseConfig _config;
        public Repo(IOptions<FirebaseConfig> config)
        {
            _config = config;
        }
```
