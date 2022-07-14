$ROOT_DIR = $PSScriptRoot
if (Test-Path $ROOT_DIR/third_party)                    {Remove-Item $ROOT_DIR/third_party -Recurse -Force}
if (Test-Path $ROOT_DIR/build)                          {Remove-Item $ROOT_DIR/build -Recurse -Force}
if ($IsWindows) {if (Test-Path $env:LOCALAPPDATA/vcpkg) {Remove-Item $env:LOCALAPPDATA/vcpkg -Recurse -Force}}
