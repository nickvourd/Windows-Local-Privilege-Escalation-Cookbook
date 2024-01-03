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

In Windows, when referencing file paths that contain spaces and are not enclosed within quotation marks, the system assumes the file's location using a specific set of rules.

This process involves checking potential paths in a sequence similar to the following:

1) C:\Program.exe

2) C:\Program Files\Vulnerable.exe

3) C:\Program Files\Vulnerable Service1\Custom.exe

4) C:\Program Files\Vulnerable Service\Custom Srv1\App1.exe (Finally arriving at the specified path)

## Lab Setup

### Manual Lab Setup

1) Open a PowerShell with local Administrator privileges and run the following command to create a new folder with a subfolder:

```
mkdir "C:\Program Files\Vulnerable Service\Custom Srv1"
```
2) Download the file App1.exe to the 'C:\Program Files\Vulnerable Service\Custom Srv1' directory.

3) Grant writable privileges to BUILTIN\Users for the "Vulnerable Service" folder:

```
icacls "C:\Program Files\Vulnerable Service" /grant BUILTIN\Users:(OI)(CI)M /T /inheritance:r
```

4) Create a Windows service named "Vulnerable Service 1" with a specified executable path:

```
sc create "Vulnerable Service 1" binpath= "C:\Program Files\Vulnerable Service\Custom Srv1\App1.exe" Displayname= "Vuln Service 1" start= auto
```

Outcome:
