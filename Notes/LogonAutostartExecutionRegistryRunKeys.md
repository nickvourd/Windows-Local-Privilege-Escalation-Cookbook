# Logon Autostart Execution (Registry Run Keys)

## Table of Contents

- [Logon Autostart Execution (Registry Run Keys)](#logon-autostart-execution-registry-run-keys)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
    - [Manual Lab Setup](#manual-lab-setup)
    - [PowerShell Script Lab Setup](#powershell-script-lab-setup)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

Logon Autostart Execution through Registry Run Keys is a Windows feature that enables specific programs or scripts to launch automatically when a user logs into the system. This feature allows these programs or scripts to launch automatically without any manual action from the user when the operating system starts up. 

Attackers may exploit the Logon Autostart Execution feature by inserting malicious software into the Registry Run Keys. This enables the malicious code to automatically launch during system startup, potentially granting it elevated privileges. 

## Lab Setup

### Manual Lab Setup

1) Open a PowerShell with local Administrator privileges and run the following command to create a new folder:

```
mkdir "C:\Program Files\NickvourdSrv"
```

Outcome:

![Autostart-Registry-Keys-Create-Directory](/Pictures/AutostartRegistryKeys-LabSetup-Part1.png)

2) Download the file [NCV_AMD64.exe](/Lab-Setup-Binary/NCV_ADM64.exe) to the 'C:\Program Files\NickvourdSrv' directory.

3) Modify the permissions of the 'C:\Program Files\NickvourdSrv' directory to allow Full Control for all users:

![Autostart-Registry-Keys-Modify-Directory-Permissions](/Pictures/AutostartRegistryKeys-LabSetup-Part2.png)

4) Open a PowerShell with local Administrator privileges and run the following command to edit registry key:

```
regedit
```

5) Navigate to `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run` and create new String Value `NickvourdSrv`:

![Autostart-Registry-Keys-Create-Registry-key-String-Value](/Pictures/AutostartRegistryKeys-LabSetup-Part4.png)

6) Modify the key string named `NickvourdSrv` with value data `C:\Program Files\NickvourdSrv\NCV_AMD64.exe`:

![Autostart-Registry-Keys-Modify-Registry-key-String-Value](/Pictures/AutostartRegistryKeys-LabSetup-Part6.png)

### PowerShell Script Lab Setup 

Another way to set up the lab with the 'Logon Autostart Execution (Registry Run Keys)' scenario is by using the custom PowerShell script named [LogonAutostartExecutionRegistryRunKeys.ps1](/Lab-Setup-Scripts/LogonAutostartExecutionRegistryRunKeys.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\LogonAutostartExecutionRegistryRunKeys.ps1
```

Outcome:

![Autostart-Registry-Keys-PowerShell-Lab-Setup-Script](/Pictures/AutostartRegistryKeys-LabSetup-Part7.png)

## Enumeration

## Exploitation

## Mitigation

## References
