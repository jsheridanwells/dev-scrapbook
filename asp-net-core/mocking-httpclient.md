# Mocking the HttpClient object in service tests

Service has to be refactored to take an injected `IHttpClientFactory`, and the HttpClient is created from there

```csharp
    public class WeatherService : IWeatherService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly string _appId;

        public WeatherService(IHttpClientFactory clientFactory, IOptions<OpenWeatherConfig> config)
        {
            _clientFactory = clientFactory;
            _appId = config.Value.AppId;
        }

        /// <summary>
        /// Retrieves the current weather for a location via the OpenWeatherMap api.
        /// </summary>
        /// <param name="zip"></param>
        /// <returns></returns>
        public async Task<WeatherForecast> GetWeather(string zip)
        {
            var client = _clientFactory.CreateClient();
            var url = OpenWeatherMapUrlBuilder.BuildUrl(zip, _appId);
            var response = await client.GetAsync(url);
            string json;
            using (var content = response.Content)
            {
                json = await content.ReadAsStringAsync();
            }

            if (response.IsSuccessStatusCode)
            {
                var weatherResponse = JsonConvert.DeserializeObject<WeatherResponse>(json);
                return new WeatherForecast
                {
                    TemperatureC = (int)weatherResponse.Main.Temp,
                    City = weatherResponse.Name,
                    ZipCode = zip,
                    Coord = weatherResponse.Coord
                };
            }
            else
            {
                var weatherError = JsonConvert.DeserializeObject<WeatherErrorResponse>(json);
                throw new OpenWeatherMapException(response.StatusCode, weatherError.Message);
            }
        }
    }
```

Then a mock HttpClient can be created this way in the test

```csharp
        [Fact(DisplayName = "GetWeather() returns a WeatherForecast type")]
        public async Task _GetWeather_ReturnsAWeatherForecastType()
        {
            //this approach from here: https://dejanstojanovic.net/aspnet/2020/march/mocking-httpclient-in-unit-tests-with-moq-and-xunit/
            var httpClientFactory = new Mock<IHttpClientFactory>();
            var httpMessageHandler = new Mock<HttpMessageHandler>();
            httpMessageHandler.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage
                {
                    StatusCode = HttpStatusCode.OK,
                    Content = new StringContent(JsonConvert.SerializeObject(new WeatherResponse()))
                });
            var client = new HttpClient(httpMessageHandler.Object);
            client.BaseAddress = new Uri("http://example.com");
            httpClientFactory.Setup(_ => _.CreateClient(It.IsAny<string>())).Returns(client);
            
            var sut = new WeatherService(httpClientFactory.Object, new OptionsFactory());
            var result = await sut.GetWeather(It.IsAny<string>());
            Assert.IsType<WeatherForecast>(result);
        }

        [Fact(DisplayName = "GetWeather() throw OpenWeatherMapException w/ bad response")]
        public async Task _GetWeather_ThrowsException()
        {
            var httpClientFactory = new Mock<IHttpClientFactory>();
            var httpMessageHandler = new Mock<HttpMessageHandler>();
            httpMessageHandler.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage
                {
                    StatusCode = HttpStatusCode.BadRequest,
                    Content = new StringContent(JsonConvert.SerializeObject(new WeatherErrorResponse()))
                });
            var client = new HttpClient(httpMessageHandler.Object);
            client.BaseAddress = new Uri("http://example.com");
            httpClientFactory.Setup(_ => _.CreateClient(It.IsAny<string>())).Returns(client);

            var sut = new WeatherService(httpClientFactory.Object, new OptionsFactory());
            await Assert.ThrowsAsync<OpenWeatherMapException>(() => sut.GetWeather(It.IsAny<string>()));
        }
```