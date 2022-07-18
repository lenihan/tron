# setup environment file (.env) for running apps
#Requires -Version 7
$ROOT_DIR = Resolve-Path $PSScriptRoot/..
$ENV_FILE = Join-Path $ROOT_DIR .env
Write-Host "Generate environment file $ENV_FILE for running apps"  -ForegroundColor Green
$RESOURCE_DIR = Join-Path $ROOT_Dir resources
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
$OSG_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
$OSG_FILE_PATH = $RESOURCE_DIR, $OSG_DATA_DIR -join [IO.Path]::PathSeparator
$QT_BIN_DIR = Join-Path $THIRD_PARTY_DIR qt5 build qtbase bin
$OSG_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph
$OSG_BIN_DIR = Join-Path $OSG_DIR build Release bin
$OSG_BIN_DEBUG_DIR = Join-Path $OSG_DIR build Debug bin
$path_array = $env:PATH -Split [IO.Path]::PathSeparator
$new_path_array = @($QT_BIN_DIR, $OSG_BIN_DIR, $OSG_BIN_DEBUG_DIR) + $path_array | Select-Object -Unique
$PATH = $new_path_array -join [IO.Path]::PathSeparator
@"
OSG_FILE_PATH=$OSG_FILE_PATH
PATH=$PATH
VSCMD_ARG_TGT_ARCH=$env:VSCMD_ARG_TGT_ARCH
"@ | Set-Content $ENV_FILE
# TODO: Add this for linux: LD_LIBRARY_PATH="$VCPKG_LIB_DIR"
# TODO: Add this for linux debug: LD_LIBRARY_PATH="$VCPKG_LIB_DEBUG_DIR"
