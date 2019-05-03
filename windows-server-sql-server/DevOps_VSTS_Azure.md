# DevOps For DB w/ VSTS and Azure

[Desde Aqui](https://www.linkedin.com/learning/devops-for-the-database-with-vsts-and-azure-2)
## SSDT 

Relational DB Project - Analysis Service Project - Reporting Services Project - Integration Service Project

(Supports cloud and on-prem)

GUI Tools

CLI Tools to Automate

Drivers and APIs

State-based approach (as opposed to EF ORM or ReadyRoll migration strategy)

## Version Control

Version Control: Who, What, and When

Work Items: Why

Improves Traceability

VSTS Supports 3 Workflows: CNMI, Agile, SCRUM

Centralized (TFVC) or Decentralized (Git)

## Version Control your SQL Database

1. Take the database catalog offline
 - User a state model
 - Model DB entitites as DDL Entries
 - Persist them as SQL files
 - Use a Visual Studio project to manage them as a unit
 
2. Create SQL DB Project in repo
- can be imported with online database, dacpac, or raw sql
- in Solution Explorer, right-click project, then Import... (select type and db)

3. Publish the project locally
- Right click project, select Publish...
- Connection -> Edit...
- Select server, leave Database Name blank. hit Ok
- Fill in name of Db in Publish dialog
-Export options are Save as profile, generate script(for dba), publish, 
- Select publish, and you've got a local copy.

4. dacpac
 - In Windows Explorer, open (project)\bin\Debug and you'll find the dacpac.
- rename it (dacpacName).zip and open it.
 - Inside you'll find model.xml which contains the whole schema which can be compared with existing db.
 
## Schema Compare and Data Compare

- Tools -> SQL Server -> New Schema Comparison...  Will tell you if remote db and local db are out of sync w/ option to merge changes

- Tools -> SQL Server -> New Data Comparison... will compare records from to versions of db. Differences can be accounted for
and SQL script can be generated. This can be used for static tables or seed data.

## Agents

Agents are computers w/ piece of software that can do tasks automatically.

SSDT only supports Windows Agents

__Hosted Agents__ managed by MS Azure
__Private Agents__ managed locally w/ connection back to VSTS

Agents live in __pools__. Pools can organize similar agents. Agents have capabilities

Agents need __SqlPackage__ to deploy dbs, ndeds `sqlpackage.exe` installed.

Hosted and Hosted VS 2017 are necessary to deploy with SSDT.

Agents can be created:

VSTS -> Project Settings -> Agents Pools -> Capabilities

click Download Agent:
- create agent directory on server
- copy powershell script VSTS gives you and run on server (as admin).
- In VSTS get access token: Profile -> Security -> Add Access Token
- Select scope of permissions and copy access token.
- On server, run config.cmd
- Get server URL (ex. https://MyAccountName.visualstudio.com
- Paste token
- Select pool (default)
- Select work folder (default: `_work`).
- Run agent as a service? -> Yes.
- Enter user account (default: NT AUTHORITY\NETWORK SERVICE)

## Deployment Groups

DGs "phone home" to VSTS, reducing need for complicated firewalls or DMZs.

Tags: specify which tasks each agent should run).

## Pipelines

Private and hosted.

Control how many agents can be active.

# Building the DB

Building is not compilation - do the bits create a product?

Building conforms to a schedule

__Creating a build definition__:

Start w/ .NET desktop template

Adjust settings

Save, queue, build.

Pipelines -> Builds -> New Build

- Select Azue Repos Git as source
- Select .NET Desktop template
- W/ Pipeline highlighted, find solution (it uses wildcards by default, but you should drill down to specific solutions)
- Use NuGet, NuGet Restore, keep defaults
- For now, disable testAssemblies, remove publish symbols (something used for debugging)

## CI, DBs, and Testing

Ideally, build whenever a change is checked in

 - In VS, right-click project -> properties -> code analysis
 - Check Enable Code Analysis On Build
 - Build (You should see two errors (warnings)
 - Look at ErrorList (Work items could be created from these errors)
 
 In VSTS, Click Build -> Edit -> Triggers -> check enable continuous integration and specify rules

## Releasing the DB to a server

- Less error-prone than manual deployment
- Deploys the same way to multiple environments, environment is the only variable
- 

# DB Testing

Differences:
- Tests need to be shaped around the data.

Different levels of testing:
- Testing DB objects w/ a known set of data.
- Integration testing with the app w/ both known and variable sets of data

Good test data should not come directly from prod.

Test data can be smaller subset

Needs to be consistent

Should be versioned

SSDT supports unit testing.

Supports testing db objects like stored procedures, functions, triggers, etc.

Written in T-SQL, backed by managed code (c#)

Can be built, tested, and deployed in VS

Can be run in VSTS releases

## Creating Tests

- Right-click object to test (function, stored procedure, etc.) select Create Unit Test...
- Create and name project, name wrapper class
- Add db connection string

Write test using test conditions box.

Build and Run

## Tokenization tasks for changing db env variables

Unit test project has an app.config file

Connection string in default config points to localdb

This can be tokenized.  Replace `ConnectionString` with token eg. `__connectionString__`

In VSTS, go to account root and settings

Go to Extensions. Click link for VS Martketplace. Search for "Colin" and click Coln's ALM Corner

Edit release environment

Add new task to Agent Job. Add, search "token", select Replace Tokens

In Source Path, navigate to <TestProject>/bin/Release (or whatever contains app.config) and select that directory.

Under Variables tab, add new variable called `connectionString` (or whatever was between the `__` in the name or connection string).
Value is db connection string on deployed db (or Azure as the case may be).

Add VsTest task, Search Folder can be the same as the app.config directory form the previous step (makes the directory search more specific).

## Real-World Issues

### Data Motion

Moving data whenever db changes occur

Often done through custom scripts

### Static Data

(Seed data), can be run with postdeploy script in dacpac

1. Publish local db to a new, empty db.

2. Do a data comparison between the two. 

3. When descrepencies are detected, a data fast-forward script will be created.

4. Right-click project -> Add Script -> Select Post-Deployment Script

5. Paste data compare script into post-deploy script (after the comments).

6. Now, when you publish,. post-deploy will run.

### Database Drift

Production is the ultimate source of truth. Prod databases are what feed the apps.

Test service that access the database (end-to-end).

### Versioning the database

(Too complex for us)
















