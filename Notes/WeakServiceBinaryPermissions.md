# Weak Service Binary Permissions

## Table of Contents

- [Weak Service Binary Permissions](#weak-service-binary-permissions)
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

Weak Service Binary Permissions indicate a vulnerability due to insufficient permissions on service executables. This vulnerability can be exploited by an adversary to modify the service executable, granting unauthorized access or potentially elevating system privileges.

## Lab Setup

### Manual Lab Setup

1) Open a PowerShell with local Administrtor Privileges and use the following command to create a new folder:

```
mkdir C:\Program Files\CustomSrv2\
```

2) Download the file [Service2.exe](/Lab-Setup-Binary/Service2.exe) to the 'C:\Program Files\CustomSrv2' directory.

3) Grant write privileges to BUILTIN\Users for the 'Service2.exe' binary:

```
icacls "C:\Program Files\CustomSrv2\Service2.exe" /grant BUILTIN\Users:W
```

4) Install the new Service:

```
New-Service -Name "Vulnerable Service 2" -BinaryPathName "C:\Program Files\CustomSrv2\Service2.exe" -DisplayName "Vuln Service 2" -Description "My Custom Vulnerable Service 2" -StartupType Automatic
```

Outcome:

5) Verify the new service (services.msc):

6) Manually start the service from the service panel, or reboot the machine due to the service is set to start automatically upon machine boot.
