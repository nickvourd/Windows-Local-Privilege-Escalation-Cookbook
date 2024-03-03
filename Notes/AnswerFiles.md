# Answer files (Unattend files)

## Table of Contents

- [Answer files (Unattend files)](#answer-files-unattend-files)
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

Unattend files, also commonly referred to as "Answer files" in the context of Windows installations, are XML-based configuration files aimed at optimizing the installation process. These files contain an extensive range of settings and configurations, empowering unattended or automated installation procedures.

An adversary could potentially exploit Unattend files by reading their contents to obtain encoded passwords and gain unauthorized access to privileged accounts or sensitive resources.

The following locations commonly contain answer files that may include local administrator credentials:

- `C:\Windows\Panther\unattend.xml`
- `C:\Windows\Panther\Unattend\unattend.xml`
- `C:\Windows\System32\Sysprep\unattend.xml`
- `C:\Windows\System32\Sysprep\sysprep.xml`
- `C:\Windows\System32\Sysprep\Panther\unattend.xml`
- `C:\Windows\sysprep.inf`
- `C:\Windows\unattend.xml`
- `C:\unattend.xml`
- `C:\sysprep.inf`

## Lab Setup

### Manual Lab Setup

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

1) Open a PowerShell with local Administrator privileges and run the following command to create a new folder:

```
mkdir "C:\Windows\Panther\Unattend\"
```

2) Download the file [unattend.xml](/Lab-Setup-Source-Code/unattend.xml) to the 'C:\Windows\Panther\Unattend\' directory.

Outcome:

![Answer-Files-Manual-Lab-Set-Up](/Pictures/Answer-Files-Manual-Lab-Set-Up.png)

### PowerShell Script Lab Setup

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

