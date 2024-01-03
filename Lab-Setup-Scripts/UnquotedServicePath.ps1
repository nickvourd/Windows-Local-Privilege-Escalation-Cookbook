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
$urlBinary = "https://raw.githubusercontent.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/master/Lab-Setup-Binary/App1.exe" 

# Download index.html
Invoke-WebRequest -Uri $urlBinary -OutFile "$folderPath\App1.exe"

Write-Host "[+] Granting writable privileges to BUILTIN\Users for the Vulnerable Service1 folder`n"
# Grant writable privileges to BUILTIN\Users for the folder
icacls "C:\Program Files\Vulnerable Service1" /grant BUILTIN\Users:W

Write-Host "`n[+] Installing the Windows service`n"
# Install the Vulnerable service
C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe "C:\Program Files\Vulnerable Service1\Custom Srv1\App1.exe"