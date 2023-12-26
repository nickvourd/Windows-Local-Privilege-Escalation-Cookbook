# Windows Local Privilege Escalation Cookbook (In Progress)
<p align="center">
  <img src="/Pictures/Windows-Funny.jpg">
</p>

## Description (Keynote)

This Cookbook was created with the main purpose of helping people understand local privilege escalation techniques on Windows environments. Moreover, it can be used for both attacking and defensive purposes.

:information_source: This Cookbook focuses only on misconfiguration vulnerabilities on Windows workstations/servers/machines.

:warning: Evasion techniques to bypass security protections, endpoints, and antivirus are not included in this cookbook. I created this PowerShell script, [TurnOffAV.ps1](/Lab-Setup-Scripts/TurnOffAV.ps1), which permanently disables Windows Defender. Run this with local Administrator privileges.

The main structure of this Cookbook includes the following sections:

- Description (of the vulnerability)
- Lab Setup
- Enumeration
- Exploitation
- Mitigation
- (Useful) References

I hope to find this CookBook useful and learn new stuff 😉.

## Table of Contents

- [Windows Local Privilege Escalation Cookbook](#windows-local-privilege-escalation-cookbook)
  - [Description (Keynote)](#description-keynote)
  - [Table of Contents](#table-of-contents)
  - [Useful Tools](#useful-tools)
  - [Vulnerabilities](#vulnerabilities)
  - [References](#references)

## Useful Tools

In the following table, some popular and useful tools for Windows local privilege escalation are presented:

| Name | Language | Author | Description |
|:-----------:|:-----------:|:-----------:|:-----------:|
| [SharpUp](https://github.com/GhostPack/SharpUp) | C# | [@harmj0y](https://twitter.com/harmj0y) | SharpUp is a C# port of various PowerUp functionality |
| [PowerUp](https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1) | PowerShell | [@harmj0y](https://twitter.com/harmj0y) | PowerUp aims to be a clearinghouse of common Windows privilege escalation |
| [BeRoot](https://github.com/AlessandroZ/BeRoot) | Python | [AlessandroZ](https://github.com/AlessandroZ) | BeRoot(s) is a post exploitation tool to check common Windows misconfigurations to find a way to escalate our privilege |
| [Privesc](https://github.com/enjoiz/Privesc) | PowerShell | [enjoiz](https://github.com/enjoiz) | Windows PowerShell script that finds misconfiguration issues which can lead to privilege escalation |
| [Winpeas](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS/winPEASexe) | C# | [@hacktricks_live](https://twitter.com/hacktricks_live) | Windows local Privilege Escalation Awesome Script |

## Vulnerabilities

This Cookbook presents the following Windows vulnerabilities:

- [AlwaysInstallElevated](/Notes/AlwaysInstallElevated.md)
- [Logon Autostart Execution (Registry Run Keys)](/Notes/LogonAutostartExecutionRegistryRunKeys.md)
- [Logon Autostart Execution (Startup Folder)](/Notes/LogonAutostartExecutionStartupFolder.md)
- [Leaked Credentials (PowerShell History)](/Notes/LeakedCredentialsPowerShellHistory.md)
- [SeBackupPrivilege](/Notes/SeBackupPrivilege.md)
- [SeImpersonatePrivilege](/Notes/SeImpersonatePrivilege.md)
- [Stored Credentials (Runas)](/Notes/StoredCredentialsRunas.md)
- Unquoted Service Path*
- Weak Service Binary Permissions
- Weak Service Permissions
- Weak Registry Permissions

## References

- [Privilege Escalation Wikipedia](https://en.wikipedia.org/wiki/Privilege_escalation)
- [SharpCollection GitHub by Flangvik](https://github.com/Flangvik/SharpCollection)
- [Metasploit Website](https://www.metasploit.com/)
- [Evil-WinRM GitHub by Hackplayers](https://github.com/Hackplayers/evil-winrm)
- [Windows Privilege Escalation Youtube Playlist by Conda](https://www.youtube.com/watch?v=WWE7VIpgd5I&list=PLDrNMcTNhhYrBNZ_FdtMq-gLFQeUZFzWV&index=13)
- [Seatbelt GitHub by GhostPack](https://github.com/GhostPack/Seatbelt)
- [Sysinternals Suite Microsoft](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite)
- [Impacket GitHub by Forta](https://github.com/fortra/impacket)
