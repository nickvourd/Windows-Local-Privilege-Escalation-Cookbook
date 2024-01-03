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
~ Type: UnquotedServicePath

"@

Write-Host $ascii`n

# Set the path for the folder
$folderPath = "C:\Program Files\Vulnerable Service1\Custom Srv1"

# Create the folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    Write-Host "[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

Write-Host "[+] Set new files to Service folder`n"
# Set the URLs of the files to download
$urlBinary = "https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/blob/master/Lab-Setup-Binary/App1_AMD64.exe"  

# Download index.html
Invoke-WebRequest -Uri $urlBinary -OutFile "$folderPath\App1_AMD64.exe"

Write-Host "[+] Granting writable privileges to BUILTIN\Users for the Vulnerable Service1 folder`n"
# Grant writable privileges to BUILTIN\Users for the folder
$folderPath = 'C:\Program Files\Vulnerable Service1'
$permission = 'BUILTIN\Users'
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission, 'Modify', 'ObjectInherit, ContainerInherit', 'None', 'Allow')
$acl = Get-Acl -Path $folderPath
$acl.SetAccessRule($rule)
Set-Acl -Path $folderPath -AclObject $acl

Write-Host "[+] Creating a Windows service with a specified executable path`n"
# Create a Windows service named "Vulnerable Service 1" with a specified executable path
sc create "Vulnerable Service 1" binpath= "C:\Program Files\Vulnerable Service\Custom Srv1\App1_AMD64.exe" Displayname= "Vuln Service 1" start= auto