# Leaked Credentials (GitHub Repository)

## Table of Contents

- [Leaked Credentials (GitHub Repository)](#leaked-credentials-github-repository)
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

When developers work on projects, they often use version control systems like Git to manage changes to their codebase. GitHub is a widely used platform for hosting Git repositories, allowing developers to collaborate on projects and track changes over time. However, sometimes developers accidentally include sensitive information in their code commits, such as hardcoded credentials or API keys, which can then be exposed publicly on GitHub if not handled properly.

In this scenario, the focus shifts from public GitHub repositories to instances where GitHub repositories exist on workstations or servers, rather than being publicly hosted.

## Lab Setup

### Manual Lab Setup