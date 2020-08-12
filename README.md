# Win_Priv_Esc_Method
Windows Privilege Escalation Methodology

# Categories
* Stored Credentials
* Windows Kernel Exploit
* DLL Injection
* Unattended Answer File
* Insecure File/Folder Permissions
* Insecure Service Permissions
* DLL Hijacking
* Group Policy Preferences
* Unquoted Service Path
* Always Install Elevated
* Token Manipulation
* Insecure Registry Permissions
* Autologon User Credential
* User Account Control (UAC) Bypass
* Insecure Named Pipes Permissions

## General
* systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"Processor(s)" /C:"System Locale" /C:"Input Locale" /C:"Domain" /C:"Hotfix(s)"
* WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors

* whoami
* whoami /priv
  * SeDebugPrivilege
  * SeRestorePrivilege
  * SeBackupPrivilege
  * SeTakeOwnershipPrivilege
  * SeTcbPrivilege
  * SeCreateToken Privilege
  * SeLoadDriver Privilege
  * SeImpersonate & SeAssignPrimaryToken Priv.

* whoami /groups

* net user
* net user <user>

* netstat -ano
* ipconfig /all
* route print

* tasklist /SVC > tasks.txt
* schtasks /query /fo LIST /v > schedule.txt

* netsh advfirewall show currentprofile
* netsh advfirewall firewall show rule name=all


* wmic product get name, version, vendor > apps_versions.txt
* DRIVERQUERY
* mountvol

* accesschk-2008-vista.exe /accepteula
* accesschk-2008-vista.exe -uws "Everyone" "C:\Program Files"

* reg query HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer
* reg query HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer
