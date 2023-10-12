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
- Enumeration
- Attacking
- Mitigation
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
      - [Enumeration](#enumeration)
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

##### Manual Lab Setup

Open a cmd with local Administrator privileges and type `gpedit.msc` to open the Local Group Policy Editor.

1) Navigate to **Computer Configuration** -> **Administrative Templates** -> **Windows Components** -> **Windows Installer**:

![AlwaysInstallElevated-Computer-Configuratior-1](/Pictures/AllwaysInstallElevated-Computer-1.png)

2) Enable the "**Always install with elevated privileges**" policy:

![AlwaysInstallElevated-Computer-Configuratior-2](/Pictures/AllwaysInstallElevated-Computer-2.png)

3) Confirm that the "**Always install with elevated privileges**" policy is set to **Enabled**:

![AlwaysInstallElevated-Computer-Configuratior-3](/Pictures/AllwaysInstallElevated-Computer-3.png)

4) Then, navigate to **User Configuration** -> **Administrative Templates** -> **Windows Components** -> **Windows Installer**:

![AlwaysInstallElevated-User-Configuratior-4](/Pictures/AllwaysInstallElevated-User-4.png)

5) Enable the "**Always install with elevated privileges**" policy:

![AlwaysInstallElevated-User-Configuratior-5](/Pictures/AllwaysInstallElevated-User-5.png)

6) Confirm that the "**Always install with elevated privileges**" policy is set to **Enabled**:

![AlwaysInstallElevated-User-Configuratior-6](/Pictures/AllwaysInstallElevated-User-6.png)

##### PowerShell Script Lab Setup 

Another way to set up the lab with the 'AlwaysInstallElevated' vulnerability is by using the custom PowerShell script named [AlwaysInstallElevated.ps1](/Lab-Setup-Scripts/AlwaysInstallElevated.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\AlwaysInstallElevated.ps1
```

Outcome:

![AlwaysInstallElevated-Lab-Setup-Script](/Pictures/AllwaysInstallElevated-Lab-Setup-Script.png)

#### Enumeration

##### Manual Enumeration

##### Tool Enumeration

## References

- [Privilege Escalation Wikipedia](https://en.wikipedia.org/wiki/Privilege_escalation)