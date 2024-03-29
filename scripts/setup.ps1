# Setup prerequisites, build environment, third_party directory, .env file for running apps.
#Requires -Version 7
$ROOT_DIR = Resolve-Path $PSScriptRoot/..
$THIRD_PARTY_DIR = Join-Path $ROOT_DIR third_party
if ($IsWindows) {$TRIPLET = "x64-windows"}  
if ($IsLinux)   {$TRIPLET = "x64-linux"}    
if ($IsMacOS)   {$TRIPLET = "x64-osx"}     
$VCPKG_DIR = Join-Path $THIRD_PARTY_DIR vcpkg

function echo_command($cmd) {
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
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
                    "libtool",              # for osg

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
        # Unable to build qt5 (moc can't find libbz2d.1.0.dylib) because SIP (System Integrity Protection) won't pass
        # DYLD_LIBRARY_PATH to subprocesses.
        # Fix: Disable SIP
        # If SIP is enabled, exit
        $SIP_enabled = (csrutil status) -match "enabled."
        if ($SIP_enabled) {
            Write-Host "SIP (System Integrity Protection) must be disabled to build third party libraries." -ForegroundColor Red
            Write-Host "To disable, follow instructions here:" -ForegroundColor Red
            Write-Host "https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection" -ForegroundColor Red
            exit           
        }

        echo_command "brew install --cask visual-studio-code"
        echo_command "brew install autoconf"
        echo_command "brew install automake"
        echo_command "brew install libtool"
        echo_command "brew install nasm"
        echo_command "brew install cmake"
        echo_command "brew install autoconf-archive"
        echo_command "brew install gettext"
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
    
    # Setup variables used to build third party libraries
    Write-Host "Building third party libraries..." -ForegroundColor Green
    $VCPKG_EXE = Join-Path $VCPKG_DIR vcpkg
    $CUSTOMVCPKG_TRIPLET_DIR = Join-Path $ROOT_DIR src custom_vcpkg triplets
    $packages = "osg[tools]", 
                "qt5"

    # Setup LD_LIBRARY_PATH/DYLD_LIBRARY_PATH 
    if ($IsLinux -or $IsMacOS) { 
        # vcpkg tools  
        # (e.g. installed/x64-linux/tools/pkgconf/pkgconf)  
        # need access to vcpkg build .so's  
        # (e.g. installed/x64-linux/debug/lib/libpkgconf.so) 
        $VCPKG_LIB_DIR = Join-Path $VCPKG_DIR installed $TRIPLET lib 
        $VCPKG_LIB_DIR_DEBUG = Join-Path $VCPKG_DIR installed $TRIPLET debug lib 
        $sep = [IO.Path]::PathSeparator # : on linux/macos, ; on windows 
        if ($IsLinux) {$env_var = $env:LD_LIBRARY_PATH}  
        if ($IsMacOS) {$env_var = $env:DYLD_LIBRARY_PATH}  
        $paths = if ($env_var) {$env_var -split $sep} 
        if ($paths -notcontains $VCPKG_LIB_DIR) {$paths += @($VCPKG_LIB_DIR)} 
        if ($paths -notcontains $VCPKG_LIB_DIR_DEBUG) {$paths += @($VCPKG_LIB_DIR_DEBUG)} 
        $env_var = $paths -join $sep 
        if ($IsLinux) {$env:LD_LIBRARY_PATH = $env_var}  
        if ($IsMacOS) {$env:DYLD_LIBRARY_PATH = $env_var}
    }
    
    # MacOS qt build fix for: 
    #    ERROR: debug-only framework builds are not supported. Configure with -no-framework if you want a pure debug build. 
    if ($IsMacOS) {
        $file_path = Join-Path $VCPKG_DIR ports qt5-base cmake configure_qt.cmake
        $content = Get-Content $file_path
        $find_text = "    list\(APPEND _csc_OPTIONS_DEBUG -debug\)"
        $replace_text = @"
    list(APPEND _csc_OPTIONS_DEBUG -debug) 
    # START Added by David Lenihan 
    if(VCPKG_TARGET_IS_OSX) 
        list(APPEND _csc_OPTIONS_DEBUG -no-framework) 
    endif() 
    # END Added by David Lenihan 
"@
        $content -replace $find_text, $replace_text | Set-Content $file_path
    }

    # Linux fix: debug binaries have same name as release binaries and are stored in same location.
    #            Add "_debug" postfix (like Windows "d") so both release/debug can live side-by-side.
    $file_contents = @'
diff --git a/mkspecs/features/create_cmake.prf b/mkspecs/features/create_cmake.prf
index 4aa5dad46..cee6d2882 100644
--- a/mkspecs/features/create_cmake.prf
+++ b/mkspecs/features/create_cmake.prf
@@ -212,7 +212,7 @@ contains(CONFIG, plugin) {
     CMAKE_PLUGIN_TYPE_ESCAPED = $$replace(PLUGIN_TYPE, [-/], _)
 
     win32 {
-        !mingw|qtConfig(debug_and_release): debug_suffix="d"
+        debug_suffix="d"
 
         CMAKE_PRL_FILE_LOCATION_RELEASE = $$PLUGIN_TYPE/$${CMAKE_QT_STEM}.prl
         CMAKE_PRL_FILE_LOCATION_DEBUG = $$PLUGIN_TYPE/$${CMAKE_QT_STEM}$${debug_suffix}.prl
@@ -241,9 +241,9 @@ contains(CONFIG, plugin) {
             else: CMAKE_PLUGIN_EXT = .a
 
             CMAKE_PLUGIN_LOCATION_RELEASE = $$PLUGIN_TYPE/lib$${CMAKE_QT_STEM}$${CMAKE_PLUGIN_EXT}
-            CMAKE_PLUGIN_LOCATION_DEBUG = $$PLUGIN_TYPE/lib$${CMAKE_QT_STEM}$${CMAKE_PLUGIN_EXT}
+            CMAKE_PLUGIN_LOCATION_DEBUG = $$PLUGIN_TYPE/lib$${CMAKE_QT_STEM}_debug$${CMAKE_PLUGIN_EXT}
             CMAKE_PRL_FILE_LOCATION_RELEASE = $$PLUGIN_TYPE/lib$${CMAKE_QT_STEM}.prl
-            CMAKE_PRL_FILE_LOCATION_DEBUG = $$PLUGIN_TYPE/lib$${CMAKE_QT_STEM}.prl
+            CMAKE_PRL_FILE_LOCATION_DEBUG = $$PLUGIN_TYPE/lib$${CMAKE_QT_STEM}_debug.prl
         }
     }
     cmake_target_file.input = $$PWD/data/cmake/Qt5PluginTarget.cmake.in
@@ -295,6 +295,7 @@ CMAKE_FEATURE_PROPERTY_PREFIX = ""
 equals(TEMPLATE, aux): CMAKE_FEATURE_PROPERTY_PREFIX = "INTERFACE_"
 
 mac {
+    CMAKE_FIND_OTHER_LIBRARY_BUILD = "true"
     !isEmpty(CMAKE_STATIC_TYPE) {
         CMAKE_LIB_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}_debug.a
         CMAKE_LIB_FILE_LOCATION_RELEASE = lib$${CMAKE_QT_STEM}.a
@@ -316,7 +317,7 @@ mac {
     CMAKE_WINDOWS_BUILD = "true"
     CMAKE_FIND_OTHER_LIBRARY_BUILD = "true"
 
-    !mingw|qtConfig(debug_and_release): debug_suffix="d"
+    debug_suffix="d"
 
     CMAKE_LIB_FILE_LOCATION_DEBUG = $${CMAKE_QT_STEM}$${debug_suffix}.dll
     CMAKE_LIB_FILE_LOCATION_RELEASE = $${CMAKE_QT_STEM}.dll
@@ -342,17 +343,18 @@ mac {
         CMAKE_IMPLIB_FILE_LOCATION_RELEASE = $${CMAKE_QT_STEM}.lib
     }
 } else {
+    CMAKE_FIND_OTHER_LIBRARY_BUILD = "true"
     !isEmpty(CMAKE_STATIC_TYPE) {
-        CMAKE_LIB_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}.a
+        CMAKE_LIB_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}_debug.a
         CMAKE_LIB_FILE_LOCATION_RELEASE = lib$${CMAKE_QT_STEM}.a
-        CMAKE_PRL_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}.prl
+        CMAKE_PRL_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}_debug.prl
         CMAKE_PRL_FILE_LOCATION_RELEASE = lib$${CMAKE_QT_STEM}.prl
     } else:unversioned_libname {
-        CMAKE_LIB_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}.so
+        CMAKE_LIB_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}_debug.so
         CMAKE_LIB_FILE_LOCATION_RELEASE = lib$${CMAKE_QT_STEM}.so
         CMAKE_LIB_SONAME = lib$${CMAKE_QT_STEM}.so
     } else {
-        CMAKE_LIB_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}.so.$$eval(QT.$${MODULE}.VERSION)
+        CMAKE_LIB_FILE_LOCATION_DEBUG = lib$${CMAKE_QT_STEM}_debug.so.$$eval(QT.$${MODULE}.VERSION)
         CMAKE_LIB_FILE_LOCATION_RELEASE = lib$${CMAKE_QT_STEM}.so.$$eval(QT.$${MODULE}.VERSION)
         CMAKE_LIB_SONAME = lib$${CMAKE_QT_STEM}.so.$$section(QT.$${MODULE}.VERSION, ., 0, 0)
     }
