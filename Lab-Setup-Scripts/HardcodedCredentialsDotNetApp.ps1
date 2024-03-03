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
~ Type: HardcodedCredentialsDotNetApp

"@

Write-Host $ascii`n

# Set the path for the folder
$folderPath = "C:\Program Files\CustomDotNetApp\"

# Create the folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    Write-Host "[+] Folder created successfully at $folderPath`n"
} else {
    Write-Host "[+] Folder already exists at $folderPath`n"
}

Write-Host "[+] Set new file to Service folder`n"
# Set the URLs of the files to download
$urlBinary = "https://raw.githubusercontent.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/master/Lab-Setup-Binary/CustomDotNetApp.exe"  

# Download Service executable
Invoke-WebRequest -Uri $urlBinary -OutFile "$folderPath\CustomDotNetApp.exe"

Write-Host "[+] Installing the Custom .NET Service`n"
# Install the Custom .NET Service
New-Service -Name "Custom Dot Net Service" -BinaryPathName "C:\Program Files\CustomDotNetApp\CustomDotNetApp.exe" -DisplayName "Custom .NET Service" -Description "My Custom .NET Service" -StartupType Automatic