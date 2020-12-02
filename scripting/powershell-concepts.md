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

###### _Sources_
[Learning Powershell (LIL)](https://www.linkedin.com/learning/learning-powershell/)
[Learning Powershell (From MS)](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction?view=powershell-7.1)