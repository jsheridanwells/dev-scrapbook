# Creating an EF Repository as a ClassLib

This for creating a simple schema in a local instance of Sql Server, then creating a standalone class library that can be migrated to a separate db and re-used in other AspNetCore projects.

- Create your table and constraints in SSMS

- Create a __console app project__ in Visual Studio. It's a console project because EF Db Scaffold needs a Program.cs file to run.

- Nuget Install:
  - Microsoft.EntityFrameworkCore
  - Microsoft.EntityFrameworkCore.SqlServer (or whatever adapter you're using)
  - Microsoft.EntityFrameworkCore.Tools 
Make sure your versions match the version of the asp.net core app you're targeting (I'm still using 2.1, so 2.18 is best).

- Run Db Scaffold `> Scaffold-DbContext "Server=(localhost);Database=MyDatabasePRoject;Trusted_Connection=True;" Microsoft.EntityFrameworkCore.SqlServer`

- In the `MyDatabasePojectDbContext.cs` file, you can remove the `OnConfiguring` method 'cuz it's got the connection string. This will be injected in the constructor when this class is used by other projects.

- Delete the `Program.cs` file. Right click the project > Properties.  Change project type from Console App to Class Library.
