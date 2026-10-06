$downloadFolder = "C:\Users\reetm\Downloads"
$hotfolder = "C:\Users\reetm\Downloads\delhi-aqi-visualisation-main\delhi-aqi-visualisation-main\Receipt download\hotfolder"

if (-not (Test-Path $hotfolder)) {
    New-Item -ItemType Directory -Force -Path $hotfolder
}
$printed = @{}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $downloadFolder
$watcher.Filter = "exposure_receipt_*.png"
$watcher.EnableRaisingEvents = $true

Write-Host "Watching $downloadFolder for new files and routing to hotfolder..."

while ($true) {
    Get-ChildItem -Path $downloadFolder -Filter "exposure_receipt_*.png" | ForEach-Object {
        if (-not $printed[$_.FullName]) {
            Start-Sleep -Seconds 2
            
            # Print the file
            Start-Process -FilePath $_.FullName -Verb Print
            
            # Move the file to the hotfolder
            $destination = Join-Path -Path $hotfolder -ChildPath $_.Name
            Move-Item -Path $_.FullName -Destination $destination -Force
            
            # Mark the new destination as printed so we don't double print if it ever gets watched
            $printed[$destination] = $true
            Write-Host "Printed and Moved to Hotfolder: $($_.Name)"
        }
    }
    Start-Sleep -Seconds 3
}