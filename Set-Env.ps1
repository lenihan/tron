# Set environment variables from .env file
#   `Set-Env.ps1` with no parameters loads debug.env in same location as this script
#   `Set-Env.ps1 -Path release.env` loads release.env
Param(
    [ValidateScript({Test-Path $_})]
    [String]
    $Path = (Join-Path $PSScriptRoot debug.env)
)
foreach($line in (Get-Content $Path)) {
    $name, $value = $line -Split '='
    Set-Item -Path env:"$name" -Value "$value"
}