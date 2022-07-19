# Setup prerequisites, build environment, third_party directory, .env file for running apps.
function echo_command($cmd) {
    Write-Host $cmd -ForegroundColor Cyan
    $results = Invoke-Expression $cmd
    return $results[-1]  # last result is return value
}
$ROOT_DIR = $PSScriptRoot
$SCRIPTS_DIR = Join-Path $ROOT_DIR scripts
$scripts = "setup_prerequisites.ps1", 
           "setup_build_environment.ps1", 
           "setup_third_party.ps1", 
           "setup_environment_file.ps1"
foreach($s in $scripts) {
    $script_path = Join-Path $SCRIPTS_DIR $s
    $success = echo_command "& $script_path"
    if (!$success) {
        Write-Host "Last script did not finish. Exiting" -ForegroundColor Red
        return
    }
}
