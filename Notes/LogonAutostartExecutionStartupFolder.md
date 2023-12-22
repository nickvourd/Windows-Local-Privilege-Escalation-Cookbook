# Logon Autostart Execution (Startup Folder)

## Table of Contents

- [Logon Autostart Execution (Startup Folder)](#logon-autostart-execution-startup-folder)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
    - [Manual Lab Setup](#manual-lab-setup)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

Logon Autostart Execution via Startup Folder is a Windows feature that enables specific programs or scripts to launch automatically when a user logs into the system. This feature allows these programs or scripts to launch automatically without any manual action from the user when the operating system starts up.

Attackers may exploit the Logon Autostart Execution feature by inserting malicious software into the Startup Folder. This enables the malicious code to automatically launch during system startup, potentially granting it elevated privileges. 

## Lab Setup

### Manual Lab Setup

:warning: <b>If you are usinfg Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

1) Navigate via File Explorer to the directory which contains StartUp Folder using the following path:

```
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\
```

Outcome:



2) 

## Enumeration

## Exploitation

## Mitigation

## References
