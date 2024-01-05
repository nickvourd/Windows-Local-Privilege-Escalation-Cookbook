# Weak Registry Permissions

## Table of Contents

- [Weak Registry Permissions](#weak-registry-permissions)
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

Weak registry permissions represent a vulnerability within the Windows registry resulting from misconfigured access controls. This issue involves specific registry keys or entries having permissions that permit unauthorized users to manipulate or access crucial system configurations. This vulnerability can be exploited by attackers who inject malicious code into registry keys, thus obtaining unauthorized privileged access.

## Lab Setup

### Manual Lab Setup

