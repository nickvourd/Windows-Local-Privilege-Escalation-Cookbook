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
~ Type: EnableUAC

"@

Write-Host $ascii`n

Write-Host "[+] Editing the HKLM registry to enable UAC feature`n"

# Edit the HLKM registry to enable UAC Security feature
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0x1 /f

Write-Host "`n[+] The computer will restart in 6 seconds to apply the new configurations settings!`n"

# Wait for 20 seconds
Start-Sleep -Seconds 6

# Restart the computer
Restart-Computer -Force