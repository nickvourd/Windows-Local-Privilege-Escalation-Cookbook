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

Write-Host "[+] Creating a new user`n"
net user ncv Passw0rd! /add

Write-Host "[+] Adding the new user to Remote Management Users group`n"
net localgroup "Remote Management Users" ncv /add

Write-Host "[+] Enabling WinRM Service`n"
Enable-PSRemoting -Force

Write-Host "[+] Installing PSPrivilege module`n"
Install-Module -Name PSPrivilege -Force

Write-Host "[+] Importing PSPrivilege module`n"
Import-Module PSPrivilege

Write-Host "[+] Granting SeBackupPrivilege to the new user`n"
Add-WindowsRight -Name SeBackupPrivilege -Account (Get-LocalUser -Name "ncv").Sid

Write-Host "[+] New user's credentials"
Write-Host "Username: ncv"
Write-Host "Password: Passw0rd!`n"
