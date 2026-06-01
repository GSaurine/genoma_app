param(
    [string]$Destination = "C:\\projects\\genoma",
    [switch]$Force
)

$Source = (Get-Location).ProviderPath
Write-Host "Source: $Source"
Write-Host "Destination: $Destination"

if (Test-Path $Destination) {
    if (-not $Force) {
        $answer = Read-Host "Destination exists. Overwrite? (Y/N)"
        if ($answer -ne 'Y' -and $answer -ne 'y') {
            Write-Host "Aborting copy."
            exit 1
        }
    }
    Write-Host "Removing existing destination..."
    Remove-Item -Recurse -Force -LiteralPath $Destination
}

New-Item -ItemType Directory -Path $Destination -Force | Out-Null

# Exclude common build/cache folders to speed up copy
$excludeDirs = @('.git','build','.dart_tool','.gradle','.idea','.vscode','.pub-cache')
$xdParams = @()
foreach ($d in $excludeDirs) {
    $xdParams += "/XD"
    $xdParams += Join-Path $Source $d
}

$robocopyArgs = @($Source, $Destination, '/MIR', '/MT:8', '/COPYALL', '/R:3', '/W:2', '/NFL', '/NDL') + $xdParams

Write-Host "Running robocopy... this may take a while"
$rc = & robocopy @robocopyArgs

if ($LASTEXITCODE -lt 8) {
    Write-Host "Copy complete (robocopy exit code $LASTEXITCODE)."
    Write-Host "Now run the project from the ASCII path:";
    Write-Host "  cd `"$Destination`""
    Write-Host "  flutter pub get"
    Write-Host "  flutter run -d emulator-5554 --route=/login"
    exit 0
} else {
    Write-Error "Robocopy failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}
