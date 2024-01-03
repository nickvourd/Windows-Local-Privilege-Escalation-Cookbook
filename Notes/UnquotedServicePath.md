# Unquoted Service Path

## Table of Contents

- [Unquoted Service Path](#unquoted-service-path)
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

The unquoted service path vulnerability in Windows occurs when services are installed using paths containing spaces without proper quotation marks. If attackers obtain write permissions in the service's installation directory, they can execute malicious code with elevated privileges.

In Windows, when a file path contains spaces and isn't enclosed within quotation marks, the operating system assumes the file's location based on predetermined rules.

This process involves checking potential paths in a sequence similar to the following:

1) C:\Program.exe

2) C:\Program Files\Vulnerable.exe

3) C:\Program Files\Vulnerable Service1\Custom.exe

4) C:\Program Files\Vulnerable Service\Custom Srv1\App1_AMD64.exe (Finally arriving at the specified path)

## Lab Setup

### Manual Lab Setup

1) Open a PowerShell with local Administrator privileges and run the following command to create a new folder with a subfolder:

```
mkdir "C:\Program Files\Vulnerable Service1\Custom Srv1"
```
2) Download the file [App1.exe](/Lab-Setup-Binary/App1.exe) to the 'C:\Program Files\Vulnerable Service1\Custom Srv1' directory.

3) Grant writable privileges to BUILTIN\Users for the "Vulnerable Service1" folder:

```
$folderPath = 'C:\Program Files\Vulnerable Service1'
$permission = 'BUILTIN\Users'
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission, 'Modify', 'ObjectInherit, ContainerInherit', 'None', 'Allow')
$acl = Get-Acl -Path $folderPath
$acl.SetAccessRule($rule)
Set-Acl -Path $folderPath -AclObject $acl
```

4) Create a Windows service named "Vulnerable Service 1" with a specified executable path:

```
sc create "Vulnerable Service 1" binpath= "C:\Program Files\Vulnerable Service\Custom Srv1\App1_AMD64.exe" Displayname= "Vuln Service 1" start= auto
```

Outcome:

![Unquoted-Service-Path-Manual-Lab-Setup](/Pictures/Unquoted-Service-Path-Manual-Lab-Setup.png)

5) Verify the new vulnerable service (services.msc):

![Unquoted-Service-Path-Manual-Lab-Setup-Verify](/Pictures/Unquoted-Service-Path-Manual-Lab-Setup-Verify.png)

6) You can start the service manually from the service panel or reboot the machine because this vulnerable service starts automatically after the machine boots.

### PowerShell Script Lab Setup

To set up the lab with the 'Unquoted Service Path' vulnerability is by using the custom PowerShell script named [UnquotedServicePath.ps1](/Lab-Setup-Scripts/UnquotedServicePath.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\UnquotedServicePath.ps1
```

Outcome:

![Unquoted-Service-Path-Script-Lab-Setup](/Pictures/Unquoted-Service-Path-Script-Lab-Setup.png)

## Enumeration

### Manual Enumeration

To perform manual enumeration, you can open a command prompt and use the following command to check if there is a service application vulnerable to an Unquoted Service Path:

```
wmic service get name,pathname,displayname,startmode | findstr /i auto | findstr /i /v "C:\Windows\\" | findstr /i /v """
```

Outcome:

![Unquoted-Service-Manual-Enumeration](/Pictures/Unquoted-Service-Manual-Enumeration.png)

### Tool Enumeration

To run the SharpUp tool and perform an enumeration of the `Unquoted Service Path` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit UnquotedServicePath
```

Outcome:



## References

- [Fix Windows Unquoted Service Path Vulnerability by isgovern](https://isgovern.com/blog/how-to-fix-the-windows-unquoted-service-path-vulnerability/)
- [Unquoted Service Paths by CyberTec](https://kb.cybertecsecurity.com/knowledge/unquoted-service-paths)
- [FixUnquotedPaths GitHub by NetSecJedi](https://github.com/NetSecJedi/FixUnquotedPaths)
