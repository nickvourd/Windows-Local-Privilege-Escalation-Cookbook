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
~ Type: SeImpersonatePrivilege

"@

Write-Host $ascii`n

Write-Host "[+] Installing IIS Web Server with required features`n"

# Check if Server or Workstation SKU
$os = Get-WmiObject -Class Win32_OperatingSystem
if ($os.Caption -match "Server") {
        Install-WindowsFeature -Name Web-Server, Web-Asp-Net45, NET-WCF-Services45, NET-HTTP-Activation
} else {
        Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebServer", "IIS-ASPNET45", "WCF-Services45", "WCF-HTTP-Activation" -All -NoRestart
}

Write-Host "[+] Cleaning the C:\inetpub\wwwroot\`n"
$excludedFolder = "C:\Inetpub\wwwroot\aspnet_client"
Get-ChildItem -Path C:\Inetpub\wwwroot\* | Where-Object { $_.FullName -ne $excludedFolder } | Remove-Item -Force -Recurse

Write-Host "[+] Set new files to IIS Web Server`n"

# Set the URLs of the files to download
$urlIndexHtml = "https://raw.githubusercontent.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/master/Lab-Setup-Source-Code/index.html"  
$urlCmdAspx = "https://raw.githubusercontent.com/nickvourd/Windows-Local-Privilege-Escalation-Cookbook/master/Lab-Setup-Source-Code/cmdasp.aspx"  

# Set the destination path
$destination = "C:\inetpub\wwwroot\"

# Download index.html
Invoke-WebRequest -Uri $urlIndexHtml -OutFile "$destination\index.html"

# Download cmdasp.aspx
Invoke-WebRequest -Uri $urlCmdAspx -OutFile "$destination\cmdasp.aspx"
