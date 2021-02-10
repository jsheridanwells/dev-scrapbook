# MS SQL Server 2016

[Desde aqui](https://www.linkedin.com/learning/learning-microsoft-sql-server-2016/).

SQL Server configuration manager:

* Found here: `	C:\Windows\SysWOW64\SQLServerManager14.msc`

* Mostly used for starting and stopping and determining if it starts automatically or not.

__Access__:

In MS SQL, right-click user name (could be sa), change password, click server -> properties -> security -> Allow SQL and Windows authentication. 
Then, re-start SQL Server in configuration manager.

Documentation [aqui](https://docs.microsoft.com/en-us/sql/sql-server/sql-server-technical-documentation?view=sql-server-2017).

## Structure

Rows are records, columns are fields.

__Data Types:__

Char(10), NChar(10) Text or Unicode (# in parentheses specifies the number of charcters)

VarChar(50), NVrChar(50) variable number of characters

TinyInt (0-255)
Int(-/+ 2 billion)
Decimal
Float  [Etc....]

[Desde Aqui....](https://www.linkedin.com/learning/microsoft-sql-server-2016-essential-training?u=2201026)

### Filegroups

A secondary filegroup can help expand the DB beyond one core.

Secondary DBs are usually with ext `.ndf`. 

To create secondary filegroup: MyDB -> Properties -> Filegroups.

To create a table in a filegroup:
```SQL

CREATE TABLE MyTable (MyId int, MyName nvarchar(5)) ON SECONDARY

```

### InMemory Tables

Recommended for transactions. Columnstore recommended for reporting.

```SQL
 
ALTER DATABASE TestDB01 
ADD FILEGROUP TestDB01Memory 
CONTAINS MEMORY_OPTIMIZED_DATA;   


ALTER DATABASE TestDB01 
ADD FILE (Name='TestDB01Memory01', Filename='c:\TestDB01Memory01') 
TO FILEGROUP TestDB01Memory ;

GO  
  
USE TestDB01
GO  
  
CREATE TABLE dbo.ShoppingCart (   
    ShoppingCartId INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,  
    PersonID int,   
    NetPrice money,   
    Tax money )
WITH (MEMORY_OPTIMIZED=ON) 
  

```

### Temporal Tables

Show a record of what data looked like before each row is added.
```SQL

CREATE TABLE Inventory 
(    
  [InventoryID] int NOT NULL PRIMARY KEY CLUSTERED   
  , [ItemName] nvarchar(100) NOT NULL  
  , [ValidFrom] datetime2 (2) GENERATED ALWAYS AS ROW START  
  , [ValidTo] datetime2 (2) GENERATED ALWAYS AS ROW END  
  , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)  
 )    
 WITH (SYSTEM_VERSIONING = ON); 

```
This creates an internal table that records states of transactions that can be queried.

`FOR_SYSTEM_TIME` param queries data for that particular time rather than the present.
```SQL
SELECT [StockItemName]
FROM [WideWorldImporters].[Warehouse].[StockItems]
FOR SYSTEM_TIME AS OF '2015-01-01'
WHERE StockItemName like '%shark%'
```

Called 'Time Travelling Query'

### Views

Rightclick Views -> Add a view.  Select tables for view. Diagram will show key relationships. Check columns to display and save. Then rightclick the view that was added in the views list, and you can run a top 1000 query just like any single table.

### Persisted Views

Persisted views can be saved to hold data on their own, rather than just querying all of the included tables.

Add an index to the view. The view must be schema-bound (tied to structure of underlying database)

To make it schema-bound, right click view, Script View As -> ALTER to -> New Query Editor Window.

This will pull up template for changing the view.

Under `ALTER VIEW [viewName]`, add `WITH SCHEMABINDING` and execute.

Now, open view, opne indexes and New Index

Add -> Selected Columns for index.

Now, when reading the view, it will have the related data already saved (indexed). But if you write to any of hte tables, there will be a performance penalty as it will need to write to > 1 table now.

Tables like CityStates are good candidates for indexed views as they rarely change. Tables like Orders, with lots of transactions are not good candidates.

### Stored Procedures

Put queries into gorups, controls access to database.

Example:
```SQL
CREATE PROCEDURE highTemperature
AS 
SELECT VehicleRegistration, Temperature, RecordedWhen
FROM  [Website].[VehicleTemperatures]
WHERE Temperature > 4.9

'''

__With Parameters__:

Example:
```SQL
CREATE PROCEDURE highTemperatureBetweenDates
@startDate datetime,
@endDate datetime
AS 
	IF (@startDate IS NOT NULL) AND (@endDate IS NOT NULL)
		
		SELECT VehicleRegistration, Temperature, RecordedWhen
		FROM  [Website].[VehicleTemperatures]
		WHERE Temperature > 4.9
		AND RecordedWhen >= @startDate
		AND RecordedWhen <= @endDate

	ELSE
		SELECT 'Invalid Date'
```

Parameters are declared with @ + name + data type:  `@startDate datetime`

NULL testing handles errors. Now when executed, MS SQL MS prompts for parameters.

### JSON Formatting

Run the query like this for JSON output:
```SQL
SELECT FullName, PreferredName, EmailAddress
FROM Application.People

FOR JSON AUTO
```

### Converting JSON to Tabular Data

```SQL
DECLARE @json varchar(200)
SET @json =  
N'[  
      { "FirstName": "John", "LastName": "Smith" },  
      { "FirstName": "Jane", "LastName": "Smith" }
]'  
  
SELECT *  
FROM OPENJSON(@json)  
WITH (FirstName nvarchar(50) '$.FirstName', 
      LastName nvarchar(50) '$.LastName' ) 
      ```
      
```
`OPENJSON` is output table. `$.` represents overall JSON object

__Creating a table to store JSON and validating__:

```SQL
CREATE TABLE JSONtest (
  JsonData nvarchar(2000)
)  

ALTER TABLE JSONtest
ADD CONSTRAINT [Check JSON]
CHECK ( ISJSON( JsonData )> 0 )

---------------------------------------------------------

INSERT INTO JSONtest (JSONData)
VALUES (N'[  
      { "FirstName": "John", "LastName": "Smith" },  
      { "FirstName": "Jane", "LastName": "Smith" }
]'  )

```

### Reading SQL Server Logs

You can use Log File Viewer

Logs can be set to Success and Failed logins under Security.

### High Avaiability

Minimizes downtime and masks network failure the users:
* Failover Clustering
* Always on availability groups
* Log Shipping
* Replication

Characteristics:
* Failover process
* Scopeof protection
* data loss
* performance options

__Clustering__: 2 servers run an SQL instance, users only access one at a time, only one node is active at a time. Disadvantages is one server does noting unless there's a failure

__High Availability:__ Replaces mirroring, uses Windows clustering services, secondary server can be read only (won't do nothing).  Protexts one or more databases, possibility of zero data loss or no change to performance (not both).

__Log Shipping__: Transaction log is copied to other servers, log is replayed on secondary servers eery 5, 15 minutes, etc. Manual failover, protects one database, never zero data loss.

__Replication__: Agents that copy data from one server to another. Sometimes there's a conflict if data is changed on each server, protects any amount of data, possibility of zero data loss.

### Auth

There's: Windows Authentication and SQL Authentication

Windows Auth: Users are managed by domain administrators

SQL Auth: Separate login, DB Admins are in control.

### Indexes 

Indexes are copies of info from the table.

Types: 

* Clustered - order data is written to disk, one per table, created automatically when PK is created
* Nonclustered - most common, multiple (up to 999)
* Columnstore - converts data to rows
* Spatial - specialty data types
* XML - xml to tabular formatting
* Full-Text - support English-language queries

Tables that are written to often should have less indexes, tables that are read more should have more indexes.

__ColumnStore:__

With columnsotre index, selected columns are stored in rows, causing it to ignore unnecessary columns (read only in older versions of SQL)

