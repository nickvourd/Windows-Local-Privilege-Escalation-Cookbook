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

2) Open a Command Prompt (cmd) and use the following command to create a new user:

```
net user ncv2 Passw0rd! /add
```

3) Run the following command to enable WinRM service:

```
Enable-PSRemoting -Force
```
