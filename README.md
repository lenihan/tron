# tron - Qt/OpenSceneGraph based libraries and apps

## Prerequisites

### Windows

1. Install [PowerShell 7+ from Microsoft Store](https://www.microsoft.com/en-us/p/powershell/9mz1snwt0n5d)
2. Install Visual Studio 2022 Community
   1. Download and open [vs_Community.exe](https://aka.ms/vs/17/release/vs_community.exe)
   2.  Select *"Desktop development with C++"* Workload
   3.  Click *"Install"* button

### Ubuntu 20.04

1. [Installing PowerShell on Ubuntu](https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu)

### Mac

1. [Installing PowerShell on macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)

## Setup

1. Open PowerShell 7+ (pwsh) prompt
2. Update environment for dev tools
   * *WINDOWS* `& "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"`
3. `cd <TRON_REPO>`

3. `.\setup.ps1`

## Build

## Run

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
* out
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

