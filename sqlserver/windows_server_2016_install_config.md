# Windows Server 2016: Install and Config

[Desde Aqui](https://www.linkedin.com/learning/windows-server-2016-installation-and-configuration).

### Shutting Down Command

```powershell
# /s means server, /c means comment
> shutdown /s /c "This is my reason for shutting down"
```

## Initial Config

IP config, you'll need
* IP Address eg: `10.3.66.123`
* Mask eg: `255.255.255.0`
* Default Gateway eg: `10.3.66.123`
* Name Server eg: `10.3.66.123`

### Setting the IPs

(If you have desktop GUI), Windows Command -> Settings Wheel -> Network and Internet -> Change Adapter Options

This will show controllers

Select a controller, open properties -> double-click TCP/IPv4

Select "Use the following IP address": Type in IPs

### Setting the Name

Windows -> Settings Wheel -> Search "name" -> view Your PC Name -> Rename PC -> Restart

### Settings the Time

Windows -> Settings -> Time and Language (Set Time Automatically: On), Select Time Zone


## Command-line IPv4 config

```powershell


>  ipconfig /all ## will show current configuration

>  netsh  ## used to st network configuration

>  netsh interface ipv4 show interfaces  ## shows network interfaces, shows index number and name of network interfaces

## from there, find the interface you want to configure (in our example name: ethernet, index: 3)
## set static config:
>  netsh interface ipv4 set address name="3" source=static address=10.3.66.124 mask=255.255.255.0 gateway=10.3.66.1

#3 Add a DNS server, index=1 sets the priority (if you have multiple, stet index=2, index=3 etc):
>  netsh interface ipv4 add dnsserver name="3" address=10.3.66.120 index=1

# you may get a "DNS server is incorrect or doesn't exist" error
# test to see that the DNS server can actually be found by pinging it with the name.

>  ping 2016dc1.landonhotels.com
```

## Adding Multiple IP Addresses to one NIC

```powershell

# to add an address, use add instead of set
  > netsh interface ipv4 add address name="2" address=10.3.66.41 mask=255.255.255.0 # no need to assign gateway, same as other addresses
```

## NIC Teaming

This is taking multiple NICs and making them appear as one to Windows

__Address Hashing__: Requests go through one interface, out through several interfaces (prioritized by lease amount of use)

__Hyper-V Teaming__: Each Interface is connected to one Hyper-V instance, but function as one unit to Windows

__Dynamic Teaming__: Selects between the two.

In Server Manager, NIC Teaming is likely set to __disabled__. Click `disabled`.

In TEAMS, select TASKS -> New Team

Name the team, select the itnerfaces to include

ADDITIONAL FEATURES -> Load Balancing Mode (you can switch to Hyper-V or Dynamic Teaming here if it's installed)

## Identity on the Network

```powershell

PS   > rename-computer -newname <MY NEW NAME> -restart

# run...
PS   > hostname
# ...to verify

```

To join the server to a public domain
```powershell

   > netdom join <MY NEW NAME> /domain:my-cool-domain.com /UserD:administrator /PasswordD:<my-super-secret-password>

# restart
   > shutdown -r
```

## Managing Roles and Features

__Roles Includes:__

* Active Directory Services
* File and Print Server
* DNS
* Database Server
* Web Server
* Hyper-V

### Adding Roles



















