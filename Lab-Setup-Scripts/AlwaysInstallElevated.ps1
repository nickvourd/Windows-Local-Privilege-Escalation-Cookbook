#Global Variables
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
~ Type: AlwaysInstallElevated

"@

Write-Host $ascii`n

Write-Host "[+] Configuring HKEY_LOCAL_MACHINE registry`n"
#Create a new key in HKEY_LOCAL_MACHINE registry
New-Item -Path "Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer"

#Create a new DWORD (32-Bit) Value and insert hex data
New-ItemProperty -Path "Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -PropertyType DWORD -Value 0x00000001

Write-Host "[+] Configuring HKEY_CURRENT_USER registry`n"
#Create a new key in HKEY_CURRENT_USER registry
New-Item -Path "Registry::\HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Installer"

#Create a new DWORD (32-Bit) Value and insert hex data
New-ItemProperty -Path "Registry::\HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -PropertyType DWORD -Value 0x00000001
