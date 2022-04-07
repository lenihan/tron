# tron - Qt/OpenSceneGraph based libraries and apps

- [tron - Qt/OpenSceneGraph based libraries and apps](#tron---qtopenscenegraph-based-libraries-and-apps)
  - [Goals](#goals)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Generate Build Files](#generate-build-files)
  - [Run](#run)
  - [Clean](#clean)
  - [Hierarchy](#hierarchy)
  - [Create A CMake Project](#create-a-cmake-project)
  - [CMake Tips](#cmake-tips)
    - [Helpful Documentation](#helpful-documentation)
    - [ALL_BUILD and ZERO_CHECK](#all_build-and-zero_check)
    - [Copy files](#copy-files)
    - [Qt CMake](#qt-cmake)
    - [OpenSceneGraph (OSG) CMake](#openscenegraph-osg-cmake)
    - [CMake Comment](#cmake-comment)
    - [Print Message/Variable](#print-messagevariable)
    - [Show All CMake Variables](#show-all-cmake-variables)
  - [OSG Tips](#osg-tips)
    - [OSG Tools (.exe's)](#osg-tools-exes)
    - [Run osgviewer.exe](#run-osgviewerexe)
    - [Run osgconv.exe](#run-osgconvexe)
  - [TODO](#todo)

## Goals

- Simple - Err on the side of simple solutions that new users will easily understand
- Fast - Want to be able to develop fast, debug fast, iterate fast, run fast
- Easy - Things should "just work" or be easy to figure out
- Crossplatform - Windows, Linux, Mac
- Multiple copies of repo
- Run locally

## Prerequisites

- Windows
  1. Install [PowerShell 7+ from Microsoft Store](https://www.microsoft.com/en-us/p/powershell/9mz1snwt0n5d)
  2. Install *Visual Studio 2022 Community*
     1. Download and open [vs_Community.exe](https://aka.ms/vs/17/release/vs_community.exe)
     2. Select *"Desktop development with C++"* Workload
     3. Click *"Install"* button
  3. Install [Qt Visual Studio Tools](https://marketplace.visualstudio.com/items?itemName=TheQtCompany.QtVisualStudioTools2022)
     - Adds debugging extensions for Qt data types
- Linux
  1. [Install PowerShell on Ubuntu](https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu)
- Mac
  1. [Install PowerShell on MacOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)

## Setup

1. Open Terminal
2. `pwsh`
3. `git clone https://github.com/lenihan/tron.git $HOME/repos/tron`
4. `~/repos/tron/setup.ps1`

## Generate Build Files

1. Open Terminal
2. `pwsh`
3. `~/repos/tron/generate.ps1`

## Run

- Windows
  - Visual Studio 2022
    1. Open Terminal
    2. `pwsh`
    3. `~/repos/tron/out/tron.sln`
    4. Right click project you want to run in *Solution Explorer* and select *Debug > Start New Instance*
  - Visual Studio Code
  - WSL - Ubuntu 20.04
- Linux - Ubuntu 20.04
- Mac

## Clean

All output (CMake, compiler, linker, etc.) go to *out* directory. To clean up, delete *out*.

1. Open Terminal
2. `pwsh`
3. `ri $HOME/repos/tron/out -Recurse -Force`

## Hierarchy

- src
  - sandbox
- out
- third_party
  - vcpkg
- .gitignore
- CMakeLists.txt
- generate.ps1
- README.md
- setup.ps1

## Create A CMake Project 

1. Name your project with `project(<PROJECT_NAME>)`
2. Create project folder under `~/repos/tron/src`
3. Create `CMakeLists.txt` in project folder
   1. [add_executable](https://cmake.org/cmake/help/latest/command/add_executable.html)
      - Links source code to executable 
   2. [find_package](https://cmake.org/cmake/help/latest/command/find_package.html)
      - Add third party header/library paths
   3. [target_link_libraries](https://cmake.org/cmake/help/latest/command/target_link_libraries.html)
      - Link executable to third party libaries 
4. Update `CmakeLists.txt` in root
   1. Add project folder via [add_subdirectory](https://cmake.org/cmake/help/latest/command/add_subdirectory.html)
5. Generate build files in *tron/out*: Run `generate.ps1` 
   - What it does if you are running from repo root: `cmake -S . -B ./out`
6. Open IDE
   - Visual Studio: `.\out\tron.sln`

## CMake Tips

### Helpful Documentation

- [CMake Language](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html)
- [CMake Commands](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html)
- [CMake Variables](https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html)
- [CMake Generators](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html)
- [CMake Qt](https://cmake.org/cmake/help/latest/manual/cmake-qt.7.html)

### ALL_BUILD and ZERO_CHECK

CMake creates two predefined projects

- ALL_BUILD - Build all projects
- ZERO_CHECK - Check to see if any files are out of date, and re-run CMake if needed.

ALL_BUILD has a dependency on all projects. When you build ALL_BUILD, you build everything.

ZERO_CHECK looks at the timestamp on `generate.stamp` files to determine if CMake needs to re-run. For example, if you add a new source file to a 'CMakeLists.txt` file, ZERO_CHECK will detect this and regenerate build files. All projects have a dependency on ZERO_CHECK to ensure all build files are up to date before building.

### Copy files

Use `configure_file` to copy files. The copy happens during CMake build file generation. See `src\sandbox\QTreeView` for an example.

### Qt CMake

Add support for a Qt component

1. `find_package(Qt5 COMPONENTS <QT5_COMPONENT> REQUIRED)`
2. `target_link_libraries(${PROJECT_NAME} Qt5::<QT5_COMPONENT>)`

Replace `<QT_COMPONENT>` with...

| `<QT_COMPONENT>` |
|------------------|
AccessibilitySupport
AttributionsScannerTools
AxBase
AxContainer
AxServer
Concurrent
Core
DBus
Designer
DesignerComponents
DeviceDiscoverySupport
EdidSupport
EventDispatcherSupport
FbSupport
FontDatabaseSupport
Gui
Help
LinguistTools
Multimedia
MultimediaQuick
MultimediaWidgets
Network
NetworkAuth
OpenGL
OpenGLExtensions
PacketProtocol
PlatformCompositorSupport
PrintSupport
Qml
QmlDebug
QmlDevTools
QmlImportScanner
QmlModels
QmlWorkerScript
Quick
QuickCompiler
QuickControls2
QuickParticles
QuickShapes
QuickTemplates2
QuickTest
QuickWidgets
Sql
Svg
Test
ThemeSupport
UiPlugin
UiTools
Widgets
WindowsUIAutomationSupport
Xml

Qt components are defined in *third_party\vcpkg\installed\x64-windows\share\cmake\Qt5\Qt5Config.cmake* which is parsed via `find_package`. In this file, you can see that *modules* are directories with a `qt5` prefix in *third_party\vcpkg\installed\x64-windows\share\cmake*. Learned from [here](https://stackoverflow.com/a/62676473).

### OpenSceneGraph (OSG) CMake

Add support for an OSG library by adding these lines to CMakeLists.txt

1. `find_package(<PKG> REQUIRED)`
2. `target_link_libraries(${PROJECT_NAME} ${<LIB>})`

Replace `<PKG>` and `<LIB>` with...

`<PKG>`         | `<LIB>`
----------------|------------------------
osg             | OSG_LIBRARY
osgGA           | OSGGA_LIBRARY
osgUtil         | OSGUTIL_LIBRARY
osgDB           | OSGDB_LIBRARY
osgText         | OSGTEXT_LIBRARY
osgWidget       | OSGWIDGET_LIBRARY
osgTerrain      | OSGTERRAIN_LIBRARY
osgFX           | OSGFX_LIBRARY
osgViewer       | OSGVIEWER_LIBRARY
osgVolume       | OSGVOLUME_LIBRARY
osgManipulator  | OSGMANIPULATOR_LIBRARY
osgAnimation    | OSGANIMATION_LIBRARY
osgParticle     | OSGPARTICLE_LIBRARY
osgShadow       | OSGSHADOW_LIBRARY
osgPresentation | OSGPRESENTATION_LIBRARY
osgSim          | OSGSIM_LIBRARY
OpenThreads     | OPENTHREADS_LIBRARY

This informationcomes from *third_party\vcpkg\buildtrees\osg\src\raph-3.6.5-0028e69d98.clean\CMakeModules\FindOSG.cmake* which is parsed via `find_package`.

### CMake Comment

[CMake Comment Documentation](https://cmake.org/cmake/help/v3.1/manual/cmake-language.7.html#comments)

- Everything after `#` is a comment
  - Like C++ `//`
- Everthing in betwee `#[[` and `]]` is a comment
  - Like C++ `/* ... */`

### Print Message/Variable

[CMake's Message Documentation](https://cmake.org/cmake/help/latest/command/message.html)

```cmake
message("Hello")
message(${PROJECT_NAME})
```

### Show All CMake Variables

Add this to a `CMakeLists.txt` to see all CMake variables

```cmake
get_cmake_property(_variableNames VARIABLES)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
```

## OSG Tips

### OSG Tools (.exe's)

```powershell
./Set-Env.ps1
gci $env:VCPKG_TOOLS_OSG_DIR
```

### Run osgviewer.exe

```powershell
./Set-Env.ps1
osgviewer cow.osg
```

### Run osgconv.exe

```powershell
./Set-Env.ps1
osgconv
```



## TODO

- Fix missing fonts for hello_osg
- Make hello_osg do something
- Build for VS Code, document
- Build on WSL - Ubuntu, document
- Build on Ubuntu, document
- Build on mac, document
- You can save ~25GB if you remove .obj files from *third_party/vcpkg/buildtrees*
  - Should allow you to debug third_party source
  - Downside: If you re-run setup.ps1, vcpkg will need to build all of these .obj again which could take several hours vs a few seconds if everything is already built
