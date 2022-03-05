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

1. Open Terminal
2. `pwsh`
3. `cd <TRON_REPO>`
4. `setup.ps1`

## Generate Build Files

1. Open Terminal
2. `pwsh`
3. `cd <TRON_REPO>`
4. `generate.ps1`

## Run

### Windows

#### Visual Studio 2022

1. Open Terminal
2. `pwsh`
3. `cd <TRON_REPO>`
4. `out/tron.sln`
5. Right click project you want to run in *Solution Explorer > Set as Startup Project* (project becomes **bold**)
6. Run via *Visual Studio > Debug > Start Debugging* (`F5`)

#### Visual Studio Code
TODO

#### WSL - Ubuntu
TODO
### Linux - Ubuntu

TODO
### Mac

TODO
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
* out


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
4. Generate build files in *tron/out*: Run `generate.ps1` 
   * What it does if you are running from repo root: `cmake -S . -B ./out`
5. Open IDE
   * Visual Studio: `.\out\tron.sln`

## CMake Tips

### CMake Comment

[CMake Comment Documentation](https://cmake.org/cmake/help/v3.1/manual/cmake-language.7.html#comments)

* Everything after `#` is a comment 
  * Like C++ `//`
* Everthing in betwee `#[[` and `]]` is a comment
  * Like C++ `/* ... */`
### Print Message/Variable

[CMake's Message Documentation](https://cmake.org/cmake/help/latest/command/message.html)

```cmake
message("Hello")
message(${PROJECT_NAME})
```
### Show All CMake Variables

Add this to a `CMakeLists.txt` and generate to see output

```cmake
foreach (_variableName ${_variableNames})
  message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
```