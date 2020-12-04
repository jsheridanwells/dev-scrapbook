# Miscellaneous Powershell Usefulness

__Equivalent of .bashrc__

 - Best location is the _Documents_ directory: `cd $Home\Documents`
 - Or Go to Powershell directory (will be different depending on Powershell, PS Core, 32-bit etc.): `cd $PsHome`. This will add settings for any user.
 - System settings are loaded first, then user settings.
 - Create a `profile.ps1`: `New-Item -ItemType File profile.ps1`
 - Add aliases, startups, whatever you want:
 ```powershell
New-Alias c cls
New-Alias l dir
 ```

 __Equivalent of touch__

 `New-Item -ItemType File my-new-file.txt`

 Or (but this seems janky)

 `echo $null >> my-new-file.txt`

 __Processes__

 `Get-Process <process name>`

 `Stop-Process -ProcessName <frozen process>`

__Create a server proxy in Powershell__

```powershell
$url = http://<MYWEBAPP>.azurewebsites.net/CreateSite.asmx
$proxy = New-WebServiceProxy $url
$spAccount = "<username>"
$spPassword = Read-Host -Prompt "Enter password" –AsSecureString
$projectGuid = [guid]::NewGuid()
$createOneNote = $false
```

Then get available commands: `$proxy | gm -memberType Method`


 _References_

 [https://stackify.com/powershell-commands-every-developer-should-know/](https://stackify.com/powershell-commands-every-developer-should-know/)
