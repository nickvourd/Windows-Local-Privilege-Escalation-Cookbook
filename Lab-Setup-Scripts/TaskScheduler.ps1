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

Write-Host $ascii`n

# Set the path for the Jobs folder
$folderPath = "C:\Jobs"

# Create the Jobs folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    Write-Host "[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

# Set the path for the file to be moved
$filePath = "C:\Jobs\Monitor_AMD64.exe"

# Download binary file
$url = "https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/raw/master/Lab-Setup-Binary/Monitor_AMD64.exe"
Invoke-WebRequest -Uri $url -OutFile $filePath

# Check if the file exists and move it to the Jobs folder
if (Test-Path $filePath) {
    Move-Item -Path $filePath -Destination $folderPath
    Write-Host "`n[+] File moved successfully to $folderPath`n"
} else {
    Write-Host "`n[!] File not found at $filePath`n"
}

# Add permission for all built-in users to write to the Jobs folder
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "Write", "Allow")
$acl = Get-Acl $folderPath
$acl.SetAccessRule($rule)
Set-Acl -Path $folderPath -AclObject $acl

Write-Host "`n[+] Permission has been granted to all built-in users to write to $folderPath`n"

# Get the current username from the environment variable
$username = $env:USERNAME

# Set the action for the scheduled task
$action = New-ScheduledTaskAction -Execute "$folderPath\Monitor_AMD64.exe"

# Set the trigger for the scheduled task
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Hours 24)

# Create the principal with the current user and highest privileges
$principal = New-ScheduledTaskPrincipal -UserId $username -LogonType Interactive -RunLevel Highest

# Configure the settings for the scheduled task
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit 0 -DisallowHardTerminate -StartWhenAvailable

# Register the scheduled task with the specified settings
Register-ScheduledTask -TaskName "MagicTask" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description "Scheduled task for MagicTask"

Write-Host "`n[+] MagicTask scheduled successfully to run every 5 minutes with highest privileges as $username`n"
