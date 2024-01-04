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
$urlBinary = "https://github.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/blob/master/Lab-Setup-Binary/Service2.exe"  

# Download index.html
Invoke-WebRequest -Uri $urlBinary -OutFile "$folderPath\Service2.exe"

Write-Host "[+] Granting writable privileges to BUILTIN\Users for the Service2.exe binary`n"
# Grant writable privileges to BUILTIN\Users for the binary
icacls "C:\Program Files\CustomSrv2\Service2.exe" /grant BUILTIN\Users:W

Write-Host "[+] Installing the Service2`n"
# Install the Service2
C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe "C:\Program Files\CustomSrv2\Service2.exe"