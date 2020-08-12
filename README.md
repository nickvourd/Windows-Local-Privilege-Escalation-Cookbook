# Win_Priv_Esc_Method
Windows Privilege Escalation Methodology

## General
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"Processor(s)" /C:"System Locale" /C:"Input Locale" /C:"Domain" /C:"Hotfix(s)"
WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors

whoami
whoami /priv
  * SeDebugPrivilege
  * SeRestorePrivilege
  * SeBackupPrivilege
  * SeTakeOwnershipPrivilege
  * SeTcbPrivilege
  * SeCreateToken Privilege
  * SeLoadDriver Privilege
  * SeImpersonate & SeAssignPrimaryToken Priv.

whoami /groups

net user
net user <user>

netstat -ano
ipconfig /all
route print


netsh advfirewall show currentprofile
netsh advfirewall firewall show rule name=all


tasklist /SVC > tasks.txt
schtasks /query /fo LIST /v > schedule.txt

wmic product get name, version, vendor > apps_versions.txt

accesschk-2008-vista.exe /accepteula
accesschk-2008-vista.exe -uws "Everyone" "C:\Program Files"
