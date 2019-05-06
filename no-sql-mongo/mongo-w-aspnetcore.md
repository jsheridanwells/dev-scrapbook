# AspNetCore WebApi with Mongo

- Scaffold a webapi project

- Install MongoDB.Driver:
```bash
dotnet add BooksApi.csproj package MongoDB.Driver -v {VERSION}
```

### An Entity Model

```csharp
public class Book
{
    [BsonId]
    [BsonRepresentation(BsonType.ObjectId)]
    public int Id { get; set; }

    [BsonElement("Name")]
    public string BookName { get; set; }
}
```

- Id property is required

- Annotated with `[BsonId]`

- `[BsonRepresentation(BstonType.ObjectId)]` passes a string to db which is converted to ObjectId.

- `[BsonElement]` annotates any other non-key property.


### CRUD Service

__Constructor__:
```csharp
private readonly IMongoCollection<Book> _books;
public BookService(IConfiguration config)
{
    var client = new MongoClient(config.GetConnectionString("BookstoreDb"));
    var database = client.GetDatabase("BookStoreDb");
    _books = database.GetCollection<Book>("Books");
}
```

Finding all: `return _books.Find(book => true).ToList();`

Finding One: `return _books.Find<Book>(book => book.Id == id).FirstOrDefault();`

Posting: `_books.InsertOne(book);` book is a `Book`.

Updating: `_books.ReplaceOne(book => book.Id == id, bookIn);`

Deleting: `_books.DeleteOne(book => book.Id == id);`.

### Connection String

Add this to `appsetings.json`
```json
"ConnectionStrings": {
    "BookStoreDb": "mongodb://localhost:27017"
},
```

Register `BookService` in `Startup.cs`
```csharp
services.AddScoped<BookService>();
```

