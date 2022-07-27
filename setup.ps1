# Setup prerequisites, build environment, third_party directory, .env file for running apps.
#Requires -Version 7
$ROOT_DIR = $PSScriptRoot
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
if ($IsWindows) {$TRIPLET = "x64-windows"}  
if ($IsLinux)   {$TRIPLET = "x64-linux"}    
if ($IsMacOS)   {$TRIPLET = "x64-osx"}     
$VCPKG_DIR = Join-Path $THIRD_PARTY_DIR vcpkg
$VCPKG_INSTALLED_DIR = Join-Path $VCPKG_DIR installed
$VCPKG_INSTALLED_TRIPLET_DIR = Join-Path $VCPKG_INSTALLED_DIR $TRIPLET

$OSG_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph
$QT_DIR = Join-Path $THIRD_PARTY_DIR qt5

function echo_command($cmd) {
    Write-Host $cmd -ForegroundColor Cyan
    $results = Invoke-Expression $cmd
    $results.Count ? $results[-1] : $null
}

function setup_prerequisites {
    Write-Host "Setup prerequisites..." -ForegroundColor Green
    if ($IsWindows) {
        # vs code
        $found_code = Get-Command "code" -ErrorAction SilentlyContinue
        if (!$found_code) {
            $null = winget list --id XP9KHM4BK9FZ7Q
            if (!$?) {echo_command "winget install --id XP9KHM4BK9FZ7Q --accept-package-agreements"}
        }
    
        # cmake
        $null = winget list cmake
        if (!$?) {echo_command "winget install cmake --accept-package-agreements"}
    
        # perl - for running Qt5's init-repository perl script
        $null = winget list StrawberryPerl.StrawberryPerl
        if (!$?) {echo_command "winget install StrawberryPerl.StrawberryPerl --accept-package-agreements"}
    
        $required_apps = "git", "pwsh", "cmake", "perl", 
            "code", "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"
        $all_commands_found = $true
        foreach ($ra in $required_apps) {
            $found_command = Get-Command $ra -ErrorAction SilentlyContinue
            if (!$found_command) {
                $all_commands_found = $false
                Write-Host "Could not find command: $ra" -ForegroundColor Red
            }
        }
        if (!$all_commands_found) {
            Write-Host "Cannot continue without access to required commands." -ForegroundColor Red
            Write-Host "A reboot may be required." -ForegroundColor Red
            return $false
        }
    }
    elseif ($IsLinux) {
        $installed_packages = apt list --installed 2> $null
        $upgradeable_packages = apt list --upgradeable 2> $null
        function is_package_installed($pkg) {($installed_packages | Select-String "^$pkg/") ? $true : $false}
        function is_package_upgradeable($pkg) {($upgradeable_packages | Select-String "^$pkg/") ? $true : $false}
        
        $packages = "cmake",                # Needed to generate makefiles for this dev environment
                    "build-essential",      # gcc, g++, make, C standard lib, dev tools
        
                    # From https://doc.qt.io/qt-5/linux-requirements.html
                    "libfontconfig1-dev",
                    "libfreetype6-dev",
                    "libx11-dev",
                    "libx11-xcb-dev",
                    "libxext-dev",
                    "libxfixes-dev",
                    "libxi-dev",
                    "libxrender-dev",
                    "libxcb1-dev",
                    "libxcb-glx0-dev",
                    "libxcb-keysyms1-dev",
                    "libxcb-image0-dev",
                    "libxcb-shm0-dev",
                    "libxcb-icccm4-dev",
                    "libxcb-sync-dev",      # "libxcb-sync0-dev" not found -> use "libxcb-sync-dev"
                    "libxcb-xfixes0-dev",
                    "libxcb-shape0-dev",
                    "libxcb-randr0-dev",
                    "libxcb-render-util0-dev",
                    # "libxcd-xinerama-dev", # not supported anymore? https://askubuntu.com/questions/5138/how-do-i-best-enable-xinerama
                    "libxkbcommon-dev",
                    "libxkbcommon-x11-dev"
        $ran_apt_update = $false
        foreach ($pkg in $packages) {
            $installed = is_package_installed($pkg)
            if (!$installed) {
                if (!$ran_apt_update) {
                    Write-Host "Updating apt..." -ForegroundColor Green
                    bash -c "sudo apt update"
                    $ran_apt_update = $true
                }
                Write-Host "Installing $pkg..." -ForegroundColor Green
                bash -c "sudo apt install -y $pkg"
            }
        }
        foreach ($pkg in $packages) {
            $upgradeable = is_package_upgradeable($pkg)
            if ($upgradeable) {
                if (!$ran_apt_update) {
                    Write-Host "Updating apt..." -ForegroundColor Green
                    bash -c "sudo apt update"
                    $ran_apt_update = $true
                }
                Write-Host "Upgrading $pkg..." -ForegroundColor Green
                bash -c "sudo apt upgrade -y $pkg"
            }
        }
    }
}

