# DLL Hijacking

## Table of Contents

- [DLL Hijacking](#dll-hijacking)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

DLL Hijacking is a type of attack where an attacker exploits the dynamic link library (DLL) search order used by operating systems like Windows to load a malicious DLL instead of the intended one. This attack leverages the fact that when an application attempts to load a DLL without specifying a path, the operating system searches for the DLL in a predefined sequence of directories, including the application's directory, system directories, and directories listed in the system's PATH environment variable.

## Lab Setup

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

Open PowerShell with local Administrator privileges, run the [ExplorerSuite.exe](/Lab-Setup-Binary/ExplorerSuite.exe) installer, and continue clicking 'Next' until the installation is complete:

```
.\ExplorerSuite.exe
```

Outcome:

![Dll-Hijacking-Manual-Setup](/Pictures/Dll-Hijacking-Manual-Setup.png)

## Enumeration