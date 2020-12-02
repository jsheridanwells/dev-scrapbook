# Powershell Concepts

## Basics

- For consistent, repeatable tests
- Works with built-in providers
- Talks to AD, registry, and WMI
- Bridges gap between previous languages with aliases
- Built into many IT products
- Compiled commands are _cmdlets_
- Three core cmdlets:
-  - `Get-Command`
-  - `Get-Help`
-  - `Get-Member `
- `Get-Command` finds available command, e.g.: `Get-Command -Name *service* -CommandType Cmdlet, Function, Alias`

### An Alias
 - `Get-ChildItem` is aliases by `ls` and `dir`
 Get-Command
Get-Help
Get-Member 

## How to read the language

 - Like and imperative sentence

|Command|Parameter|
|---|---|
|`Get-Service`|`-name` `"*net*"`|
|_verb-noun_|_name argument|

 - PS is case-INSENSITIVE
 - Nouns are almost always singular
 - Pipe operator, `|`, sends output from one command to next command, just like Bash.
 - 

## Get-Help
 - Syntax: `Get-Help -Name Get-Help` or `Get-Help -Name Add-AzureDisk -Examples`
 - These parameters can display full or filtered information on a help topic:
 -  - Full
 -  - Detailed
 -  - Examples
 -  - Online
 -  - Parameter
 -  - ShowWindow
 - Also, `-Name` is a positional parameter. This: `Get-Help Get-AzureRmRedisCacheLink -Full` also works.
 - Using `help` as a function odes the same thing: `help Add-AzureDisk`
 - Wildcards work: `help *process*`
 - Use `Update-Help` every once in a while (or in a profile launcher) to refresh the help topics (requires internet access)

 ## Get-Command and Aliases

  - `Get-Command` will show every command on the system (!!!)
  - Lots of commands have Bash and DOS aliases
  - You can create your own with `Set-Alias` ()
  - Examples:
  - - `Set-Alias -Name list -Value Get-ChildItem` # creates alias. This can also reassign an alias
  - - `Set-Alias -Name np -Value C:\Windows\notepad.exe` # sets alias for executable
 
  - `| Get-Member` is usefull for displaying all props and methods on a cmdlet, e.g.:
   - `Get-Help | Get-Member` will show all props and methods on `Get-Help`

## Functions
 - Used and accessed just like cmdlets.
 - You can make your own functions

```ps
function add 
>>> {
    $add = [int])2+2)
    write-output "$add"
}
```
Then `add` will display `4`

## Risk mitigation
 - `-WhatIf` will dry run a command and show output without actually executing:
 - - `Get-Service |Stop-Service -WhatIf` (btw that would shut the whole system down)
 - `-Confirm` will ask for confirmation when acting on every single object in an output


## ISE (Integrated Scripting Environment)
 - Very useful for building scripts
 - Uses Intellisense and syntax highlighting
 - F5 to run the script, and F8 to run selection
 - Commands sidebar can use a form to build out commands in a script
 - Ctrl+shift+r will run a script on a remote system

## Working with output
 - Sends output and controls format
 - `Get-Service |Format-Table displayname, status, requiredservices` - creates table with desired properties
 - `Get-Service |Sort-Object status |Format-Table displayname, status, requiredservices` - creates table withe desired properties and sorts
 - `Get-Service |Sort-Object status |Format-Table displayname, status, requiredservices |Output-FIle services.txt` - creates table withe desired properties and sorts, and outputs to a text file

### Grid-View
 - `get-service |out-gridview` outputs to a sortable GUI grid like File Explorer
 - `get-service |select-object *|out-gridview` sends all properties in grid-view, you can list properties instead of wildcard

## Working remotely
 - `-ComputerName` will run the command on specified server:
 - - `Get-Service -ComputerName dcdsc, webserver| Sort-Object MachineName`
 - Scripts can also be run remotely with PS ISE

## Modules
 - `Get-Module -List-Available` will show modules available on system. PS now loads modules automatically if called.
 - `Import-Module -Name applocker` will explicitly load a module (useful on servers)
 - Microsoft Script Gallery is a library of community-generated scripts
 - Execution policy only trusts scripts created locally by default. `Set-ExecutionPolicy` can allow downloaded scripts to run, or run a locally-developed script on a server

`-Async` attached to a command will run it in a detached mode.

## Azure Powershell
 - Everything is done through the Azure Resource Manager
 - AzPS can run on Win, OSX, and Linux. Az Cloud Shell can run in a browser/Azure Portal (includes Bash)
 - Azure CLI can also run commands on any OS
 - `Install-Module az -AllowClobber -Scope CurrentUser` Installs Azure, clobber handles updating

###### _Sources_
[Learning Powershell (LIL)](https://www.linkedin.com/learning/learning-powershell/)
[Learning Powershell (From MS)](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction?view=powershell-7.1)