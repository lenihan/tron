# Setup prerequisites, build environment, third_party directory, .env file for running apps.
function echo_command($cmd) {
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}
$ROOT_DIR = (Resolve-Path $PSScriptRoot) -replace "\\", "/"
echo_command "& $ROOT_DIR/scripts/setup_prerequisites.ps1"
echo_command "& $ROOT_DIR/scripts/setup_build_environment.ps1"
echo_command "& $ROOT_DIR/scripts/setup_third_party.ps1"
echo_command "& $ROOT_DIR/scripts/setup_environment_file.ps1"
