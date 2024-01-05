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
$folderPath = "C:\Program Files\Vulnerable Service1\"

# Create the folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    mkdir C:\Program` Files\Vulnerable` Service1
    Write-Host "`n[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

Write-Host "[+] Set new file to Service folder`n"
# Set the URLs of the files to download
$urlBinary = "https://raw.githubusercontent.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/master/Lab-Setup-Binary/Service 1.exe"  

# Download Service executable
Invoke-WebRequest -Uri $urlBinary -OutFile "$folderPath\Service 1.exe"

Write-Host "[+] Granting write privileges to BUILTIN\Users for the folder`n"
# Grant write privileges to BUILTIN\Users for the folder
icacls "C:\Program Files\Vulnerable Service1\" /grant BUILTIN\Users:W

Write-Host "[+] Installing the Service 1`n"
# Install the Service 1
New-Service -Name "Vulnerable Service 1" -BinaryPathName "C:\Program Files\Vulnerable Service1\Service 1.exe" -DisplayName "Vuln Service 1" -Description "My Custom Vulnerable Service 1" -StartupType Automatic

Write-Host "[+] Editing the permissions of the Service 1"
# Edit the permissions of the Service 1
cmd.exe /c 'sc sdset "Vulnerable Service 1" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;RPWP;;;BU)'