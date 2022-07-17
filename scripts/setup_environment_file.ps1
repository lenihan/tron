# setup environment file (.env) for running apps
$ROOT_DIR = (Resolve-Path $PSScriptRoot/..) -replace "\\", "/"
$ENV_FILE = Join-Path $ROOT_DIR .env
Write-Host "Generate environment file $ENV_FILE for running apps"  -ForegroundColor Green
$RESOURCE_DIR = Join-Path $ROOT_Dir resources
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
$OPENSCENEGRAPH_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
$OSG_FILE_PATH = $RESOURCE_DIR, $OPENSCENEGRAPH_DATA_DIR -join [IO.Path]::PathSeparator

# $VCPKG_INSTALLED_DIR = Join-Path $VCPKG_DIR installed
# $VCPKG_TRIPLET_DIR = Join-Path $VCPKG_INSTALLED_DIR $TRIPLET
# $VCPKG_TOOLS_DIR = Join-Path $VCPKG_TRIPLET_DIR tools
# $VCPKG_TOOLS_OSG_DIR = Join-Path $VCPKG_TOOLS_DIR osg
# $VCPKG_TRIPLET_DEBUG_DIR = Join-Path $VCPKG_TRIPLET_DIR debug
# $VCPKG_TOOLS_DEBUG_DIR = Join-Path $VCPKG_TRIPLET_DEBUG_DIR tools
# $VCPKG_TOOLS_OSG_DEBUG_DIR = Join-Path $VCPKG_TOOLS_DEBUG_DIR osg
# $VCPKG_BIN_DIR = Join-Path $VCPKG_TRIPLET_DIR bin
# $VCPKG_BIN_DEBUG_DIR = Join-Path $VCPKG_TRIPLET_DEBUG_DIR bin
# # Add .dll/.so, .exe locations to PATH
$path_array = $env:PATH -Split [IO.Path]::PathSeparator
$new_path_array =
    $VCPKG_BIN_DIR,
    $VCPKG_BIN_DEBUG_DIR,
    $VCPKG_TOOLS_OSG_DIR,
    $VCPKG_TOOLS_OSG_DEBUG_DIR + $path_array | Select-Object -Unique
$PATH = $new_path_array -join [IO.Path]::PathSeparator
@"
OSG_FILE_PATH=$OSG_FILE_PATH
PATH=$PATH
VSCMD_ARG_TGT_ARCH=$env:VSCMD_ARG_TGT_ARCH
"@ | Set-Content $ENV_FILE
# TODO: Add this for linux: LD_LIBRARY_PATH="$VCPKG_LIB_DIR"
# TODO: Add this for linux debug: LD_LIBRARY_PATH="$VCPKG_LIB_DEBUG_DIR"
