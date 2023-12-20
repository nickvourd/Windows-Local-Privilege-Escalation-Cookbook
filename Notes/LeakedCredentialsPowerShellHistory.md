# Leaked Credentials (PowerShell History)

## Table of Contents

- [Leaked Credentials (PowerShell History)](#leaked-credentials-powerShell-history)
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

1) Open a Powershell with local Administrator privileges and run the following command to create a new user:

```
net user nikos Passw0rd! /add
```
2) Add the new user to Administrators group:

```
net localgroup "Administrators" nikos /add
```

3) Add the new user to Remote Desktop Users group:

```
net localgroup "Remote Desktop Users" nikos /add
```

4) Enable Remote Desktop Service:

```
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

Outcome:

![Leaked-Creds-PS-History-Manual-Lab-Setup](/Pictures/Leaked-Credentials-PS-Manual-Lab-setup.png)

## Enumeration

To observe the leaked credentials, you should read the `C:\Users\<User>\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt` PowerShell history file.

![Leaked-Creds-PS-History-Enumeration](/Pictures/Leaked-Credentials-PS-Enumeration.png)

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
