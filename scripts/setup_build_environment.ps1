# setup build environment
#Requires -Version 7
Write-Host "Setup build environment..." -ForegroundColor Green
if ($IsWindows) {
    Push-Location .  # Next line can put us in ~/source/repos, fix that with Pop-Location
    & "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64
    Pop-Location
}
