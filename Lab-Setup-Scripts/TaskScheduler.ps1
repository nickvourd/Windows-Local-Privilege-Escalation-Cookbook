$global:version = "1.0.0"

$ascii = @"

.____                        .__            .____          ___.     _________       __                
|    |    ____   ____ _____  |  |           |    |   _____ \_ |__  /   _____/ _____/  |_ __ ________  
|    |   /  _ \_/ ___\\__  \ |  |    ______ |    |   \__  \ | __ \ \_____  \_/ __ \   __\  |  \____ \ 
|    |__(  <_> )  \___ / __ \|  |__ /_____/ |    |___ / __ \| \_\ \/        \  ___/|  | |  |  /  |_> >
|_______ \____/ \___  >____  /____/         |_______ (____  /___  /_______  /\___  >__| |____/|   __/ 
        \/          \/     \/                       \/    \/    \/        \/     \/           |__|    

~ Created with <3 by @nickvourd
~ Version: $global:version
~ Type: Task Scheduler

"@

Write-Host $ascii

# Set the path for the Jobs folder
$folderPath = "C:\Jobs"

# Check if the folder already exists
if (-not (Test-Path $folderPath)) {
    # Create the folder
    New-Item -Path $folderPath -ItemType Directory
    Write-Host "[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

# Set the path for the file to be moved
$filePath = "C:\Jobs\Monitor_AMD64.exe"

# Download binary file
Invoke-WebRequest -Uri "https://github.com/nickvourd/Windows-Local-Privilege-Escalation-CheatSheet/blob/dev/Lab-Setup-Binary/Monitor_AMD64.exe" -OutFile $filePath

# Check if the file exists
if (Test-Path $filePath) {
    # Move the file to the Jobs folder
    Move-Item -Path $filePath -Destination $folderPath
    Write-Host "[+] File moved successfully to $folderPath`n"
} else {
    Write-Host "[!] File not found at $filePath`n"
}

# Define task parameters
$taskName = "MagicTask"
$description = "Magic Task Scheduler"
$actionPath = "C:\Jobs\Monitor_AMD64.exe"
$triggerInterval = New-TimeSpan -Minutes 5

# Create the task action
$action = New-ScheduledTaskAction -Execute $actionPath

# Create a trigger for the task
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval $triggerInterval -RepetitionDuration (New-TimeSpan -Days 365)

# Register the scheduled task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Description $description -RunLevel Highest -User "SYSTEM"

# Verify that the task was created
Get-ScheduledTask -TaskName $taskName

Write-Host "[+] Scheduled Task has been set successfully`n"

# Add permission for all built-in users to write to C:\Jobs folder
$acl = Get-Acl $folderPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users","Write","Allow")
$acl.SetAccessRule($rule)
Set-Acl -Path $folderPath -AclObject $acl

Write-Host "[+] Permission has been granted to all built-in users to write to C:\Jobs folder`n"
