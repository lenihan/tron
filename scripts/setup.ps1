# Setup prerequisites, build environment, third_party directory, .env file for running apps.
#Requires -Version 7
$ROOT_DIR = Resolve-Path $PSScriptRoot/..
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
if ($IsWindows) {$TRIPLET = "x64-windows"}  
if ($IsLinux)   {$TRIPLET = "x64-linux"}    
if ($IsMacOS)   {$TRIPLET = "x64-osx"}     
$VCPKG_DIR = Join-Path $THIRD_PARTY_DIR vcpkg

$OSG_DIR = Join-Path $THIRD_PARTY_DIR OpenSceneGraph
$QT_DIR = Join-Path $THIRD_PARTY_DIR qt5

function echo_command($cmd) {
    Write-Host $cmd -ForegroundColor Cyan
    $results = Invoke-Expression $cmd
    if ($results.Count) {$results} else {$null}
}

function setup_prerequisites {
    Write-Host "Setup prerequisites..." -ForegroundColor Green
    if ($IsWindows) {
        $required_apps = "git", "pwsh", "cmake", "perl", "code", "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1" 
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
            exit
        }
    }
    elseif ($IsLinux) {
        $installed_packages = apt list --installed 2> $null
        $upgradeable_packages = apt list --upgradeable 2> $null
        function is_package_installed($pkg) {if ($installed_packages | Select-String "^$pkg/") {$true} else {$false}}
        function is_package_upgradeable($pkg) {if ($upgradeable_packages | Select-String "^$pkg/") {$true} else {$false}}
        $packages = "curl",                 # for vcpkg
                    "cmake",                # for vcpkg
                    "build-essential",      # for vcpkg: gcc, g++, make, C standard lib, dev tools                    
                    "bison",                # for gettext  (used by osg)
                    "python3-distutils",    # for fontconfig (used by osg)
                    "libgl1-mesa-dev",      # for osg "Could not find OpenGL"

                    # for qt5: Some learned from https://github.com/microsoft/vcpkg/blob/master/scripts/azure-pipelines/linux/provision-image.sh
                    "libglu1-mesa-dev",     # for freeglut (used by qt5)
                    "libxi-dev",            # for angle (used by qt5)
                    "libxext-dev",          # for angle (used by qt5)
                    "autoconf",             # for icu (used by qt5)
                    "autoconf-archive",     # for icu (used by qt5)
                    "libx11-dev",
                    "libxkbcommon-x11-dev",                    
                    "libxext-dev",
                    "libxfixes-dev",
                    "libxrender-dev",
                    "libxcb1-dev",
                    "libx11-xcb-dev",
                    "libxcb-glx0-dev",
                    "libxcb-util0-dev",
                    "libxkbcommon-dev",
                    "libxcb-keysyms1-dev",
                    "libxcb-image0-dev",
                    "libxcb-shm0-dev",
                    "libxcb-icccm4-dev",
                    "libxcb-sync-dev",
                    "libxcb-xfixes0-dev",
                    "libxcb-shape0-dev",
                    "libxcb-randr0-dev",
                    "libxcb-render-util0-dev",
                    "libxcb-xinerama0-dev",
                    "libxcb-xkb-dev",
                    "libxcb-xinput-dev"

        $ran_apt_update = $false
        foreach ($pkg in $packages) {
            $installed = is_package_installed($pkg)
            if (!$installed) {
                if (!$ran_apt_update) {
                    echo_command "sudo apt update"
                    $ran_apt_update = $true
                }
                echo_command "sudo apt install -y $pkg"
            }
        }
        foreach ($pkg in $packages) {
            $upgradeable = is_package_upgradeable($pkg)
            if ($upgradeable) {
                if (!$ran_apt_update) {
                    echo_command "sudo apt update"
                    $ran_apt_update = $true
                }
                echo_command "sudo apt upgrade -y $pkg"
            }
        }
    }
    elseif ($IsMacOS) {
        echo_command "brew install --cask visual-studio-code"
        echo_command "brew install autoconf"
        echo_command "brew install automake"
        echo_command "brew install libtool"
        echo_command "brew install nasm"
        echo_command "brew install cmake"
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
    $packages = "osg", 
                "qt5"

    # Setup LD_LIBRARY_PATH to access libraries in vcpkg
    if ($IsLinux -or $IsMacOS) {
        # vcpkg tools 
        # (e.g. installed/x64-linux/tools/pkgconf/pkgconf) 
        # need access to vcpkg build .so's 
        # (e.g. installed/x64-linux/debug/lib/libpkgconf.so)
        $VCPKG_LIB_DIR = Join-Path $VCPKG_DIR installed $TRIPLET lib
        $VCPKG_LIB_DIR_DEBUG = Join-Path $VCPKG_DIR installed $TRIPLET debug lib
        $sep = [IO.Path]::PathSeparator # : on linux/macos, ; on windows
        $paths = if ($env:LD_LIBRARY_PATH) {$env:LD_LIBRARY_PATH -split $sep}
        if ($paths -notcontains $VCPKG_LIB_DIR) {$paths += @($VCPKG_LIB_DIR)}
        if ($paths -notcontains $VCPKG_LIB_DIR_DEBUG) {$paths += @($VCPKG_LIB_DIR_DEBUG)}
        $env:LD_LIBRARY_PATH = $paths -join $sep
    }
    foreach ($pkg in $packages) {
        $cmd = "$VCPKG_EXE --recurse --overlay-triplets=$CUSTOMVCPKG_TRIPLETS_DIR install $pkg"
        Write-Host $cmd -ForegroundColor Cyan
        Invoke-Expression $cmd
    }

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
    if ($IsLinux -or $IsMacOS) {
        $QT_BIN_DIR = Join-Path $QT_DIR build Release qtbase bin
        $QT_BIN_DIR_DEBUG = Join-Path $THIRD_PARTY_DIR qt5 build Debug qtbase bin
    }

    # VCPKG
    $VCPKG_BIN_DIR = Join-PATH  $VCPKG_DIR installed $TRIPLET bin
    $VCPKG_BIN_DIR_DEBUG = Join-PATH  $VCPKG_DIR installed $TRIPLET debug bin

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
    $VCPKG_LIB_DIR = Join-Path $VCPKG_DIR installed $TRIPLET lib
    $VCPKG_LIB_DIR_DEBUG = Join-Path $VCPKG_DIR installed $TRIPLET debug lib
    $LD_LIBRARY_PATH = $VCPKG_LIB_DIR, $VCPKG_LIB_DIR_DEBUG -join [IO.Path]::PathSeparator

    # Output .env
    if ($IsWindows) {
@"
OSG_FILE_PATH=$OSG_FILE_PATH
PATH=$PATH
VSCMD_ARG_TGT_ARCH=$env:VSCMD_ARG_TGT_ARCH
"@ | Set-Content $ENV_FILE
    }
    if ($IsLinux -or $IsMacOS) {
@"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH
OSG_FILE_PATH=$OSG_FILE_PATH
PATH=$PATH
"@ | Set-Content $ENV_FILE
    }
    
    # Add environment variables to vs code workspace
    $VS_CODE_WORKSPACE_SETTINGS_PATH = Join-Path $ROOT_DIR .vscode settings.json
    if (Test-Path $VS_CODE_WORKSPACE_SETTINGS_PATH) {
        $settings = Get-Content $VS_CODE_WORKSPACE_SETTINGS_PATH | ConvertFrom-Json
    } else {
        New-Item -ItemType File $VS_CODE_WORKSPACE_SETTINGS_PATH -Force | Out-Null
        $settings = New-Object -TypeName PSObject
    }
    if ($IsWindows) {$os = "windows"}
    if ($IsLinux)   {$os = "linux"}
    if ($IsMacOS)   {$os = "osx"}
    $env = @{}
    Get-Content $ENV_FILE | ForEach-Object {
        $name, $value = $_ -split '='
        $env += @{$name = $value}
    }   

    # store settings
    $terminal_integrated_env_os = $env
    $cmake_environment          = $env
    $files_associations         = @{"**/include/**" = "cpp"}
    $search_useIgnoreFiles      = $false
    $search_exclude             = @{"**/build" = $true; "third_party/vcpkg" = $true}

    # save settings
    $settings | Add-Member -MemberType NoteProperty -Name "terminal.integrated.env.$os" -Value $terminal_integrated_env_os -Force
    $settings | Add-Member -MemberType NoteProperty -Name "cmake.environment"           -Value $cmake_environment          -Force
    $settings | Add-Member -MemberType NoteProperty -Name "files.associations"          -Value $files_associations         -Force
    $settings | Add-Member -MemberType NoteProperty -Name "search.useIgnoreFiles"       -Value $search_useIgnoreFiles      -Force
    $settings | Add-Member -MemberType NoteProperty -Name "search.exclude"              -Value $search_exclude             -Force
    $settings | ConvertTo-Json | Set-Content $VS_CODE_WORKSPACE_SETTINGS_PATH
}

setup_prerequisites
setup_build_environment
setup_third_party
setup_environment_file