'@
    $file_path = Join-Path $VCPKG_DIR ports qt5-base patches create_cmake.patch
    $file_contents | Set-Content $file_path

    # MacOS osg build fix. When you try to build osg[tools], you get an error because sdl1 (a dependency of osg[tools]) is not supported
    # on MacOS. From third_party/vcpkg/ports/sdl1/vcpkg.json...
    #    "supports": "!osx & !uwp"
    # I verified if I removed sdl1 dependency from osg[tools], I could build osg[tools] on MacOS.
    # For this fix, removing the sdl1 dependency from osg[tools]. I haven't noticed it is needed for osg tools (i.e. osgviewer, osgconv)
    $file_path = Join-Path $VCPKG_DIR ports osg vcpkg.json
    $content = Get-Content $file_path -Raw
    $find_text = ",`n *`"sdl1`"`n"
    $replace_text = "`n"
    $content -replace $find_text, $replace_text | Set-Content $file_path

    # vcpkg install
    foreach ($pkg in $packages) {   
        echo_command "$VCPKG_EXE --triplet=$TRIPLET --overlay-triplets=$CUSTOMVCPKG_TRIPLET_DIR install $pkg --recurse"
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

    # VCPKG
    $VCPKG_BIN_DIR       = Join-Path $VCPKG_DIR installed $TRIPLET bin
    $VCPKG_BIN_DIR_DEBUG = Join-Path $VCPKG_DIR installed $TRIPLET debug bin

    # OSG Plugins
    $OSG_PLUGINS_DIR       = Join-Path $VCPKG_DIR installed $TRIPLET tools osg
    $OSG_PLUGINS_DIR_DEBUG = Join-Path $VCPKG_DIR installed $TRIPLET debug tools osg

    # PATH environment variable
    $path_array = $env:PATH -Split [IO.Path]::PathSeparator
    $new_path_array = @($VCPKG_BIN_DIR, 
                        $VCPKG_BIN_DIR_DEBUG,
                        $OSG_PLUGINS_DIR,
                        $OSG_PLUGINS_DIR_DEBUG) + $path_array | Select-Object -Unique
    $PATH = $new_path_array -join [IO.Path]::PathSeparator

    # LD_LIBRARY_PATH environment variable
    $VCPKG_LIB_DIR       = Join-Path $VCPKG_DIR installed $TRIPLET lib
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
    if ($IsLinux) {
@"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH
OSG_FILE_PATH=$OSG_FILE_PATH
PATH=$PATH
"@ | Set-Content $ENV_FILE
    }
    if ($IsMacOS) {
@"
DYLD_LIBRARY_PATH=$LD_LIBRARY_PATH
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