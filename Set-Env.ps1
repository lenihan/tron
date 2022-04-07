# Set environment variables from .env file
#   `Set-Env.ps1` with no parameters loads .env in same location as this script
#   `Set-Env.ps1 -Path debug.env` loads debug.env
Param(
    [ValidateScript({Test-Path $_})]
    [String]
    $Path = (Join-Path $PSScriptRoot .env)
)
Get-Content $Path | ForEach-Object {
    $name, $value = $_ -Split '='
    Set-Item -Path env:"$name" -Value "$value"
}