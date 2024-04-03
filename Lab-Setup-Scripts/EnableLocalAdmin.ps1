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
~ Type: EnableLocalAdmin

"@

Write-Host $ascii`n

# Enable the local Administrator account
Enable-LocalUser -Name "Administrator"

# Set the password for the Administrator account
$password = ConvertTo-SecureString "Asa31904#!" -AsPlainText -Force
Set-LocalUser -Name "Administrator" -Password $password

Write-Host "`n[+] Admin Credentials:"
Write-Host "`n[+] Username: Administrator"
Write-Host "`n[+] Password: Asa31904#!`n"

# Display a message to users
$msg = "[!] The computer will restart in 20 seconds. Please save your credentials!`n"
Write-Host $msg

# Wait for 20 seconds
Start-Sleep -Seconds 20

# Restart the computer
Restart-Computer -Force

