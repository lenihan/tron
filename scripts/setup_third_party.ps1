# setup third_party directory
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
return



# Qt5
Write-Host "Build Qt5..." -ForegroundColor Green
$half_procs = $(nproc) / 2
echo_command "Set-Location $THIRD_PARTY_DIR"
echo_command "git clone --branch v5.15.0 https://github.com/qt/qt5.git"
echo_command "Set-Location qt5"
echo_command "./init-repository  # ~7 min"
echo_command "# RELEASE"
echo_command "$null = New-Item -ItemType Directory -Force build-release"
echo_command "Set-Location build-release"
echo_command "../configure -opensource -confirm-license -release -developer-build  # ~2 min"
echo_command "make --jobs=$half_procs  # ~55 min"
echo_command "# DEBUG"
echo_command "Set-Location .."
echo_command "$null = New-Item -ItemType Directory -Force  build-debug"
echo_command "Set-Location build-debug"
echo_command "../configure -opensource -confirm-license -debug -qtlibinfix d -qtlibinfix-plugins -nomake examples -nomake tools -nomake tests # ~2 min"
echo_command "make --jobs=$half_procs # ~27 min"

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