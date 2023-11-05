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
~ Type: Stored Credentials (Runas)

"@

Write-Host $ascii`n

Write-Host "[+] Creating a new user`n"
#Create new user
net user nickvourd Passw0rd! /add

Write-Host "[+] Add the new user to Administrators group`n"
#Add the new user to Administrators Group
net localgroup "Administrators" nickvourd /add

Write-Host "[+] New user credentials"
Write-Host "Username: nickvourd"
Write-Host "Password: Passw0rd!`n"

Write-Host "[+] Use runas to save credentials on the Windows Credentials Manager (Interactive logon)`n"
runas /savecred /user:WORKGROUP\nickvourd cmd.exe