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
~ Type: WeakRegistryPermissions

"@

Write-Host $ascii`n

# Set the path for the folder
$folderPath = "C:\Program Files\CustomSrv4\"

# Create the folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    Write-Host "[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

Write-Host "[+] Set new file to Service folder`n"
# Set the URLs of the files to download
$urlBinary = "https://raw.githubusercontent.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/master/Lab-Setup-Binary/Service4.exe"  

# Download Service executable
Invoke-WebRequest -Uri $urlBinary -OutFile "$folderPath\Service4.exe"

Write-Host "[+] Installing the Service4`n"
# Install the Service4
New-Service -Name "Vulnerable Service 4" -BinaryPathName "C:\Program Files\CustomSrv4\Service4.exe" -DisplayName "Vuln Service 4" -Description "My Custom Vulnerable Service 4" -StartupType Automatic

Write-Host "[+] Editing the permissions of the Service4`n"
# Edit the permissions of the Service4
cmd.exe /c 'sc sdset "Vulnerable Service 4" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;RPWP;;;BU)'

Write-Host "[+] Editing registry permissions`n"
# Edit registry permissions

# Define the registry key path
$regKey = "HKLM:\SYSTEM\CurrentControlSet\Services\Vulnerable Service 4"

# Get the current ACL (Access Control List) for the registry key
$acl = Get-Acl -Path $regKey

# Specify the account and access rights
$account = "BUILTIN\Users"
$accessRights = [System.Security.AccessControl.RegistryRights]::FullControl

# Create a new access rule
$accessRule = New-Object System.Security.AccessControl.RegistryAccessRule($account, $accessRights, "Allow")

# Add the access rule to the ACL
$acl.AddAccessRule($accessRule)

# Set the modified ACL back to the registry key
Set-Acl -Path $regKey -AclObject $acl