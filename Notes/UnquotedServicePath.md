# Unquoted Service Path

## Table of Contents

- [Unquoted Service Path](#unquoted-service-path)
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

The unquoted service path vulnerability in Windows occurs when services are installed using paths containing spaces without proper quotation marks. If attackers obtain write permissions in the service's installation directory, they can execute malicious code with elevated privileges.

In Windows, when a file path contains spaces and isn't enclosed within quotation marks, the operating system assumes the file's location based on predetermined rules.

This process involves checking potential paths in a sequence similar to the following:

1) C:\Program.exe

2) C:\Program Files\Vulnerable.exe

3) C:\Program Files\Vulnerable Service1\App.exe

4) C:\Program Files\Vulnerable Service1\App 1.exe (Finally arriving at the specified path)


## References

- [Fix Windows Unquoted Service Path Vulnerability by isgovern](https://isgovern.com/blog/how-to-fix-the-windows-unquoted-service-path-vulnerability/)
- [Unquoted Service Paths by CyberTec](https://kb.cybertecsecurity.com/knowledge/unquoted-service-paths)
- [FixUnquotedPaths GitHub by NetSecJedi](https://github.com/NetSecJedi/FixUnquotedPaths)
