# setup environment file (.env) for running apps
#Requires -Version 7
$ROOT_DIR = Resolve-Path $PSScriptRoot/..
$ENV_FILE = Join-Path $ROOT_DIR .env
Write-Host "Generate environment file $ENV_FILE for running apps"  -ForegroundColor Green
$RESOURCE_DIR = Join-Path $ROOT_Dir resources
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party

# OSG Data
$OSG_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
$OSG_FILE_PATH = $RESOURCE_DIR, $OSG_DATA_DIR -join [IO.Path]::PathSeparator

# Qt
$QT_DIR = Join-Path $THIRD_PARTY_DIR qt5
if ($IsWindows) {
    $QT_BIN_DIR = Join-Path $QT_DIR build qtbase bin
    $QT_BIN_DIR_DEBUG = Join-Path $QT_DIR build qtbase bin
}
if ($IsLinux) {
    $QT_BIN_DIR = Join-Path $QT_DIR build Release qtbase bin
    $QT_BIN_DIR_DEBUG = Join-Path $THIRD_PARTY_DIR qt5 build Debug qtbase bin
}

# OSG
$OSG_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph
$OSG_BIN_DIR = Join-Path $OSG_DIR build Release bin
$OSG_BIN_DIR_DEBUG = Join-Path $OSG_DIR build Debug bin

# PATH environment variable
$path_array = $env:PATH -Split [IO.Path]::PathSeparator
$new_path_array = @($QT_BIN_DIR, $QT_BIN_DIR_DEBUG, $OSG_BIN_DIR, $OSG_BIN_DIR_DEBUG) + $path_array | Select-Object -Unique
$PATH = $new_path_array -join [IO.Path]::PathSeparator

# LD_LIBRARY_PATH environment variable
$OSG_LIB_DIR = Join-Path $OSG_DIR build Release lib
$OSG_LIB_DIR_DEBUG = Join-Path $OSG_DIR build Debug lib
$QT_LIB_DIR = Join-Path $QT_DIR build Release qtbase lib
$QT_LIB_DIR_DEBUG = Join-Path $QT_DIR build Debug qtbase lib
$LD_LIBRARY_PATH = $OSG_LIB_DIR, $OSG_LIB_DIR_DEBUG, $QT_LIB_DIR, $QT_LIB_DIR_DEBUG -join [IO.Path]::PathSeparator

# Output .env
if ($IsWindows) {
@"
OSG_FILE_PATH=$OSG_FILE_PATH
PATH=$PATH
VSCMD_ARG_TGT_ARCH=$env:VSCMD_ARG_TGT_ARCH
"@ | Set-Content $ENV_FILE
}
if ($IsLinux) {
@"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH
OSG_FILE_PATH=$OSG_FILE_PATH
"@ | Set-Content $ENV_FILE
}

return $true # no problems