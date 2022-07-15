# Install prerequisites, builds third party libraries
#Requires -Version 7.0
$ROOT_DIR = $PSScriptRoot -replace "\\", "/"

# setup build environment
$cmd = "& $ROOT_DIR/scripts/setup_build_environment.ps1"
Write-Host $cmd -ForegroundColor Cyan
Invoke-Expression $cmd

# setup prerequisites
$cmd = "& $ROOT_DIR/scripts/setup_prerequisites.ps1"
Write-Host $cmd -ForegroundColor Cyan
Invoke-Expression $cmd

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