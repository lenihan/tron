# tron - Qt/OpenSceneGraph based libraries and apps

- [tron - Qt/OpenSceneGraph based libraries and apps](#tron---qtopenscenegraph-based-libraries-and-apps)
  - [Features](#features)
  - [Goals](#goals)
  - [Prerequisites](#prerequisites)
    - [Disk Space](#disk-space)
    - [Apps](#apps)
  - [Setup](#setup)
  - [Build/Run/Debug](#buildrundebug)
  - [Clean](#clean)
  - [Create A CMake Project](#create-a-cmake-project)
  - [CMake Tips](#cmake-tips)
    - [Helpful Documentation](#helpful-documentation)
    - [ALL\_BUILD and ZERO\_CHECK](#all_build-and-zero_check)
    - [Copy files](#copy-files)
    - [CMake Comment](#cmake-comment)
    - [Print Message/Variable](#print-messagevariable)
    - [Show All CMake Variables](#show-all-cmake-variables)
  - [Qt Tips](#qt-tips)
    - [Qt tools for Visual Studio](#qt-tools-for-visual-studio)
  - [OpenSceneGraph Tips](#openscenegraph-tips)
    - [OpenSceneGraph GitHub Discussions](#openscenegraph-github-discussions)
    - [OpenSceneGraph Google Group](#openscenegraph-google-group)
    - [OpenSceneGraph Books](#openscenegraph-books)
  - [Visual Studio Code](#visual-studio-code)
    - [Environment](#environment)
    - [To run CMake configure](#to-run-cmake-configure)

## Features
- F12 to look up symbols (both local and third party)
- Builds all third party dependencies locally
- Debug symbols including third party
- Source for third party
- Debug via one mouse click in VS Code (builds code, launches debug executable with gdb for active project)
- Cross platform: works on Linux, Mac, Windows
- Built around VS Code, but supports any IDE (including - Visual Studio on Windows)
- Builds/runs locally (after setup, can disconnect from internet and continue developing)
- Fast compilation via precompiled headers
- Fast linking via visibility/dllexport (only export symbols designated as public)

## Goals

- Simple - Err on the side of simple solutions that new users will easily understand
- Fast - Want to be able to develop fast, debug fast, iterate fast, run fast
- Easy - Things should "just work" or be easy to figure out
- Crossplatform - Windows, Linux, Mac
- Multiple copies of repo
- Run locally

## Prerequisites

### Disk Space

A full build uses about 150 GB of disk space.

### Apps

- ![Windows](./resources/icons/windows_16x16.png) Windows
  1. Install *Visual Studio 2022 Community*
     1. Download and open [vs_Community.exe](https://aka.ms/vs/17/release/vs_community.exe)
     2. Select *"Desktop development with C++"* Workload
     3. Click *"Install"* button
     * NOTE: To verify proper install, you should be able to run `cl` from the "Developer Command Prompt for VS 2022" without error.
  2. Open terminal and install `git`, `pwsh`, `cmake`, `perl`, and `code`
    ```pwsh
    'Git.Git', '9MZ1SNWT0N5D', 'cmake', 'StrawberryPerl.StrawberryPerl', 'XP9KHM4BK9FZ7Q' | % {winget install $_ --accept-source-agreements --accept-package-agreements}
    ```
  3. Close terminal (this terminal must be restarted to access newly installed apps)
     
- ![Linux](./resources/icons/linux_16x16.png) Linux
  1. Open terminal and install `pwsh`, `git`, and `code`
    ```pwsh
    sudo snap install powershell --channel=lts/stable --classic; sudo apt-get install git --yes; sudo snap install code --classic
    ```

- ![MacOS](./resources/icons/macos_16x16.png) Mac
  
  1. SIP (System Integrity Protection) must be disabled to run setup script. Follow [these](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection) instructions.
  2. Open terminal and install `brew` and `PowerShell`
  ```shell
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; brew install --cask powershell
  ```

## Setup

![Windows](./resources/icons/windows_16x16.png) Windows/![Linux](./resources/icons/linux_16x16.png) Linux/![MacOS](./resources/icons/macos_16x16.png) Mac
1. Open terminal and clone repo, run setup script (~1-2 hours)
  ```pwsh
  pwsh -Command "git clone https://github.com/lenihan/tron.git $HOME/repos/tron; ~/repos/tron/scripts/setup.ps1"
  ```

## Build/Run/Debug

- Visual Studio Code (![Windows](./resources/icons/windows_16x16.png) Windows/![Linux](./resources/icons/linux_16x16.png) Linux/![MacOS](./resources/icons/macos_16x16.png) Mac)
  1. Open terminal and launch Visual Studio Code with repo folder
    ```pwsh
    pwsh -Command "code $HOME/repos/tron"
    ```
  2. Install Workspace Recommended extensions
     - View > Extensions > Filter Extensions... > Recommended
     - Click "Install" on each extension
  3. To launch a target, click the "play" icon the status bar (bottom)
  4. Select a Kit
     - Windows: `Visual Studio Community 2022 Release - amd64`
     - Linux: `GCC 9.4.0 x86_64-linux-gnu`
     - Mac: `Clang 14.0.0 x86_64-apple-darwin 21.6.0`
  5. Select a launch target
     - `hello_cmake` to test CMake 
     - `hello_osg` to test OpenSceneGraph
     - `hello_qt` to test Qt  
  6. To launch debugger, click the "debug" icon in the status bar (bottom) 
- Visual Studio 2022 (![Windows](./resources/icons/windows_16x16.png) Windows)
  1. Open terminal and generate .sln file, launch in Visual Studio
    ```pwsh
    pwsh -Command "cmake -S ~/repos/tron -B ~/repos/tron/build; ~/repos/tron/build/tron.sln"
    ``` 
  2. Solution Explorer > Right click on project > Set as Startup Project
     - `hello_cmake` to test CMake 
     - `hello_osg` to test OpenSceneGraph
     - `hello_qt` to test Qt  
  3. Debug > Start Debugging 

## Clean

All output (CMake, compiler, linker, etc.) go to *./build* directory. To clean up, delete *./build*.

## Create A CMake Project 

See `~/repos/tron/src/hello/hello_cmake/CMakeLists.txt` for a simple example.

1. Create `CMakeLists.txt` in project directory under `~/repos/tron/src`
2. First line sets project name: `project(<PROJECT_NAME>)`
3. Add `project_common()` to get settings that apply to all projects.
4. Add source code to compile via [add_executable](https://cmake.org/cmake/help/latest/command/add_executable.html)
5. Link libraries with [target_link_libraries](https://cmake.org/cmake/help/latest/command/target_link_libraries.html)
6. Add project directory to  `~/repos/tron/CmakeLists.txt` with [add_subdirectory](https://cmake.org/cmake/help/latest/command/add_subdirectory.html)
7. Generate build files in *./build*
  ```pwsh
  pwsh -Command 'cmake -S ~/repos/tron -B ~/repos/tron/build'
  ```


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

Use `configure_file` to copy files. The copy happens during CMake build file generation. See `src/sandbox/QTreeView` for an example.

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
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
```

## Qt Tips

### Qt tools for Visual Studio

* Install [Qt Visual Studio Tools](https://marketplace.visualstudio.com/items?itemName=TheQtCompany.QtVisualStudioTools2022)
  * Adds debugging extensions for Qt data types

## OpenSceneGraph Tips

### OpenSceneGraph GitHub Discussions

Where OpenSceneGraph Q&A happens today. This is active.

<https://github.com/openscenegraph/OpenSceneGraph/discussions>

### OpenSceneGraph Google Group

Email forum with 18,000+ conversations. This is where most questions are posted/answered. No longer active, but contains lots of Questions and answers.

<https://groups.google.com/g/osg-users>

### OpenSceneGraph Books

- [OpenSceneGraph 3.0: Beginner's Guide](https://www.amazon.com/OpenSceneGraph-3-0-Beginners-Rui-Wang-ebook/dp/B0057761U4)
- [OpenSceneGraph 3 Cookbook](https://www.amazon.com/OpenSceneGraph-3-Cookbook-Rui-Wang/dp/184951688X)

## Visual Studio Code

### Environment

Required environment variables are embedded in vs code workspace. You do not need to modify your environment to run/debug apps within vs code.

### To run CMake configure

This should happen automatically as needed (for example, when you click on Build).

To run manually: Ctrl+Shift+P > CMake: Configure
