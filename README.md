# Windows Local Privilege Escalation CookBook
<p align="center">
  <img src="/Pictures/Windows-Funny.jpg">
</p>

## Description (Keynote)

This CookBook was created with the main purpose of helping people understand local privilege escalation techniques on Windows environments. Moreover, it can be used for both attacking and defensive purposes.

:information_source: This CookBook focuses only on misconfiguration vulnerabilities on Windows workstations.

The main structure of this CookBook includes the following sections:

- Description (of the vulnerability)
- Lab Setup
- Attacking
- Mitigation
- Detection
- (Useful) References

I hope to find this CookBook useful and learn new stuff 😉.

## Table of Contents

- [Windows Local Privilege Escalation CookBook](#windows-local-privilege-escalation-cookbook)
  - [Description (Keynote)](#description-keynote)
  - [Table of Contents](#table-of-contents)
  - [Useful Tools](#useful-tools)
  - [Vulnerabilities](#vulnerabilities)
    - [AlwaysInstallElevated](#alwaysinstallelevated)
      - [Description](#description)
      - [Lab Setup](#lab-setup)
  - [References](#references)

## Useful Tools

In the following table, some popular and useful tools for Windows local privilege escalation are presented:

| Name | Language | Description |
| ---- |:-----------:|:-----------:|
| [SharpUp](https://github.com/GhostPack/SharpUp) | C# | SharpUp is a C# port of various PowerUp functionality |
| [PowerUp](https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1) | PowerShell | PowerUp aims to be a clearinghouse of common Windows privilege escalation |
| [BeRoot](https://github.com/AlessandroZ/BeRoot) | Python | BeRoot(s) is a post exploitation tool to check common Windows misconfigurations to find a way to escalate our privilege |
| [Privesc](https://github.com/enjoiz/Privesc) | PowerShell | Windows PowerShell script that finds misconfiguration issues which can lead to privilege escalation |

## Vulnerabilities

This CookBook presents the following Windows vulnerabilities:

- [AlwaysInstallElevated](#alwaysinstallelevated)

### AlwaysInstallElevated

#### Description

"AlwaysInstallElevated" is a Windows Registry setting that affects the behavior of the Windows Installer service. The vulnerability arises when the "AlwaysInstallElevated" registry key is configured with a value of "1" in the Windows Registry.

When this registry key is enabled, it allows non-administrator users to install software packages with elevated privileges. In other words, users who shouldn't have administrative rights can exploit this vulnerability to execute arbitrary code with elevated permissions, potentially compromising the security of the system.

#### Lab Setup

## References

- [Privilege Escalation Wikipedia](https://en.wikipedia.org/wiki/Privilege_escalation)