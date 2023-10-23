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
~ Type: SeBackupPrivilege

"@

Write-Host $ascii`n


Write-Host "[+] Createing a new user`n"
#Create new user
net user ncv Passw0rd! /add

Write-Host "[+] Enabling WinRM service`n"
#Enable WinRM service
Enable-PSRemoting -Force

Write-Host "Add the new user to Remote Management Users group`n"
#Add the new user to Remote Management Group
net localgroup "Add the new user to Remote Management Users" ncv /add

Write-Host "[+] Installing Carbon module`n"
#Install Carbon module
Install-Module -Name carbon -Force

Write-Host "[+] Importing Carbon module`n"
#Import Carbon module
Import-Module carbon

Write-Host "[+] Granting SeBackupPrivilege to the current user`n"
#Grant SeBackupPrivilege to the current user
Grant-CPrivilege -Identity ncv -Privilege SeBackupPrivilege

Write-Host "[+] New user credentials"
Write-Host "Username: ncv"
Write-Host "Password: Passw0rd!`n"