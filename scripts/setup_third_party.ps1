# setup third_party directory
#Requires -Version 7
$ROOT_DIR = Resolve-Path $PSScriptRoot/..
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
Write-Host "Setup external source in $THIRD_PARTY_DIR"  -ForegroundColor Green
function echo_command($cmd) {
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}

# OpenSceneGraph
Write-Host "Build OpenSceneGraph..." -ForegroundColor Green
$OPENSCENEGRAPH_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph
echo_command "git clone --branch OpenSceneGraph-3.6.5 https://github.com/openscenegraph/OpenSceneGraph.git $OPENSCENEGRAPH_DIR"
$configs = "Release", "Debug" 
foreach ($config in $configs) {
    $out_dir = Join-Path $OPENSCENEGRAPH_DIR build $config
    echo_command "cmake -S $OPENSCENEGRAPH_DIR -B $out_dir -DCMAKE_BUILD_TYPE=$config -DBUILD_OSG_EXAMPLES:BOOL=ON  # ~1 min"
    if ($IsLinux)   {
        $most_procs = $(nproc) - 1
        echo_command "make -C $out_dir --jobs=$most_procs  # ~50 min"
    }
    if ($IsWindows) {
        $most_procs = (Get-CimInstance –ClassName Win32_Processor).NumberOfLogicalProcessors - 1
        $sln = Join-Path $out_dir OpenSceneGraph.sln
        echo_command "msbuild $sln -p:Configuration=$config -maxCpuCount:$most_procs  # ~27 min"
    }
}

# Qt5
Write-Host "Build Qt5..." -ForegroundColor Green
$QT5_DIR = Join-Path $THIRD_PARTY_DIR qt5
echo_command "git clone --branch v5.15.0 https://github.com/qt/qt5.git $QT5_DIR"
echo_command "Set-Location $QT5_DIR"
echo_command "perl ./init-repository  # ~57 min"
if ($IsLinux) {
    $configs = "Release", "Debug"   
    foreach ($config in $configs) {
        $out_dir = Join-Path $QT5_DIR build $config
        $null = New-Item -ItemType Directory -Force $out_dir
        echo_command "Set-Location $out_dir"
        if ($config -eq "Release") {echo_command "$QT5_DIR/configure -opensource -confirm-license -$config -developer-build  # ~2 min"}
        if ($config -eq "Debug")   {echo_command "$QT5_DIR/configure -opensource -confirm-license -$config -developer-build -qtlibinfix d -qtlibinfix-plugins -nomake examples -nomake tools -nomake tests # ~2 min"}
        $most_procs = $(nproc) - 1
        echo_command "make --jobs=$most_procs  # ~55 min"
    }
}
if ($IsWindows) {
    $out_dir = Join-Path $QT5_DIR build
    $null = New-Item -ItemType Directory -Force $out_dir
    echo_command "Set-Location $out_dir"

    # Setup Qt's Jom - nmake with support for multiple processors https://wiki.qt.io/Jom
    echo_command "Invoke-WebRequest -Uri https://download.qt.io/official_releases/jom/jom.zip -OutFile jom.zip"
    echo_command "Expand-Archive jom.zip"
    $JOM_EXE = Join-Path jom jom.exe

    $configure = Join-Path $QT5_DIR configure.bat
    echo_command "$configure -opensource -confirm-license -platform win32-msvc"
    $most_procs = (Get-CimInstance –ClassName Win32_Processor).NumberOfLogicalProcessors - 1
    echo_command "$JOM_EXE /J $most_procs  # ~1 hour 20 min" 
    # NOTE: nmake uses single processor and takes ~4 hours, 40 min" 
}

# Download OSG data (models, textures)
Write-Host "git clone OpenSceneGraph-Data" -ForegroundColor Green
$OPENSCENEGRAPH_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
echo_command "git clone https://github.com/openscenegraph/OpenSceneGraph-Data.git $OPENSCENEGRAPH_DATA_DIR"

# Download code samples from OpenSceneGraph 3.0 Cookbook
Write-Host "git clone osgRecipes - code samples from 'OpenSceneGraph 3.0 Cookbook'" -ForegroundColor Green
$OSGRECIPES_DIR = Join-Path $THIRD_PARTY_DIR osgRecipes
echo_command "git clone https://github.com/xarray/osgRecipes.git $OSGRECIPES_DIR"
return $true # no problems
