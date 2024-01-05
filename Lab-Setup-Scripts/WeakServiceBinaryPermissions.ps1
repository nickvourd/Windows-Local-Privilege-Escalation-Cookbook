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
~ Type: WeakServiceBinaryPermissions

"@

Write-Host $ascii`n

# Set the path for the folder
$folderPath = "C:\Program Files\CustomSrv2\"

# Create the folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    Write-Host "[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

Write-Host "[+] Set new file to Service folder`n"
# Set the URLs of the files to download
$urlBinary = "https://raw.githubusercontent.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/master/Lab-Setup-Binary/Service2.exe"  

# Download Service executable
Invoke-WebRequest -Uri $urlBinary -OutFile "$folderPath\Service2.exe"

Write-Host "[+] Granting modify privileges to BUILTIN\Users for the binary`n"
# Grant modify privileges to BUILTIN\Users for the binary
icacls "C:\Program Files\CustomSrv2\Service2.exe" /grant BUILTIN\Users:M

Write-Host "[+] Installing the Service2`n"
# Install the Service2
New-Service -Name "Vulnerable Service 2" -BinaryPathName "C:\Program Files\CustomSrv2\Service2.exe" -DisplayName "Vuln Service 2" -Description "My Custom Vulnerable Service 2" -StartupType Automatic

Write-Host "[+] Editing the permissions of the Service2"
# Edit the permissions of the Service2
cmd.exe /c 'sc sdset "Vulnerable Service 2" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;RPWP;;;BU)'