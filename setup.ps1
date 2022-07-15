# Install prerequisites, builds third party libraries
$ROOT_DIR = $PSScriptRoot

& $ROOT_DIR/scripts/setup_build_environment.ps1


# Prerequisites
Write-Host "Prerequisites..." -ForegroundColor Green
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


# git clone vcpkg
Write-Host "git clone vcpkg..." -ForegroundColor Green
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
New-Item -ItemType Directory $THIRD_PARTY_DIR -Force | Out-Null
$VCPKG_DIR = Join-Path $THIRD_PARTY_DIR vcpkg
$TAG = "2022.06.16.1"
$REPO_URL = "https://github.com/Microsoft/vcpkg.git"
$cmd = "git clone --branch $TAG $REPO_URL $VCPKG_DIR"
Write-Host $cmd -ForegroundColor Cyan
Invoke-Expression $cmd


# build vcpkg
Write-Host "Build vcpkg..." -ForegroundColor Green
if ($IsWindows) {
    $BOOTSTRAP_VCPKG_EXE = Join-Path $VCPKG_DIR bootstrap-vcpkg.bat
}
else {
    $BOOTSTRAP_VCPKG_EXE = Join-Path $VCPKG_DIR bootstrap-vcpkg.sh
}
$cmd = "$BOOTSTRAP_VCPKG_EXE -disableMetrics"
Write-Host $cmd -ForegroundColor Cyan
Invoke-Expression $cmd


# Build third party libraries
Write-Host "Building third party libraries..." -ForegroundColor Green
if ($IsWindows) {$TRIPLET = "x64-windows"}  
if ($IsLinux)   {$TRIPLET = "x64-linux"}    
if ($IsMacOS)   {$TRIPLET = "x64-osx"}      
$VCPKG_EXE = Join-Path $VCPKG_DIR vcpkg
$SRC_DIR = Join-Path $ROOT_DIR src
$CUSTOMVCPKG_DIR = Join-Path $SRC_DIR custom_vcpkg 
$CUSTOMVCPKG_TRIPLETS_DIR = Join-Path $CUSTOMVCPKG_DIR triplets
if ($IsWindows) {
    # ~3 hours on 8 processor Surface Laptop Studio
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
foreach ($pkg in $packages) {
    $cmd = "$VCPKG_EXE --triplet=$TRIPLET --recurse install $pkg --overlay-triplets=$CUSTOMVCPKG_TRIPLETS_DIR"
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}


# Download OSG data (models, textures)
Write-Host "git clone OpenSceneGraph-Data" -ForegroundColor Green
$OPENSCENEGRAPH_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
$cmd = "git clone https://github.com/openscenegraph/OpenSceneGraph-Data.git $OPENSCENEGRAPH_DATA_DIR"
Write-Host $cmd -ForegroundColor Cyan
Invoke-Expression $cmd


# Download code samples from OpenSceneGraph 3.0 Cookbook
Write-Host "git clone osgRecipes - code samples from 'OpenSceneGraph 3.0 Cookbook'" -ForegroundColor Green
$OSGRECIPES_DIR = Join-Path $THIRD_PARTY_DIR osgRecipes
$cmd = "git clone https://github.com/xarray/osgRecipes.git $OSGRECIPES_DIR"
Write-Host $cmd -ForegroundColor Cyan
Invoke-Expression $cmd


# Generate environment file for running apps
$ENV_FILE = Join-Path $ROOT_DIR .env
$RESOURCE_DIR = Join-Path $ROOT_Dir resources
$OSG_FILE_PATH = $RESOURCE_DIR, $OPENSCENEGRAPH_DATA_DIR -join [IO.Path]::PathSeparator
$VCPKG_INSTALLED_DIR = Join-Path $VCPKG_DIR installed
$VCPKG_TRIPLET_DIR = Join-Path $VCPKG_INSTALLED_DIR $TRIPLET
$VCPKG_TOOLS_DIR = Join-Path $VCPKG_TRIPLET_DIR tools
$VCPKG_TOOLS_OSG_DIR = Join-Path $VCPKG_TOOLS_DIR osg
$VCPKG_TRIPLET_DEBUG_DIR = Join-Path $VCPKG_TRIPLET_DIR debug
$VCPKG_TOOLS_DEBUG_DIR = Join-Path $VCPKG_TRIPLET_DEBUG_DIR tools
$VCPKG_TOOLS_OSG_DEBUG_DIR = Join-Path $VCPKG_TOOLS_DEBUG_DIR osg
$VCPKG_BIN_DIR = Join-Path $VCPKG_TRIPLET_DIR bin
$VCPKG_BIN_DEBUG_DIR = Join-Path $VCPKG_TRIPLET_DEBUG_DIR bin
# Add .dll/.so, .exe locations to PATH
$path_array = $env:PATH -Split [IO.Path]::PathSeparator
$new_path_array = 
    $VCPKG_BIN_DIR, 
    $VCPKG_BIN_DEBUG_DIR, 
    $VCPKG_TOOLS_OSG_DIR, 
    $VCPKG_TOOLS_OSG_DEBUG_DIR + $path_array | Select-Object -Unique
$PATH = $new_path_array -join [IO.Path]::PathSeparator
Write-Host "Generate environment file $ENV_FILE for running apps"  -ForegroundColor Green
@"
OSG_FILE_PATH=$OSG_FILE_PATH
PATH=$PATH
VSCMD_ARG_TGT_ARCH=$env:VSCMD_ARG_TGT_ARCH
"@ | Set-Content $ENV_FILE

# TODO: Add this for linux: LD_LIBRARY_PATH="$VCPKG_LIB_DIR"
# TODO: Add this for linux debug: LD_LIBRARY_PATH="$VCPKG_LIB_DEBUG_DIR"