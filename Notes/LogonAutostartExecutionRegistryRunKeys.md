# Logon Autostart Execution (Registry Run Keys)

## Table of Contents

- [Logon Autostart Execution (Registry Run Keys)](#logon-autostart-execution-registry-run-keys)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
    - [Manual Lab Setup](#manual-lab-setup)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

Logon Autostart Execution through Registry Run Keys is a Windows feature that enables specific programs or scripts to launch automatically when a user logs into the system. This feature allows these programs or scripts to launch automatically without any manual action from the user when the operating system starts up. 

Attackers may exploit the Logon Autostart Execution feature by inserting malicious software into the Registry Run Keys. This enables the malicious code to automatically launch during system startup, potentially granting it elevated privileges. 

## Lab Setup

### Manual Lab Setup

1) Open a Command Prompt with local Administrator privileges and run the following command to create a new folder:

```
mkdir "C:\Program Files\NickvourdSrv"
```

Outcome:

![Autostart-Registry-Keys-Create-Directory](/Pictures/AutostartRegistryKeys-LabSetup-Part1.png)

2) Download the file [NCV_AMD64.exe](/Lab-Setup-Binary/NCV_AMD64.exe) in the 'C:\Program Files\NickvourdSrv' directory.

## Enumeration

## Exploitation

## Mitigation

## References
