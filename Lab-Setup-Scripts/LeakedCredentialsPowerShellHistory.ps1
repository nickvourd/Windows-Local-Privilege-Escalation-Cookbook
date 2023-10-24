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
~ Type: Leaked Credentials (PowerShell History)

"@

Write-Host $ascii`n

Write-Host "[+] Creating a new user`n"
#Create new user
net user nikos Passw0rd! /add

Write-Host "[+] Add the new user to Administrators group`n"
#Add the new user to Administrators Group
net localgroup "Administrators" nikos /add

Write-Host "[+] Add the new user to Remote Desktop Users group`n"
#Add the new user to Remote Desktop Group
net localgroup "Remote Desktop Users" nikos /add

Write-Host "[+] Enabling Remote Desktop Service`n"
#Enable Remote Desktop Service
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"