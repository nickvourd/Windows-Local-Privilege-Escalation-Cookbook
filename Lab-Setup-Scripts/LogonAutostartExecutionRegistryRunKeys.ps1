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
~ Type: LogonAutostartExecutionRegistryRunKeys

"@

Write-Host $ascii`n

# Set the path for the NickvourdSrv folder
$folderPath = "C:\Program Files\NickvourdSrv"

# Create the Jobs folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    Write-Host "[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

# Set the path for the file to be moved
$filePath = "C:\Program Files\NickvourdSrv\NCV_AMD64.exe"

# Download binary file
$url = "https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/raw/master/Lab-Setup-Binary/NCV_ADM64.exe"
Invoke-WebRequest -Uri $url -OutFile $filePath

# Add permission for all built-in users to FullControl to the NickvourdSrv folder
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "FullControl", "Allow")
$acl = Get-Acl $folderPath
$acl.SetAccessRule($rule)
Set-Acl -Path $folderPath -AclObject $acl

Write-Host "`n[+] Permission has been granted to all built-in users to full control to $folderPath`n"

$keyPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run'
$valueName = 'NickvourdSrv'

# Check if the registry key exists
if (-not (Test-Path $keyPath)) {
    # Create the registry key if it doesn't exist
    New-Item -Path $keyPath -Force
    Write-Output "`n[+] The registry key '$keyPath' has been created."
} else {
    Write-Output "`n[+] The registry key '$keyPath' already exists."
}

# Create the new String Value under the registry key
New-ItemProperty -Path $keyPath -Name $valueName -Value $filePath -PropertyType String -Force
Write-Output "`n[+] The '$valueName' String Value with data '$filePath' has been created under '$keyPath'."