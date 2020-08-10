add a secret
```bash
az keyvault secret set --vault-name "Contoso-Vault2" --name "ExamplePassword" --value "hVFkk965BuUv"
```

retrieve
```bash
az keyvault secret show --name "ExamplePassword" --vault-name "Contoso-Vault2"
```


### fixed it by 

adding api key as env variable


This bit pulls api key from env, but falls back on user-settings
```csharp
            // Add OpenWeatherMap API key
            if (_env.IsDevelopment())
            {
                var openWeatherConfig = Configuration.GetSection("OpenWeather");
                services.Configure<OpenWeather>(openWeatherConfig);
            }
            var key = Environment.GetEnvironmentVariable("OpenWeatherApiKey");
            if (!String.IsNullOrEmpty(key))
            {
                services.Configure<OpenWeather>(opts =>
                {
                    opts.ApiKey = key;
                });
            }
```

Build image
```bash
$ docker build -t my-image
```

Run Docker container, pass in env variable
```bash
docker run -d -p 8080:80 -e OpenWeatherApiKey=$OpenWeatherApiKey --name my-container my-image
```

