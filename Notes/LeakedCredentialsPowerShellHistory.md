# Leaked Credentials (PowerShell History)

## Table of Contents

- [Leaked Credentials (PowerShell History)](#leaked-credentials-powershell-history)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

PowerShell history records previously run commands, including any sensitive data such as passwords. Unauthorized access to this history could lead to credential leaks, and might to privilege escalation.

## Lab Setup

:warning: <b>If you are usinfg Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

Open a Powershell with local Administrator privileges and run the following command to change the passowrd of local Administrator:

```
net user Administrator Passw0rd!
```

## Enumeration

To observe the leaked credentials, you should read the `C:\Users\<User>\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt` PowerShell history file (It is recommended to open the TXT file from File Explorer):

```
C:\Users\<User>\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
```

Outcome:

![Leaked-Creds-PS-History-Enumeration](/Pictures/Leaked-Credentials-PS-Enumeration1.png)

## Exploitation

Use these credentials to connect to a remote service or application. In this scenario, you can use these credentials to connect as "nikos" (Administrator group) via RDP to the victim's machine.

![Leaked-Creds-PS-History-Exploitation](/Pictures/Leaked-Credentials-PS-Exploitation.png)

## Mitigation

To clear the PowerShell history file, you can delete the content of the file directly:

1) Open PowerShell.

2) Run the following command: 

```
Clear-Content -Path "C:\Users\<User>\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
```

## References

- [Powershell Wikipedia](https://en.wikipedia.org/wiki/PowerShell)
- [PowerShell History Microsoft](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_history?view=powershell-7.4)
