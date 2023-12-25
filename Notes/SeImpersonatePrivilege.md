# SeImpersonatePrivilege

## Table of Contents

- [SeImpersonatePrivilege](#SeImpersonatePrivilege)
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

The SeImpersonatePrivilege is a Windows privilege that grants a user or process the ability to impersonate the security context of another user or account. This privilege allows a process to assume the identity of a different user, enabling it to perform actions or access resources as if it were that user.

However, if not properly managed or granted to unauthorized users or processes, the SeImpersonatePrivilege can pose a significant security risk. The SeImpersonatePrivilege vulnerability can be exploited by malicious actors to conduct various attacks and gain unauthorized access on a system.

## Lab Setup

### Manual Lab Setup

:warning: <b>For this scenario, it is recommended to use Windows Server 2019 (Build 17763) rather than Windows 10/11.</b>

1) Authenticate to the server as the local Administrator.

2) Open a PowerShell and use the following command to create a new user:

```
net user ncv2 Passw0rd! /add
```

3) Then, open the "Server Manager" and select the option named "Add roles and features":

![SeImpersonatePrivilege-Labsetup-Manual-1](/Pictures/SeImpersonatePrivilege-Labsetup-Manual-1.png)

4) Press the "Next" button until you reach the "Server Roles" section:

![SeImpersonatePrivilege-Labsetup-Manual-2](/Pictures/SeImpersonatePrivilege-Labsetup-Manual-2.png)

5) Add the role named "Web Server (IIS)" and then press the button named "Add Features":

![SeImpersonatePrivilege-Labsetup-Manual-3](/Pictures/SeImpersonatePrivilege-Labsetup-Manual-3.png)

6) Press "Next", and in section named "Features" add the followings:
   - ASP.NET 4.7
   - WCF Services (1 of 5 installed)
     - HTTP Activation
    
Outcome:

![SeImpersonatePrivilege-Labsetup-Manual-4](/Pictures/SeImpersonatePrivilege-Labsetup-Manual-4.png)

7) Press "Next" until you reach the "Confirmation" section. In this section, check the checkbox for "Automatically restart":

![SeImpersonatePrivilege-Labsetup-Manual-5](/Pictures/SeImpersonatePrivilege-Labsetup-Manual-5.png)

8) Finally, press the "Install" button.

![SeImpersonatePrivilege-Labsetup-Manual-6](/Pictures/SeImpersonatePrivilege-Labsetup-Manual-6.png)
