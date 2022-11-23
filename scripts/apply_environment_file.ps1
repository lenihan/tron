# Set environment variables from .env file
#   `Set-Env.ps1` with no parameters loads .env in parent directory of this script
#   `Set-Env.ps1 -Path ~\.env` loads ~\.env
Param(
    [ValidateScript({Test-Path $_})]
    [String]
    $Path = (Join-Path $PSScriptRoot/.. .env)
)
foreach($line in (Get-Content $Path)) {
    $name, $value = $line -Split '='
    Set-Item -Path env:"$name" -Value "$value"
}