# tron - Qt/OpenSceneGraph based libraries and apps

## Prerequisites

### Windows

1. Install [PowerShell 7+ from Microsoft Store](https://www.microsoft.com/en-us/p/powershell/9mz1snwt0n5d)
2. Install *Visual Studio 2022 Community*
   1. Download and open [vs_Community.exe](https://aka.ms/vs/17/release/vs_community.exe)
   2.  Select *"Desktop development with C++"* Workload
   3.  Click *"Install"* button
3.  Install [Qt Visual Studio Tools](https://marketplace.visualstudio.com/items?itemName=TheQtCompany.QtVisualStudioTools2022)
    * Adds debugging extensions for Qt data types

### Linux

1. [Installing PowerShell on Ubuntu](https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu)

### Mac

1. [Installing PowerShell on macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)

## Setup

1. Open PowerShell 7+ (pwsh) prompt
2. Update environment for dev tools
   * *WINDOWS* `& "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"`
3. `cd <TRON_REPO>`
4.  `.\setup.ps1`

TODO: Make `setup` do all steps. Should be able to run from anywhere: cmd, bash, powershell 5, etc.

## Generate Build Files

`cmake .`

## Run

### Windows

1. Open `tron.sln` in Visual Studio 2022
2. Right click project you want to run in *Solution Explorer > Set as Startup Project* (project becomes **bold**)
3. Run via *Visual Studio > Debug > Start Debugging* (`F5`)

### Linux

### Mac


## Search

src 
out/meta

## Goals

* Simple - Err on the side of simple solutions that new users will easily understand
* Fast - Want to be able to develop fast, debug fast, iterate fast, run fast
* Easy - Things should "just work." 
* Crossplatform - Windows, Linux, Mac
* Multiple copies of repo 
* Run locally* 

## Hierarchy

* src
  * simple
  * mapView
  * propertyGrid
  * simEd_app
  * precompiled_header
* build
  * precompiled_header
  * public_includes
  * meta
  * platform
    * x64-windows_debug
      * obj
      * lib
      * bin
      * installed
        * mapView_app
        * propertyGrid_app
        * simEd_app
    * x64-windows_release
    * x64-osx_debug
    * x64-osx_release
    * x64-linux_debug
    * x64-linux_release
  * assets
  * scripts
  * third_party
    * vcpkg
  * ide
    * vscode
  * README.md
  * setup.ps1


## Create A CMake Project 

1. Create project folder under `~/repos/tron/src`
2. Create `CMakeLists.txt` in project folder
   1. [add_executable](https://cmake.org/cmake/help/latest/command/add_executable.html)
      * Links source code to executable 
   2. [find_package](https://cmake.org/cmake/help/latest/command/find_package.html)
      * Add third party header/library paths
   3. [target_link_libraries](https://cmake.org/cmake/help/latest/command/target_link_libraries.html)
      * Link executable to third party libaries 
3. Update `CmakeLists.txt` in root
   1. Add project folder via [add_subdirectory](https://cmake.org/cmake/help/latest/command/add_subdirectory.html)
4. Generate build files in `~/repos/tron/out`: `generate.ps1` `cmake -S ~/repos/tron -B ~/repos/tron/out`
5. Open IDE: `Invoke-Expression ~/repos/tron/out/tron.sln`
