# SignalR with .NEw Core and Angular

[source](https://code-maze.com/netcore-signalr-angular/).

### Add to client packages:
```bash
npm install @aspnet/signalr –-save
```

### Add a SignalR Hub class

```csharp
public class MyHub: Hub
{
        
}
```

### Add SignalR in Startup Pipeline
```csharp
// ConfigureServices()
services.AddSignalR();

// Configure()
app.UseEndpoints(endpoints =>
    {
        endpoints.MapControllers();
        endpoints.MapHub<MyHub>("/myhub");
    });
```

### Invoke channel in controller
```csharp
[Route("api/[controller]")]
[ApiController]
public class ChartController : ControllerBase
{
    private IHubContext<ChartHub> _hub;
 
    public ChartController(IHubContext<ChartHub> hub)
    {
        _hub = hub;
    }
 
    public IActionResult Get()
    {
        var timerManager = new TimerManager(() => _hub.Clients.All.SendAsync("transferchartdata", DataManager.GetData()));
 
        return Ok(new { Message = "Request Completed" });
    }
}
```

### Build and start SignalR connection in Angular

Note that 'transferchartdata' is identical in asp.net Hub channel and Angular HubConnection.

```typescript
import * as signalR from "@aspnet/signalr";
 
@Injectable({
  providedIn: 'root'
})
export class SignalRService {
  public data: any[];
 
private hubConnection: signalR.HubConnection
 
  public startConnection = () => {
    this.hubConnection = new signalR.HubConnectionBuilder()
                            .withUrl('https://localhost:5001/mychannel')
                            .build();
 
    this.hubConnection
      .start()
      .then(() => console.log('Connection started'))
      .catch(err => console.log('Error while starting connection: ' + err))
  }
 
  public addTransferChartDataListener = () => {
    this.hubConnection.on('transferchartdata', (data) => {
      this.data = data;
      console.log(data);
    });
  }
}

```

### Call to api controller to kick off connection
```typescript
export class AppComponent implements OnInit {
 
  constructor(public signalRService: SignalRService, private http: HttpClient) { }
 
  ngOnInit() {
    this.signalRService.startConnection();
    this.signalRService.addTransferChartDataListener();   
    this.startHttpRequest();
  }
 
  private startHttpRequest = () => {
    this.http.get('https://localhost:5001/api/chart')
      .subscribe(res => {
        console.log(res);
      })
  }
}
```