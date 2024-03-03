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
~ Type: StoredCredentialsWinLogon

"@

Write-Host $ascii`n

# Define variables
$UserName = "Administrator"
$Password = "Asa31904#!"
$Domain = $env:USERDOMAIN

# Check if registry values exist
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$Values = @(
    "DefaultUserName",
    "DefaultPassword",
    "DefaultDomainName",
    "AutoAdminLogon"
)

foreach ($Value in $Values) {
    if (-not (Test-Path "$RegistryPath\$Value")) {
        Write-Host "Registry value $Value does not exist. Creating it..."
        New-ItemProperty -Path $RegistryPath -Name $Value -Value $null -PropertyType String -Force
    }
}

# Set registry keys for automatic logon
Set-ItemProperty -Path $RegistryPath -Name "DefaultUserName" -Value $UserName
Set-ItemProperty -Path $RegistryPath -Name "DefaultPassword" -Value $Password
Set-ItemProperty -Path $RegistryPath -Name "DefaultDomainName" -Value $Domain
Set-ItemProperty -Path $RegistryPath -Name "AutoAdminLogon" -Value "1"

# Output success message
Write-Host "Automatic logon configuration was successful."
Write-Host "Username: $UserName"
Write-Host "Password: $Password`n"

# Display a message to users
$msg = "[!] The computer will restart in 10 seconds.`n"
Write-Host $msg

# Wait for 10 seconds
Start-Sleep -Seconds 10

# Restart the computer to apply changes
Restart-Computer -Force


