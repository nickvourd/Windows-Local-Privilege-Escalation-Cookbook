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

Write-Host "[+] Installing CredentialManager module`n"
Install-Module -Name CredentialManager -Force

Write-Host "[+] Importing CredentialManager module`n"
Import-Module CredentialManager

Write-Host "[+] Saving credentials to the Windows Credentials Manager`n"
New-StoredCredential -Target "WORKGROUP\Administrator" -UserName "WORKGROUP\Administrator" -Password "Asa31904#!" -Persist LocalMachine -Type DomainPassword