function setup_build_environment {
    Write-Host "Setup build environment..." -ForegroundColor Green
    if ($IsWindows) {
        Push-Location .  # Next line can put us in ~/source/repos, fix that with Pop-Location
        & "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64
        Pop-Location
    }
}

function setup_third_party {
    Write-Host "Setup third party..." -ForegroundColor Green
    #######
    # vcpkg
    #######
    # git clone vcpkg
    Write-Host "git clone vcpkg..." -ForegroundColor Green
    New-Item -ItemType Directory $THIRD_PARTY_DIR -Force | Out-Null
    $TAG = "2022.06.16.1"
    $REPO_URL = "https://github.com/Microsoft/vcpkg.git"
    echo_command "git clone --branch $TAG $REPO_URL $VCPKG_DIR -c advice.detachedHead=false"
    # build vcpkg
    Write-Host "Build vcpkg..." -ForegroundColor Green
    if ($IsWindows) {$BOOTSTRAP_VCPKG_EXE = Join-Path $VCPKG_DIR bootstrap-vcpkg.bat}
    else {$BOOTSTRAP_VCPKG_EXE = Join-Path $VCPKG_DIR bootstrap-vcpkg.sh}
    echo_command "$BOOTSTRAP_VCPKG_EXE -disableMetrics"
    # Build third party libraries
    Write-Host "Building third party libraries..." -ForegroundColor Green
    $VCPKG_EXE = Join-Path $VCPKG_DIR vcpkg
    $SRC_DIR = Join-Path $ROOT_DIR src
    $CUSTOMVCPKG_DIR = Join-Path $SRC_DIR custom_vcpkg 
    $CUSTOMVCPKG_TRIPLETS_DIR = Join-Path $CUSTOMVCPKG_DIR triplets
    $packages = "coin",
                "collada-dom", 
                "curl", 
                "dcmtk", 
                "ffmpeg", 
                "fltk", 
                "fontconfig", 
                "freetype", 
                "gdal",
                "gtk",
                "giflib", 
                "glib", 
                "gstreamer", 
                "ilmbase", 
                "jasper",
                "libgta", 
                "liblas",
                "libpng", 
                "librsvg",
                "libxml2",
                # "mesa[egl]",  # does not build on windows
                "nvtt",
                "opencascade",
                "openjpeg", 
                "openexr",
                "poppler",
                "sdl1",
                "sdl2",
                "tiff", 
                "wxwidgets",
                "zlib" 
    foreach ($pkg in $packages) {
        $cmd = "$VCPKG_EXE --triplet=$TRIPLET --recurse --overlay-triplets=$CUSTOMVCPKG_TRIPLETS_DIR install $pkg"
        Write-Host $cmd -ForegroundColor Cyan
        Invoke-Expression $cmd
    }

    ################
    # OpenSceneGraph
    ################
    Write-Host "Build OpenSceneGraph..." -ForegroundColor Green
    echo_command "git clone --branch OpenSceneGraph-3.6.5 https://github.com/openscenegraph/OpenSceneGraph.git $OSG_DIR -c advice.detachedHead=false"
    $VCPKG_INSTALLED_TRIPLET_DIR = Join-Path $VCPKG_DIR installed $TRIPLET
    $configs = "Release", "Debug" 
    foreach ($config in $configs) {
        $out_dir = Join-Path $OSG_DIR build $config
        echo_command "cmake -S $OSG_DIR -B $out_dir -DCMAKE_BUILD_TYPE=$config -DBUILD_OSG_EXAMPLES:BOOL=ON -D CMAKE_PREFIX_PATH=$VCPKG_INSTALLED_TRIPLET_DIR  # ~1 min"
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

    ####
    # Qt
    ####
    Write-Host "Build Qt5..." -ForegroundColor Green
    $QT_DIR = Join-Path $THIRD_PARTY_DIR qt5
    echo_command "git clone --branch v5.15.0 https://github.com/qt/qt5.git $QT_DIR -c advice.detachedHead=false"
    echo_command "Set-Location $QT_DIR"
    echo_command "perl ./init-repository  # ~57 min"
    $VCPKG_INCLUDE = Join-Path $VCPKG_INSTALLED_TRIPLET_DIR include
    $VCPKG_LIB = Join-Path $VCPKG_INSTALLED_TRIPLET_DIR lib
    $VCPKG_LIB_DEBUG = Join-Path $VCPKG_INSTALLED_TRIPLET_DIR debug lib
    if ($IsLinux) {
        $configs = "Release", "Debug"   
        foreach ($config in $configs) {
            $out_dir = Join-Path $QT_DIR build $config
            $null = New-Item -ItemType Directory -Force $out_dir
            echo_command "Set-Location $out_dir"
            if ($config -eq "Release") {echo_command "$QT_DIR/configure -opensource -confirm-license -$config -developer-build -I $VCPKG_INCLUDE -L $VCPKG_LIB -L $VCPKG_LIB_DEBUG  # ~2 min"}
            if ($config -eq "Debug")   {echo_command "$QT_DIR/configure -opensource -confirm-license -$config -developer-build -I $VCPKG_INCLUDE -L $VCPKG_LIB -L $VCPKG_LIB_DEBUG -qtlibinfix d -qtlibinfix-plugins -nomake examples -nomake tools -nomake tests  # ~2 min"}
            $most_procs = $(nproc) - 1
            echo_command "make --jobs=$most_procs  # ~55 min"
        }
    }
    if ($IsWindows) {
        $out_dir = Join-Path $QT_DIR build
        $null = New-Item -ItemType Directory -Force $out_dir
        echo_command "Set-Location $out_dir"

        # Setup Qt's Jom - nmake with support for multiple processors https://wiki.qt.io/Jom
        echo_command "Invoke-WebRequest -Uri https://download.qt.io/official_releases/jom/jom.zip -OutFile jom.zip"
        echo_command "Expand-Archive jom.zip -Force"
        $JOM_EXE = Join-Path jom jom.exe

        $configure = Join-Path $QT_DIR configure.bat
        echo_command "$configure -opensource -confirm-license -platform win32-msvc -I $VCPKG_INCLUDE -L $VCPKG_LIB -L $VCPKG_LIB_DEBUG"
        $most_procs = (Get-CimInstance –ClassName Win32_Processor).NumberOfLogicalProcessors - 1
        echo_command "$JOM_EXE /J $most_procs  # ~1 hour 20 min" 
        # NOTE: nmake uses single processor and takes ~4 hours, 40 min" 
    }
    echo_command "Set-Location $ROOT_DIR"

    # Download OSG data (models, textures)
    Write-Host "git clone OpenSceneGraph-Data" -ForegroundColor Green
    $OPENSCENEGRAPH_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
    echo_command "git clone https://github.com/openscenegraph/OpenSceneGraph-Data.git $OPENSCENEGRAPH_DATA_DIR"

    # Download code samples from OpenSceneGraph 3.0 Cookbook
    Write-Host "git clone osgRecipes - code samples from 'OpenSceneGraph 3.0 Cookbook'" -ForegroundColor Green
    $OSGRECIPES_DIR = Join-Path $THIRD_PARTY_DIR osgRecipes
    echo_command "git clone https://github.com/xarray/osgRecipes.git $OSGRECIPES_DIR"
}

function setup_environment_file {
    Write-Host "Setup environment file..." -ForegroundColor Green
    $ENV_FILE = Join-Path $ROOT_DIR .env
    Write-Host "Generate environment file $ENV_FILE for running apps"  -ForegroundColor Green
    $RESOURCE_DIR = Join-Path $ROOT_Dir resources

    # OSG Data
    $OSG_DATA_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph-Data
    $OSG_FILE_PATH = $RESOURCE_DIR, $OSG_DATA_DIR -join [IO.Path]::PathSeparator

    # Qt
    if ($IsWindows) {
        $QT_BIN_DIR = Join-Path $QT_DIR build qtbase bin
        $QT_BIN_DIR_DEBUG = Join-Path $QT_DIR build qtbase bin
    }
    if ($IsLinux) {
        $QT_BIN_DIR = Join-Path $QT_DIR build Release qtbase bin
        $QT_BIN_DIR_DEBUG = Join-Path $THIRD_PARTY_DIR qt5 build Debug qtbase bin
    }

    # VCPKG
    $VCPKG_INSTALLED_DIR = Join-Path $VCPKG_DIR installed
 
    $VCPKG_BIN_DIR = Join-PATH $VCPKG_INSTALLED_DIR $TRIPLET bin
    $VCPKG_BIN_DIR_DEBUG = Join-PATH $VCPKG_INSTALLED_DIR $TRIPLET debug bin

    # OSG
    $OSG_BIN_DIR = Join-Path $OSG_DIR build Release bin
    $OSG_BIN_DIR_DEBUG = Join-Path $OSG_DIR build Debug bin

    # PATH environment variable
    $path_array = $env:PATH -Split [IO.Path]::PathSeparator
    $new_path_array = @($QT_BIN_DIR, 
                        $QT_BIN_DIR_DEBUG, 
                        $OSG_BIN_DIR, 
                        $OSG_BIN_DIR_DEBUG, 
                        $VCPKG_BIN_DIR, 
                        $VCPKG_BIN_DIR_DEBUG) + $path_array | Select-Object -Unique
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
}

setup_prerequisites
setup_build_environment
setup_third_party
setup_environment_file