# Windows Local Privilege Escalation Cookbook
<p align="center">
  <img width="500" height="350" src="/Pictures/Windows-OS-Funny-2.jpg.png"><br /><br >
  <img alt="Static Badge" src="https://img.shields.io/badge/Version-1.9-blue?link=https%3A%2F%2Fgithub.com%2Fnickvourd%2FWindows-Local-Privilege-Escalation-Cookbook%2Freleases">
  <img alt="Static Badge" src="https://img.shields.io/badge/License-MIT-orange?link=https%3A%2F%2Fgithub.com%2Fnickvourd%2FWindows-Local-Privilege-Escalation-Cookbook%2Fblob%2Fmaster%2FLICENSE">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/nickvourd/Windows-Local-Privilege-Escalation-Cookbook?logoColor=yellow">
  <img alt="GitHub forks" src="https://img.shields.io/github/forks/nickvourd/Windows-Local-Privilege-Escalation-Cookbook?logoColor=red">
  <img alt="GitHub watchers" src="https://img.shields.io/github/watchers/nickvourd/Windows-Local-Privilege-Escalation-Cookbook?logoColor=green">
</p>

## Table of Contents

- [Windows Local Privilege Escalation Cookbook](#windows-local-privilege-escalation-cookbook)
  - [Table of Contents](#table-of-contents)
  - [Disclaimer](#disclaimer)
  - [Description (Keynote)](#description-keynote)
  - [Definition](#definition)
  - [Useful Tools](#useful-tools)
  - [Vulnerabilities](#vulnerabilities)
  - [References](#references)
 
## Disclaimer

:information_source: This repository, "Windows Local Privilege Escalation Cookbook" is intended for educational purposes only. The author bears no responsibility for any illegal use of the information provided herein. Users are urged to use this knowledge ethically and lawfully. By accessing this repository, you agree to use its contents responsibly and in accordance with all applicable laws.

## Description (Keynote)

This Cookbook was created with the main purpose of helping people understand local privilege escalation techniques on Windows environments. Moreover, it can be used for both attacking and defensive purposes.

:information_source: This Cookbook focuses only on misconfiguration vulnerabilities on Windows workstations/servers/machines.

:warning: Evasion techniques to bypass security protections, endpoints, and antivirus are not included in this cookbook. I created this PowerShell script, [TurnOffAV.ps1](/Lab-Setup-Scripts/TurnOffAV.ps1), which permanently disables Windows Defender. Run this with local Administrator privileges.

The main structure of this Cookbook includes the following sections for any vulnerability:

- Description
- Lab Setup
- Enumeration
- Exploitation
- Mitigation
- (Useful) References

I hope to find this CookBook useful and learn new stuff 😉.

## Definition

Local Privilege Escalation, also known as LPE, refers to the process of elevating user privileges on a computing system or network beyond what is intended, granting unauthorized access to resources or capabilities typically restricted to higher privilege levels. This process occurs when attackers exploit weaknesses, vulnerabilities, or misconfigurations within the operating system, applications, or device drivers. By exploiting these flaws, attackers can bypass security controls and escalate their privileges, potentially gaining control over the system and accessing sensitive data.

## Useful Tools

In the following table, some popular and useful tools for Windows local privilege escalation are presented:

| Name | Language | Author | Description |
|:-----------:|:-----------:|:-----------:|:-----------:|
| [SharpUp](https://github.com/GhostPack/SharpUp) | C# | [@harmj0y](https://twitter.com/harmj0y) | SharpUp is a C# port of various PowerUp functionality |
| [PowerUp](https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1) | PowerShell | [@harmj0y](https://twitter.com/harmj0y) | PowerUp aims to be a clearinghouse of common Windows privilege escalation |
| [BeRoot](https://github.com/AlessandroZ/BeRoot) | Python | [AlessandroZ](https://github.com/AlessandroZ) | BeRoot(s) is a post exploitation tool to check common Windows misconfigurations to find a way to escalate our privilege |
| [Privesc](https://github.com/enjoiz/Privesc) | PowerShell | [enjoiz](https://github.com/enjoiz) | Windows PowerShell script that finds misconfiguration issues which can lead to privilege escalation |
| [Winpeas](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS/winPEASexe) | C# | [@hacktricks_live](https://twitter.com/hacktricks_live) | Windows local Privilege Escalation Awesome Script |
| [PrivescCheck](https://github.com/itm4n/PrivescCheck) | PowerShell | [@itm4n](https://twitter.com/itm4n) | Privilege Escalation Enumeration Script for Windows |
| [PrivKit](https://github.com/mertdas/PrivKit) | C (Applicable for Cobalt Strike) | [@merterpreter](https://twitter.com/merterpreter) | PrivKit is a simple beacon object file that detects privilege escalation vulnerabilities caused by misconfigurations on Windows OS |

## Vulnerabilities

This Cookbook presents the following Windows vulnerabilities:

- [AlwaysInstallElevated](/Notes/AlwaysInstallElevated.md)
- [Answer files (Unattend files)](/Notes/AnswerFiles.md)
- [Logon Autostart Execution (Registry Run Keys)](/Notes/LogonAutostartExecutionRegistryRunKeys.md)
- [Logon Autostart Execution (Startup Folder)](/Notes/LogonAutostartExecutionStartupFolder.md)
- [Leaked Credentials (GitHub Repository)](/Notes/LeakedCredentialsGitHubRepository.md)
- [Leaked Credentials (Hardcoded Credentials)](/Notes/LeakedCredentialsHardcodedCredentials.md)
- [Leaked Credentials (PowerShell History)](/Notes/LeakedCredentialsPowerShellHistory.md)
- [SeBackupPrivilege](/Notes/SeBackupPrivilege.md)
- [SeImpersonatePrivilege](/Notes/SeImpersonatePrivilege.md)
- [Stored Credentials (Runas)](/Notes/StoredCredentialsRunas.md)
- [UAC Bypass](/Notes/UACBypass.md)
- [Unquoted Service Path](/Notes/UnquotedServicePath.md)
- [Weak Service Binary Permissions](/Notes/WeakServiceBinaryPermissions.md)
- [Weak Service Permissions](/Notes/WeakServicePermissions.md)
- [Weak Registry Permissions](/Notes/WeakRegistryPermissions.md)

## References

- [Privilege Escalation Wikipedia](https://en.wikipedia.org/wiki/Privilege_escalation)
- [SharpCollection GitHub by Flangvik](https://github.com/Flangvik/SharpCollection)
- [Metasploit Official Website](https://www.metasploit.com/)
- [CrackMapExec GitHub by byt3bl33d3r](https://github.com/byt3bl33d3r/CrackMapExec)
- [NetExec GitHub by Pennyw0rth](https://github.com/Pennyw0rth/NetExec)
- [Evil-WinRM GitHub by Hackplayers](https://github.com/Hackplayers/evil-winrm)
- [Windows Privilege Escalation Youtube Playlist by Conda](https://www.youtube.com/watch?v=WWE7VIpgd5I&list=PLDrNMcTNhhYrBNZ_FdtMq-gLFQeUZFzWV&index=13)
- [Windows Privilege Escalation by Bordergate](https://www.bordergate.co.uk/windows-privilege-escalation/)
- [Seatbelt GitHub by GhostPack](https://github.com/GhostPack/Seatbelt)
- [Sysinternals Suite Microsoft](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite)
- [Impacket GitHub by Forta](https://github.com/fortra/impacket)
- [dnSpy GitHub by dnSpyEx](https://github.com/dnSpyEx/dnSpy)
- [Java Decompiler Official Website](https://java-decompiler.github.io)
- [CS-Situational-Awareness-BOF GitHub by TrustedSec](https://github.com/trustedsec/CS-Situational-Awareness-BOF)
- [HavocFramework GitHub by C5pider](https://github.com/HavocFramework/Havoc)
