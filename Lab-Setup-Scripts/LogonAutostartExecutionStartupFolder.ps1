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
~ Type: LogonAutostartExecutionStartupFolder

"@

Write-Host $ascii`n

# Set the path for the NickvourdSrv folder
$folderPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

# Add permission for all built-in users to FullControl to the Startup folder
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "FullControl", "Allow")
$acl = Get-Acl $folderPath
$acl.SetAccessRule($rule)
Set-Acl -Path $folderPath -AclObject $acl

Write-Host "`n[+] Permission has been granted to all built-in users to full control to $folderPath`n"