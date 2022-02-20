# tron - Qt/OpenSceneGraph based libraries and apps

## Setup

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
    * setup
    * setup.bat
    * setup.ps1
  * third_party
    * vcpkg
  * ide
    * vscode
  * README.md

