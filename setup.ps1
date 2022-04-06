# Install prerequisites, builds third party libraries

if( -not (Test-Variable 'variable:IsWindows') )
{
    # We know we're on Windows PowerShell 5.1 or earlier
    $IsWindows = $true
    $IsLinux = $IsMacOS = $false
}

# Build environment
Write-Host "Setup build environment..." -ForegroundColor Cyan
if ($IsWindows) {
    & "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"
}

# Prerequisites
Write-Host "Prerequisites..." -ForegroundColor Cyan
if ($IsWindows) {
    $cmd = " winget install --id Kitware.Cmake"
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}
elseif ($IsLinux) {
    # Get latest versions of software
    sudo apt update
        
    # for WSL build from Visual Studio
    sudo apt install -y g++
    sudo apt install -y gdb 
    sudo apt install -y make 
    sudo apt install -y ninja-build 
    sudo apt install -y rsync 
    sudo apt install -y zip
    
    # needed by osg
    sudo apt install -y gperf

    # Needed by qt5
    sudo apt install -y bison
    sudo apt install -y python

    # Needed for qt5 https://doc.qt.io/qt-5/linux-requirements.html
    sudo apt install -y libfontconfig1-dev
    sudo apt install -y libfreetype6-dev
    sudo apt install -y libx11-dev
    sudo apt install -y libx11-xcb-dev
    sudo apt install -y libxext-dev
    sudo apt install -y libxfixes-dev
    sudo apt install -y libxi-dev
    sudo apt install -y libxrender-dev
    sudo apt install -y libxcb1-dev
    sudo apt install -y libxcb-glx0-dev
    sudo apt install -y libxcb-keysyms1-dev
    sudo apt install -y libxcb-image0-dev
    sudo apt install -y libxcb-shm0-dev
    sudo apt install -y libxcb-icccm4-dev
    sudo apt install -y libxcb-sync0-dev
    sudo apt install -y libxcb-xfixes0-dev
    sudo apt install -y libxcb-shape0-dev
    sudo apt install -y libxcb-randr0-dev
    sudo apt install -y libxcb-render-util0-dev
    sudo apt install -y libxcd-xinerama-dev
    sudo apt install -y libxkbcommon-dev
    sudo apt install -y libxkbcommon-x11-dev

    # Needed for qt5 https://github.com/microsoft/vcpkg/blob/master/scripts/azure-pipelines/linux/provision-image.sh
    sudo apt install -y libxcb-util0-dev
    sudo apt install -y libxcb-xinerama0-dev
    sudo apt install -y libxcb-xkb-dev
    sudo apt install -y libxcb-xinput-dev
}

# Build third party libraries
Write-Host "Building third party libraries..." -ForegroundColor Cyan
$ROOT_DIR = $PSScriptRoot
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
mkdir $THIRD_PARTY_DIR -Force | Out-Null
$VCPKG_DIR = Join-Path $THIRD_PARTY_DIR vcpkg
$TAG = "2022.02.02"
Write-Host "Using vcpkg tag $TAG" -ForegroundColor Cyan
git clone --branch $TAG https://github.com/Microsoft/vcpkg.git $VCPKG_DIR 
if ($IsWindows) {
    $triplet = "x64-windows"   # dynamic library, dynamic CRT
    $BOOTSTRAP_VCPKG_EXE = Join-Path $VCPKG_DIR bootstrap-vcpkg
    $cmd = "$BOOTSTRAP_VCPKG_EXE -disableMetrics"
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}    
    
if ($IsWindows) {
    # ~2 hours
    $packages = 
        "osg[tools,plugins,examples]",      
        "qt5"                               
} 
else {
    $packages = 
        "fontconfig",                       # needed by osg for reading fonts. 
        "osg[tools,plugins,examples]",      
        "qt5"                               
}
$VCPKG_EXE = Join-Path $VCPKG_DIR vcpkg
foreach ($pkg in $packages) {
    $cmd = "$VCPKG_EXE --triplet=$triplet --recurse install $pkg"
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}

# Download OSG data (models, textures)
Write-Host "Clone OpenSceneGraph-Data" -ForegroundColor Cyan
$OPENSCENEGRAPH_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
git clone https://github.com/openscenegraph/OpenSceneGraph-Data.git $OPENSCENEGRAPH_DATA_DIR

# Download code samples from OpenSceneGraph 3.0 Cookbook
Write-Host "Clone osgRecipes - code samples from 'OpenSceneGraph 3.0 Cookbook'" -ForegroundColor Cyan
$OSGRECIPES_DIR = Join-Path $THIRD_PARTY_DIR osgRecipes
git clone https://github.com/xarray/osgRecipes.git $OSGRECIPES_DIR

# Generate environment file .env for running apps
$ENV_FILE = Join-Path $ROOT .env
$ENV_DEBUG_FILE = Join-Path $ROOT .env_debug
Write-Host "Generate environment file $ENV_FILE for running apps"  -ForegroundColor Cyan
$VCPKG_TOOLS_DIR = Join-Path $VCPKG_DIR installed $triplet tools
$VCPKG_TOOLS_DEBUG_DIR = Join-Path $VCPKG_DIR installed $triplet debug tools
$OSG_VERSION_EXE = Join-Path $VCPKG_TOOLS_DIR osg osgversion
$OSG_VERSION = &$OSG_VERSION_EXE --version-number
$OSG_PLUGIN_DIRNAME = "osgPlugins-$OSG_VERSION"
$OSG_PLUGINS_DIR = Join-Path $VCPKG_TOOLS_DIR osg $OSG_PLUGIN_DIRNAME
$OSG_PLUGINS_DEBUG_DIR = Join-Path $VCPKG_TOOLS_DEBUG_DIR osg $OSG_PLUGIN_DIRNAME
$VCPKG_LIB_DIR = Join-Path $VCPKG_DIR installed $triplet lib
$VCPKG_LIB_DEBUG_DIR = Join-Path $VCPKG_DIR installed $triplet debug lib
$VCPKG_INCLUDE_DIR = Join-Path $VCPKG_DIR installed $triplet include
$VCPKG_BIN_DIR = Join-Path $VCPKG_DIR installed $triplet bin
$VCPKG_BIN_DEBUG_DIR = Join-Path $VCPKG_DIR installed $triplet debug bin

@"
OSG_LIBRARY_PATH="$OSG_PLUGINS_DIR"
OSG_FILE_PATH="$OPENSCENEGRAPH_DATA_DIR"
VCPKG_INCLUDE_DIR="$VCPKG_INCLUDE_DIR"
VCPKG_LIB_DIR="$VCPKG_LIB_DIR"
VCPKG_BIN_DIR="$VCPKG_BIN_DIR"
"@ > $ENV_FILE

@"
OSG_LIBRARY_PATH="$OSG_PLUGINS_DEBUG_DIR"
OSG_FILE_PATH="$OPENSCENEGRAPH_DATA_DIR"
VCPKG_INCLUDE_DIR="$VCPKG_INCLUDE_DIR"
VCPKG_LIB_DEBUG_DIR="$VCPKG_LIB_DEBUG_DIR"
VCPKG_BIN_DEBUG_DIR="$VCPKG_BIN_DEBUG_DIR"
"@ > $ENV_DEBUG_FILE

# TODO: Add this for linux: LD_LIBRARY_PATH="$ROOT/OpenSceneGraph/lib:$ROOT/vcpkg/installed/x64-linux-dynamic/debug/lib"