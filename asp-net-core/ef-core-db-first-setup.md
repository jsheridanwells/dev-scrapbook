# EF Core Database First Setup

NuGet packages:
```
- Microsoft.EntityFrameworkCore
- Microsoft.EntityFrameworkCore.Tools
- Microsoft.EntityFrameworkCore.SqlServer (for SQL server adapter)
```
Get your db connection string (VS SQL Server Object Explorer is easiest).

```powershell
Scaffold-DbContext "Server=(localdb)\mssqllocaldb;Database=Blogging;Trusted_Connection=True;" 
Microsoft.EntityFrameworkCore.SqlServer -OutputDir Entities
```



