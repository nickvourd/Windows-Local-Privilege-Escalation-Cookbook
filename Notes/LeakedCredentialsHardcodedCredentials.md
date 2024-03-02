# Leaked Credentials (Hardcoded Credentials)

## Table of Contents

- [Leaked Credentials (Hardcoded Credentials)](#leaked-credentials-hardcoded-credentials)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
    - [Manual Lab Setup (.NET App)](#manual-lab-setup-net-app)
    - [PowerShell Script Lab Setup (.NET App)](#powershell-script-lab-setup-net-app)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

Hardcoded Credentials occurs when sensitive credentials, such as usernames, passwords, API keys, or cryptographic keys, are embedded directly into the source code or configuration files of an application. These credentials are often stored in plaintext, making them easily accessible to anyone who can view or obtain the source code of the application.

An adversary can leverage hardcoded credentials to escalate to elevated privileges.

## Lab Setup

### Manual Lab Setup (.NET App)

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

1)  Open a PowerShell with local Administrator privileges and run the following command to create a new folder:

```
mkdir "C:\Program Files\CustomDotNetApp\"
```

2) Download the file [CustomDotNetApp.exe](/Lab-Setup-Binary/CustomDotNetApp.exe) to the 'C:\Program Files\CustomDotNetApp' directory.

3) Install the new Service:

```
New-Service -Name "Custom Dot Net Service" -BinaryPathName "C:\Program Files\CustomDotNetApp\CustomDotNetApp.exe" -DisplayName "Custom .NET Service" -Description "My Custom .NET Service" -StartupType Automatic
```

Outcome:

![Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp](/Pictures/Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp.png)

4) Verify the new service (services.msc):

![Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp-Verify-Service](/Pictures/Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp-2.png)