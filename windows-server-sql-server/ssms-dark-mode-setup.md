# Setting Up Experimental Dark  Mode in SSMS

[Source](https://blog.sqlauthority.com/2019/09/12/sql-server-management-studio-18-enable-dark-theme/)

1. Go to `C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\ssms.pkgundef` (or equivalent).  Search for file `ssms.pkgundef`

2. Comment out the `$RootKey$\Themes` line (currently near line #242).  It'll look like this:
```
// Remove Dark theme
// [$RootKey$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]
```

3. Restart SSMS

4. Enjoy.
