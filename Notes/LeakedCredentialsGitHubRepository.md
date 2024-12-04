# Leaked Credentials (GitHub Repository)

[Back to Main](https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook?tab=readme-ov-file#vulnerabilities)

## Table of Contents

- [Leaked Credentials (GitHub Repository)](#leaked-credentials-github-repository)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Lab Setup](#lab-setup)
  - [Enumeration](#enumeration)
  - [Exploitation](#exploitation)
  - [Mitigation](#mitigation)
  - [References](#references)

## Description

When developers work on projects, they often use version control systems like Git to manage changes to their codebase. GitHub is a widely used platform for hosting Git repositories, allowing developers to collaborate on projects and track changes over time. However, sometimes developers accidentally include sensitive information in their code commits, such as hardcoded credentials or API keys, which can then be exposed publicly on GitHub if not handled properly.

In this scenario, the focus shifts from public GitHub repositories to instances where GitHub repositories exist on workstations or servers, rather than being publicly hosted.

## Lab Setup

:warning: <b>If you are using Windows 10 to proceed with this scenario, the local Administrator account needs to be enabled. I have created a PowerShell script named [EnableLocalAdmin.ps1](/Lab-Setup-Scripts/EnableLocalAdmin.ps1), designed to enable the local Administrator account and set a password. Please run this script with elevated privileges.</b>

:warning: <b>For this scenario, you will need to install the Git tool from the [Official Website](https://git-scm.com/downloads).</b>

Open a PowerShell with local Administrator privileges and run the following command to clone the scenario repository:

```
git clone https://github.com/nickvourd/Demo-App.git
```

## Enumeration

When you identify a folder containing a `.git` directory, it signifies that the folder is a Git repository. One way to enumerate a GitHub repository, besides reading the `source code` of files within it, is to explore its history and inspect past commits.

1) View the IDs of all commits by using the following command:
```
git log
```

Outcome:

![Github-Enumeration-Commits-Log-History](/Pictures/Github-Enumeration.png)

2) Compare the commit IDs to identify the changes in the code:

```
git diff <commit-id-1> <commit-id-2>
```

Outcome:

![Github-Enumeration-Compare-Commmits](/Pictures/Github-Enumeration-2.png)

:information_source: However, you can use the following command to show the changes in the most recent commit:

```
git show
```

Outcome:

![Github-Enumeration-Show-Recent-Commit-Changes](/Pictures/Github-Enumeration-3.png)

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

If credentials have been accidentally committed to the repository, consider rewriting history to remove them entirely. Tools like `git filter-branch` or `git filter-repo` can help sanitize the commit history.

Moreover, create a `.gitignore` file and include patterns for files or directories that contain sensitive information. This prevents them from being accidentally committed to the repository.

Last but not least, change the leaked account credentials immediately.

## References

- [Git diff Documentation](https://git-scm.com/docs/git-diff)
- [Remove sensitive files and their commits from Git history by Stackoverflow](https://stackoverflow.com/questions/872565/remove-sensitive-files-and-their-commits-from-git-history)
- [Why secrets in git are such a problem - Secrets in source code by Gitguardian](https://blog.gitguardian.com/secrets-credentials-api-git/)
