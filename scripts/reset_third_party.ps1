# delete third_party and build directories
#Requires -Version 7
$ROOT_DIR = (Resolve-Path $PSScriptRoot/..) -replace "\\", "/"
if (Test-Path $ROOT_DIR/third_party) {Remove-Item $ROOT_DIR/third_party -Recurse -Force}
if (Test-Path $ROOT_DIR/build)       {Remove-Item $ROOT_DIR/build -Recurse -Force}
