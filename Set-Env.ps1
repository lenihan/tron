# Set environment variables from .env file
#   `Set-Env.ps1` with no parameters loads .env in same location as this script
#   `Set-Env.ps1 -Path debug.env` loads debug.env
Param(
    [ValidateScript({Test-Path $_})]
    [String]
    $Path = (Join-Path $PSScriptRoot release.env)
)
foreach($line in (Get-Content $Path)) {
    if ($line.StartsWith('#')) {continue}
    $name, $value = $line -Split '='
    Set-Item -Path env:"$name" -Value "$value"
}