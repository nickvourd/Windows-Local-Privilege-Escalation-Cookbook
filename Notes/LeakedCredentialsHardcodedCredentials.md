# Leaked Credentials (Hardcoded Credentials)

## Table of Contents

- [Leaked Credentials (Hardcoded Credentials)](#leaked-credentials-hardcoded-credentials)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
    - [Manual Lab Setup (.NET App)](#manual-lab-setup-net-app)
    - [PowerShell Script Lab Setup (.NET App)](#powershell-script-lab-setup-net-app)
    - [Manual Lab Setup (Java App)](#manual-lab-setup-java-app)
    - PowerShell Script Lab Setup (Java App)
  - [Enumeration](#enumeration)
    - [Enumeration (.NET App)](#enumeration-net-app)
    - Enumeration (Java App)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

Hardcoded Credentials occurs when sensitive credentials, such as usernames, passwords, API keys, or cryptographic keys, are embedded directly into the source code or configuration files of an application. These credentials are often stored in plaintext, making them easily accessible to anyone who can view or obtain the source code of the application.

An adversary can leverage hardcoded credentials to escalate to elevated privileges.

## Lab Setup

### Manual Lab Setup (.NET App)

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

1)  Open a PowerShell with local Administrator privileges and run the following command to create a new folder:

```
mkdir "C:\Program Files\CustomDotNetApp\"
```

2) Download the file [CustomDotNetApp.exe](/Lab-Setup-Binary/CustomDotNetApp.exe) to the 'C:\Program Files\CustomDotNetApp' directory.

3) Install the new Service:

```
New-Service -Name "Custom Dot Net Service" -BinaryPathName "C:\Program Files\CustomDotNetApp\CustomDotNetApp.exe" -DisplayName "Custom .NET Service" -Description "My Custom .NET Service" -StartupType Automatic
```

Outcome:

![Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp](/Pictures/Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp.png)

4) Verify the new service (services.msc):

![Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp-Verify-Service](/Pictures/Hardcoded-Creds-Manual-Lab-Set-Up-DotNetApp-2.png)

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Custom Dot Net Service"
```

### PowerShell Script Lab Setup (.NET App)

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

To set up the lab with the 'Hardcoded Credentials (.NET App)' scenario use the custom PowerShell script named [HardcodedCredentialsDotNetApp.ps1](/Lab-Setup-Scripts/HardcodedCredentialsDotNetApp.ps1).

1) Open a PowerShelll with local Administrator privileges and run the script:

```
.\HardcodedCredentialsDotNetApp.ps1
```

Outcome:

![Hardcoded-Creds-Script-Lab-Set-Up-DotNetApp](/Pictures/Hardcoded-Creds-Script-Lab-Set-Up-DotNetApp.png)

2) Reboot the machine due to the service is set to start automatically upon machine boot.

:information_source: If you want to unistall the new service use the following command:

```
Remove-Service -Name "Custom Dot Net Service"
```

### Manual Lab Setup (Java App)

:warning: <b>If you are using Windows 10/11 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

:warning: <b>In order to run this scenario, Java must be installed on the target workstation. You can download and install Java from the [Official Oracle Website](https://www.oracle.com/java/technologies/downloads/#jdk21-windows).</b>

## Enumeration

:information_source: The binaries of most custom applications commonly exist in `C:\Program Files\` or `C:\Program Files (x86)\`.

### Enumeration (.NET App)

After locating the directory of a custom corporate binary, download it onto your attacking machine and open it in [dnSpy](https://github.com/dnSpyEx/dnSpy).

Go to `Assembly Explorer` -> `CustomDotNetApp (1.0.0.0)` (Assembly) -> `CustomDotNetApp.exe` -> `CustomDotNetApp` (Namespace) -> `Service1` (Class) -> `Authenticate` (Method).

Outcome:

![Hardcoded-Creds-Enumeration-DotNetApp](/Pictures/Hardcoded-Creds-Enumeration-Up-DotNetApp.png)

## Exploitation

Obtaining the hardcoded credentials can be accomplished through several methods, which you can then utilize to elevate privileges if these credentials are valid.

Some of the common services are:

- Remote Desktop Protocol (RDP)
- Windows Remote Management (WinRM) (If it is enabled)
- Server Message Block (SMB)
- Windows Management Instrumentation (WMI)
- Virtual Network Computing (VNC) (If it is enabled)

To identify a valid authentication method, you can use [NetExec](https://github.com/Pennyw0rth/NetExec).

This is an example of using the SMB service to authenticate against the workstation and execute a command:

```
nxc smb <ip> -u <username> -p '<password>' -x whoami
```

Outcome:

![Hardcoded-Credentials-Exploitation](/Pictures/Hardcoded-Credentials-Exploitation.png)

## Mitigation

To enhance the security of the application, it's advisable to remove hardcoded credentials from the source code. If that's not feasible, strong cryptographic ciphers should be used to encrypt the credentials rather than storing them in plaintext.

Moreover, you can apply the above steps to harden your .NET/Java application against reverse engineering:

- Obfuscate your code.
- Utilize public/private key or asymmetric encryption to generate product licenses, ensuring exclusive control over license generation. Even if the application is cracked, the key generation algorithm remains unrecoverable, preventing unauthorized license generation.
- Use a third-party packer to pack your executable into an encrypted Win32 wrapper application or write your custom packer.

## References

- [Use of hard-coded password by OWASP](https://owasp.org/www-community/vulnerabilities/Use_of_hard-coded_password)
- [Use of Hard-coded Credentials by CWE Mitre](https://cwe.mitre.org/data/definitions/798.html)
- [Protect .NET code from reverse engineering by Stackoverflow](https://stackoverflow.com/questions/506282/protect-net-code-from-reverse-engineering)
- [Protect Your Java Code from Reverse Engineering by The Geek Stuff](https://www.thegeekstuff.com/2008/06/protect-your-java-code-from-reverse-engineering/)
- [Create and execute a jar file by Tecmint](https://www.tecmint.com/create-and-execute-jar-file-in-linux/)
