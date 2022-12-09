# tron - Qt/OpenSceneGraph based libraries and apps

- [tron - Qt/OpenSceneGraph based libraries and apps](#tron---qtopenscenegraph-based-libraries-and-apps)
  - [Goals](#goals)
  - [Prerequisites](#prerequisites)
    - [Disk Space](#disk-space)
    - [Apps](#apps)
  - [Setup](#setup)
  - [Debug](#debug)
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
    - [Qt Examples](#qt-examples)
      - [Run Examples](#run-examples)
    - [Qt tools for Visual Studio](#qt-tools-for-visual-studio)
  - [OSG Tips](#osg-tips)
    - [OSG Google Group](#osg-google-group)
    - [OSG Examples](#osg-examples)
      - [Run Examples](#run-examples-1)
    - [Run osgviewer](#run-osgviewer)
    - [Run osgconv](#run-osgconv)
  - [Visual Studio Code](#visual-studio-code)
  - [Environment](#environment)
    - [CMake Building, Running, Debugging](#cmake-building-running-debugging)
    - [One Time Setup](#one-time-setup)
    - [To reset](#to-reset)
    - [To run CMake configure](#to-run-cmake-configure)
  - [TODO](#todo)

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

- Windows
  1. Install *Visual Studio 2022 Community*
     1. Download and open [vs_Community.exe](https://aka.ms/vs/17/release/vs_community.exe)
     2. Select *"Desktop development with C++"* Workload
     3. Click *"Install"* button
     * NOTE: To verify proper install, you should be able to run `cl` from the "Developer Command Prompt for VS 2022" without error.
  2. Open Terminal
  3. Install apps: git, pwsh, cmake, perl, code...
    ```pwsh
    powershell -Command '"Git.Git", "9MZ1SNWT0N5D", "cmake", "StrawberryPerl.StrawberryPerl", "XP9KHM4BK9FZ7Q" | ForEach-Object {winget install $_ --accept-source-agreements --accept-package-agreements}'
    ```
  4. Close Terminal (this terminal must be restarted to access newly installed apps)
     
- Linux
  1. Open Terminal
  2. Install apps: pwsh, git, code
    ```pwsh
    sudo snap install powershell --channel=lts/stable --classic; sudo apt-get install git --yes; sudo snap install code --classic
    ```

- Mac
  1. Install brew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  2. Install PowerShell: `brew install –cask powershell`


## Setup

1. Open Terminal
2. Clone repo and run setup script (~2-3 hours)...
  ```pwsh
  pwsh -Command 'git clone https://github.com/lenihan/tron.git ~/repos/tron; ~/repos/tron/scripts/setup.ps1'
  ```

## Debug

- Visual Studio Code
  1. Open Terminal
  2. Launch Visual Studio Code with repo folder
    ```pwsh
    pwsh -Command 'code ~/repos/tron'
    ```
  3. Install Workspace Recommended extensions
     - View > Extensions > Filter Extensions... > Recommended
     - Click "Install" on each extension
  4. To launch a target, click the "play" icon the status bar (bottom)
  5. Select a Kit
     - Windows: `Visual Studio Community 2022 Release - amd64`
     - Linux: `GCC 9.4.0 x86_64-linux-gnu`
     - Mac: TODO
  6. Select a launch target
     - `hello_qt` to test Qt  
     - `hello_osg` to test OpenSceneGraph
  7. To launch debugger, click the "debug" icon in the status bar (bottom) 
- Windows: Visual Studio 2022
  1. Generate .sln file, launch in Visual Studio
    ```pwsh
    pwsh -Command 'cmake -S ~/repos/tron -B ~/repos/tron/build; ~/repos/tron/build/tron.sln'
    ``` 
  2. Solution Explorer > Right click on project > Set as Startup Project
     - `hello_qt` to test Qt  
     - `hello_osg` to test OpenSceneGraph
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
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
```

## Qt Tips

### Qt Examples

There are 231 examples.

Source:
* `~/repos/tron/third_party/qt5/qtbase/examples`

Binaries:
* `~/repos/tron/third_party/qt5/build/qtbase/examples          # Windows`
* `~/repos/tron/third_party/qt5/build/Release/qtbase/examples  # Linux`

#### Run Examples

```powershell
~/repos/tron/scripts/apply_environment_file.ps1
$LINUX_CONFIG = $IsLinux ? "Debug" : ""
$WINDOWS_CONFIG = $IsLinux ? "" : "debug"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/xml/htmlinfo/$WINDOWS_CONFIG/htmlinfo"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/xml/streambookmarks/$WINDOWS_CONFIG/streambookmarks"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/xml/rsslisting/$WINDOWS_CONFIG/rsslisting"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/xml/dombookmarks/$WINDOWS_CONFIG/dombookmarks"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/xml/xmlstreamlint/$WINDOWS_CONFIG/xmlstreamlint"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/gui/analogclock/$WINDOWS_CONFIG/analogclock"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/gui/openglwindow/$WINDOWS_CONFIG/openglwindow"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/gui/rasterwindow/$WINDOWS_CONFIG/rasterwindow"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/mimetypes/mimetypebrowser/$WINDOWS_CONFIG/mimetypebrowser"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/ipc/localfortuneserver/$WINDOWS_CONFIG/localfortuneserver"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/ipc/localfortuneclient/$WINDOWS_CONFIG/localfortuneclient"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/ipc/sharedmemory/$WINDOWS_CONFIG/sharedmemory"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/threads/waitconditions/$WINDOWS_CONFIG/waitconditions"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/threads/queuedcustomtype/$WINDOWS_CONFIG/queuedcustomtype"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/threads/semaphores/$WINDOWS_CONFIG/semaphores"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/threads/mandelbrot/$WINDOWS_CONFIG/mandelbrot"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/tools/customtype/$WINDOWS_CONFIG/customtype"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/tools/customtypesending/$WINDOWS_CONFIG/customtypesending"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/tools/contiguouscache/$WINDOWS_CONFIG/contiguouscache"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/serialization/convert/$WINDOWS_CONFIG/convert"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/serialization/cbordump/$WINDOWS_CONFIG/cbordump"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/corelib/serialization/savegame/$WINDOWS_CONFIG/savegame"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtconcurrent/wordcount/$WINDOWS_CONFIG/wordcount"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtconcurrent/progressdialog/$WINDOWS_CONFIG/progressdialog"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtconcurrent/runfunction/$WINDOWS_CONFIG/runfunction"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtconcurrent/imagescaling/$WINDOWS_CONFIG/imagescaling"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/sqlbrowser/$WINDOWS_CONFIG/sqlbrowser"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/sqlwidgetmapper/$WINDOWS_CONFIG/sqlwidgetmapper"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/cachedtable/$WINDOWS_CONFIG/cachedtable"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/tablemodel/$WINDOWS_CONFIG/tablemodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/drilldown/$WINDOWS_CONFIG/drilldown"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/books/$WINDOWS_CONFIG/books"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/relationaltablemodel/$WINDOWS_CONFIG/relationaltablemodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/masterdetail/$WINDOWS_CONFIG/masterdetail"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/sql/querymodel/$WINDOWS_CONFIG/querymodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/$WINDOWS_CONFIG/widgets"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/desktop/screenshot/$WINDOWS_CONFIG/screenshot"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/desktop/systray/$WINDOWS_CONFIG/systray"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/gallery/$WINDOWS_CONFIG/gallery"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/animation/easing/$WINDOWS_CONFIG/easing"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/animation/states/$WINDOWS_CONFIG/states"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/animation/moveblocks/$WINDOWS_CONFIG/moveblocks"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/animation/sub-attaq/sub-$WINDOWS_CONFIG/attaq"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/animation/animatedtiles/$WINDOWS_CONFIG/animatedtiles"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/animation/stickman/$WINDOWS_CONFIG/stickman"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/richtext/syntaxhighlighter/$WINDOWS_CONFIG/syntaxhighlighter"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/richtext/textedit/$WINDOWS_CONFIG/textedit"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/richtext/calendar/$WINDOWS_CONFIG/calendar"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/richtext/orderform/$WINDOWS_CONFIG/orderform"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/dialogs/findfiles/$WINDOWS_CONFIG/findfiles"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/dialogs/licensewizard/$WINDOWS_CONFIG/licensewizard"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/dialogs/tabdialog/$WINDOWS_CONFIG/tabdialog"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/dialogs/extension/$WINDOWS_CONFIG/extension"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/dialogs/classwizard/$WINDOWS_CONFIG/classwizard"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/dialogs/trivialwizard/$WINDOWS_CONFIG/trivialwizard"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/dialogs/standarddialogs/$WINDOWS_CONFIG/standarddialogs"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/spinboxdelegate/$WINDOWS_CONFIG/spinboxdelegate"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/coloreditorfactory/$WINDOWS_CONFIG/coloreditorfactory"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/stardelegate/$WINDOWS_CONFIG/stardelegate"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/fetchmore/$WINDOWS_CONFIG/fetchmore"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/spreadsheet/$WINDOWS_CONFIG/spreadsheet"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/interview/$WINDOWS_CONFIG/interview"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/customsortfiltermodel/$WINDOWS_CONFIG/customsortfiltermodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/frozencolumn/$WINDOWS_CONFIG/frozencolumn"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/puzzle/$WINDOWS_CONFIG/puzzle"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/storageview/$WINDOWS_CONFIG/storageview"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/flattreeview/$WINDOWS_CONFIG/flattreeview"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/simpletreemodel/$WINDOWS_CONFIG/simpletreemodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/combowidgetmapper/$WINDOWS_CONFIG/combowidgetmapper"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/simplewidgetmapper/$WINDOWS_CONFIG/simplewidgetmapper"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/editabletreemodel/$WINDOWS_CONFIG/editabletreemodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/simpledommodel/$WINDOWS_CONFIG/simpledommodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/basicsortfiltermodel/$WINDOWS_CONFIG/basicsortfiltermodel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/pixelator/$WINDOWS_CONFIG/pixelator"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/dirview/$WINDOWS_CONFIG/dirview"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/addressbook/$WINDOWS_CONFIG/addressbook"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/itemviews/chart/$WINDOWS_CONFIG/chart"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/touch/knobs/$WINDOWS_CONFIG/knobs"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/touch/fingerpaint/$WINDOWS_CONFIG/fingerpaint"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/touch/pinchzoom/$WINDOWS_CONFIG/pinchzoom"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/touch/dials/$WINDOWS_CONFIG/dials"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/pathstroke/$WINDOWS_CONFIG/pathstroke"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/fontsampler/$WINDOWS_CONFIG/fontsampler"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/transformations/$WINDOWS_CONFIG/transformations"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/concentriccircles/$WINDOWS_CONFIG/concentriccircles"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/affine/$WINDOWS_CONFIG/affine"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/gradients/$WINDOWS_CONFIG/gradients"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/basicdrawing/$WINDOWS_CONFIG/basicdrawing"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/imagecomposition/$WINDOWS_CONFIG/imagecomposition"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/deform/$WINDOWS_CONFIG/deform"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/painterpaths/$WINDOWS_CONFIG/painterpaths"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/painting/composition/$WINDOWS_CONFIG/composition"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/shapedclock/$WINDOWS_CONFIG/shapedclock"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/styles/$WINDOWS_CONFIG/styles"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/calculator/$WINDOWS_CONFIG/calculator"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/mousebuttons/$WINDOWS_CONFIG/mousebuttons"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/elidedlabel/$WINDOWS_CONFIG/elidedlabel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/lineedits/$WINDOWS_CONFIG/lineedits"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/tooltips/$WINDOWS_CONFIG/tooltips"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/wiggly/$WINDOWS_CONFIG/wiggly"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/groupbox/$WINDOWS_CONFIG/groupbox"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/analogclock/$WINDOWS_CONFIG/analogclock"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/codeeditor/$WINDOWS_CONFIG/codeeditor"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/stylesheet/$WINDOWS_CONFIG/stylesheet"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/movie/$WINDOWS_CONFIG/movie"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/calendarwidget/$WINDOWS_CONFIG/calendarwidget"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/windowflags/$WINDOWS_CONFIG/windowflags"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/validators/$WINDOWS_CONFIG/validators"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/tetrix/$WINDOWS_CONFIG/tetrix"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/scribble/$WINDOWS_CONFIG/scribble"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/digitalclock/$WINDOWS_CONFIG/digitalclock"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/sliders/$WINDOWS_CONFIG/sliders"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/spinboxes/$WINDOWS_CONFIG/spinboxes"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/icons/$WINDOWS_CONFIG/icons"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/imageviewer/$WINDOWS_CONFIG/imageviewer"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/widgets/charactermap/$WINDOWS_CONFIG/charactermap"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/gestures/imagegestures/$WINDOWS_CONFIG/imagegestures"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/basicgraphicslayouts/$WINDOWS_CONFIG/basicgraphicslayouts"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/padnavigator/$WINDOWS_CONFIG/padnavigator"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/collidingmice/$WINDOWS_CONFIG/collidingmice"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/dragdroprobot/$WINDOWS_CONFIG/dragdroprobot"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/diagramscene/$WINDOWS_CONFIG/diagramscene"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/flowlayout/$WINDOWS_CONFIG/flowlayout"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/weatheranchorlayout/$WINDOWS_CONFIG/weatheranchorlayout"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/anchorlayout/$WINDOWS_CONFIG/anchorlayout"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/chip/$WINDOWS_CONFIG/chip"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/elasticnodes/$WINDOWS_CONFIG/elasticnodes"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/boxes/$WINDOWS_CONFIG/boxes"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/simpleanchorlayout/$WINDOWS_CONFIG/simpleanchorlayout"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/graphicsview/embeddeddialogs/$WINDOWS_CONFIG/embeddeddialogs"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/mainwindows/application/$WINDOWS_CONFIG/application"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/mainwindows/dockwidgets/$WINDOWS_CONFIG/dockwidgets"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/mainwindows/mdi/$WINDOWS_CONFIG/mdi"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/mainwindows/sdi/$WINDOWS_CONFIG/sdi"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/mainwindows/mainwindow/$WINDOWS_CONFIG/mainwindow"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/mainwindows/menus/$WINDOWS_CONFIG/menus"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/statemachine/pingpong/$WINDOWS_CONFIG/pingpong"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/statemachine/rogue/$WINDOWS_CONFIG/rogue"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/statemachine/trafficlight/$WINDOWS_CONFIG/trafficlight"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/statemachine/factorial/$WINDOWS_CONFIG/factorial"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/statemachine/twowaybutton/$WINDOWS_CONFIG/twowaybutton"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/statemachine/eventtransitions/$WINDOWS_CONFIG/eventtransitions"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/scroller/graphicsview/$WINDOWS_CONFIG/graphicsview"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/notepad/$WINDOWS_CONFIG/notepad"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/widgets/toplevel/$WINDOWS_CONFIG/toplevel"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/widgets/nestedlayouts/$WINDOWS_CONFIG/nestedlayouts"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/widgets/childwidget/$WINDOWS_CONFIG/childwidget"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/widgets/windowlayout/$WINDOWS_CONFIG/windowlayout"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/gettingStarted/gsQt/part5/$WINDOWS_CONFIG/part5"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/gettingStarted/gsQt/part3/$WINDOWS_CONFIG/part3"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/gettingStarted/gsQt/part2/$WINDOWS_CONFIG/part2"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/gettingStarted/gsQt/part1/$WINDOWS_CONFIG/part1"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/gettingStarted/gsQt/part4/$WINDOWS_CONFIG/part4"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/addressbook/part7/$WINDOWS_CONFIG/part7"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/addressbook/part6/$WINDOWS_CONFIG/part6"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/addressbook/part5/$WINDOWS_CONFIG/part5"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/addressbook/part3/$WINDOWS_CONFIG/part3"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/addressbook/part2/$WINDOWS_CONFIG/part2"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/addressbook/part1/$WINDOWS_CONFIG/part1"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tutorials/addressbook/part4/$WINDOWS_CONFIG/part4"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/effects/fademessage/$WINDOWS_CONFIG/fademessage"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/effects/blurpicker/$WINDOWS_CONFIG/blurpicker"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/layouts/borderlayout/$WINDOWS_CONFIG/borderlayout"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/layouts/dynamiclayouts/$WINDOWS_CONFIG/dynamiclayouts"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/layouts/flowlayout/$WINDOWS_CONFIG/flowlayout"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/layouts/basiclayouts/$WINDOWS_CONFIG/basiclayouts"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/draganddrop/draggableicons/$WINDOWS_CONFIG/draggableicons"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/draganddrop/fridgemagnets/$WINDOWS_CONFIG/fridgemagnets"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/draganddrop/draggabletext/$WINDOWS_CONFIG/draggabletext"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/draganddrop/puzzle/$WINDOWS_CONFIG/puzzle"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/draganddrop/dropsite/$WINDOWS_CONFIG/dropsite"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/regexp/$WINDOWS_CONFIG/regexp"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/echoplugin/$WINDOWS_CONFIG/echoplugin"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/plugandpaint/$WINDOWS_CONFIG/plugandpaint"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/codecs/$WINDOWS_CONFIG/codecs"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/regularexpression/$WINDOWS_CONFIG/regularexpression"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/settingseditor/$WINDOWS_CONFIG/settingseditor"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/customcompleter/$WINDOWS_CONFIG/customcompleter"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/styleplugin/$WINDOWS_CONFIG/styleplugin"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/i18n/$WINDOWS_CONFIG/i18n"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/undoframework/$WINDOWS_CONFIG/undoframework"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/treemodelcompleter/$WINDOWS_CONFIG/treemodelcompleter"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/undo/$WINDOWS_CONFIG/undo"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/tools/completer/$WINDOWS_CONFIG/completer"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/widgets/windowcontainer/$WINDOWS_CONFIG/windowcontainer"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/textures/$WINDOWS_CONFIG/textures"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/hellogles3/$WINDOWS_CONFIG/hellogles3"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/qopenglwindow/$WINDOWS_CONFIG/qopenglwindow"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/qopenglwidget/$WINDOWS_CONFIG/qopenglwidget"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/threadedqopenglwidget/$WINDOWS_CONFIG/threadedqopenglwidget"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/cube/$WINDOWS_CONFIG/cube"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/computegles31/$WINDOWS_CONFIG/computegles31"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/2dpainting/$WINDOWS_CONFIG/2dpainting"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/contextinfo/$WINDOWS_CONFIG/contextinfo"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/hellogl2/$WINDOWS_CONFIG/hellogl2"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/hellowindow/$WINDOWS_CONFIG/hellowindow"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/opengl/paintedwindow/$WINDOWS_CONFIG/paintedwindow"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/dbus/remotecontrolledcar/controller/$WINDOWS_CONFIG/controller"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/dbus/remotecontrolledcar/car/$WINDOWS_CONFIG/car"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/dbus/chat/$WINDOWS_CONFIG/chat"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/dbus/listnames/$WINDOWS_CONFIG/listnames"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtestlib/tutorial1/$WINDOWS_CONFIG/tutorial1"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtestlib/tutorial5/$WINDOWS_CONFIG/tutorial5"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtestlib/tutorial2/$WINDOWS_CONFIG/tutorial2"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtestlib/tutorial4/$WINDOWS_CONFIG/tutorial4"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qtestlib/tutorial3/$WINDOWS_CONFIG/tutorial3"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/vulkan/hellovulkanwidget/$WINDOWS_CONFIG/hellovulkanwidget"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/vulkan/hellovulkantriangle/$WINDOWS_CONFIG/hellovulkantriangle"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/vulkan/hellovulkantexture/$WINDOWS_CONFIG/hellovulkantexture"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/vulkan/hellovulkanwindow/$WINDOWS_CONFIG/hellovulkanwindow"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/vulkan/hellovulkancubes/$WINDOWS_CONFIG/hellovulkancubes"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/secureudpserver/$WINDOWS_CONFIG/secureudpserver"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/downloadmanager/$WINDOWS_CONFIG/downloadmanager"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/broadcastsender/$WINDOWS_CONFIG/broadcastsender"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/http/$WINDOWS_CONFIG/http"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/loopback/$WINDOWS_CONFIG/loopback"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/blockingfortuneclient/$WINDOWS_CONFIG/blockingfortuneclient"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/multicastsender/$WINDOWS_CONFIG/multicastsender"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/broadcastreceiver/$WINDOWS_CONFIG/broadcastreceiver"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/secureudpclient/$WINDOWS_CONFIG/secureudpclient"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/download/$WINDOWS_CONFIG/download"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/dnslookup/$WINDOWS_CONFIG/dnslookup"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/network-chat/network-$WINDOWS_CONFIG/chat"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/fortuneclient/$WINDOWS_CONFIG/fortuneclient"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/fortuneserver/$WINDOWS_CONFIG/fortuneserver"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/threadedfortuneserver/$WINDOWS_CONFIG/threadedfortuneserver"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/torrent/$WINDOWS_CONFIG/torrent"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/googlesuggest/$WINDOWS_CONFIG/googlesuggest"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/securesocketclient/$WINDOWS_CONFIG/securesocketclient"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/network/multicastreceiver/$WINDOWS_CONFIG/multicastreceiver"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qpa/windows/$WINDOWS_CONFIG/windows"
iex "$HOME/repos/tron/third_party/qt5/build/$LINUX_CONFIG/qtbase/examples/qpa/qrasterwindow/$WINDOWS_CONFIG/qrasterwindow"
```

### Qt tools for Visual Studio

* Install [Qt Visual Studio Tools](https://marketplace.visualstudio.com/items?itemName=TheQtCompany.QtVisualStudioTools2022)
  * Adds debugging extensions for Qt data types

## OSG Tips

### OSG Google Group

Email forum with 18,000+ conversations. This is where most questions are posted/answered. Still active. 

<https://groups.google.com/g/osg-users>

### OSG Examples

There are 176 examples.

Source:
* `~/repos/tron/third_party/OpenSceneGraph/examples`
Binaries:
* `~/repos/tron/third_party/OpenSceneGraph/build/Release/bin`
* `~/repos/tron/third_party/OpenSceneGraph/build/Debug/bin`

#### Run Examples

```powershell
~/repos/tron/scripts/apply_environment_file.ps1
osg2cpp
osganalysis
osganimate
osganimationeasemotion
osganimationhardware
osganimationmakepath
osganimationmorph
osganimationnode
osganimationskinning
osganimationsolid
osganimationtimeline
osganimationviewer
osgatomiccounter
osgautocapture
osgautotransform
osgbillboard
osgbindlesstext
osgblenddrawbuffers
osgblendequation
osgcallback
osgcamera
osgcatch
osgclip
osgcluster
osgCMakeExample
osgcompositeviewer
osgcomputeshaders
osgcopy
osgcubemap
osgdatabaserevisions
osgdeferred
osgdepthpartition
osgdepthpeeling
osgdirectinput
osgdistortion
osgdrawinstanced
osgemscripten
osgfadetext
osgfont
osgforest
osgfpdepth
osgframerenderer
osgfxbrowser
osggameoflife
osggeometry
osggeometryshaders
osggpucull
osggpx
osggraphicscost
osghangglide
osghud
osgimagesequence
osgimpostor
osgintersection
osgkdtree
osgkeyboard
osgkeyboardmouse
osgkeystone
osglauncher
osglight
osglightpoint
osglogicop
osglogo
osgmanipulator
osgmemorytest
osgmotionblur
osgmovie
osgmultiplemovies
osgmultiplerendertargets
osgmultitexture
osgmultitexturecontrol
osgmultitouch
osgmultiviewpaging
osgobjectcache
osgoccluder
osgocclusionquery
osgoit
osgoscdevice
osgoutline
osgpackeddepthstencil
osgpagedlod
osgparametric
osgparticle
osgparticleeffects
osgparticleshader
osgpdf
osgphotoalbum
osgpick
osgplanets
osgpoints
osgpointsprite
osgposter
osgprecipitation
osgprerender
osgprerendercubemap
osgpresentation
osgreflect
osgrobot
osgsampler
osgscalarbar
osgscreencapture
osgscribe
osgsequence
osgshadercomposition
osgshadergen
osgshadermultiviewport
osgshaderpipeline
osgshaders
osgshaderterrain
osgshadow
osgshape
osgsharedarray
osgsidebyside
osgsimplegl3
osgsimpleMDI
osgsimpleshaders
osgsimplifier
osgsimulation
osgslice
osgspacewarp
osgspheresegment
osgspotlight
osgSSBO
osgstaticviewer
osgstereoimage
osgstereomatch
osgteapot
osgterrain
osgtessellate
osgtessellationshaders
osgtext
osgtext3D
osgtexture1D
osgtexture2D
osgtexture2DArray
osgtexture3D
osgtexturecompression
osgtexturerectangle
osgthirdpersonview
osgthreadedterrain
osgtransferfunction
osgtransformfeedback
osguniformbuffer
osgunittests
osguserdata
osguserstats
osgvertexattributes
osgvertexprogram
osgviewerCocoa
osgviewerFLTK
osgviewerFOX
osgviewerGTK
osgviewerIPhone
osgviewerMFC
osgviewerSDL
osgviewerWX
osgvirtualprogram
osgvnc
osgvolume
osgwidgetaddremove
osgwidgetbox
osgwidgetcanvas
osgwidgetframe
osgwidgetinput
osgwidgetlabel
osgwidgetmenu
osgwidgetmessagebox
osgwidgetnotebook
osgwidgetperformance
osgwidgetprogress
osgwidgetscrolled
osgwidgetshader
osgwidgetstyled
osgwidgettable
osgwidgetwindow
osgwindows
```


### Run osgviewer

```powershell
~/repos/tron/scripts/apply_environment_file.ps1
osgviewer cow.osg
```

### Run osgconv

```powershell
~/repos/tron/scripts/apply_environment_file.ps1
osgconv
```

## Visual Studio Code

## Environment

Required environment variables are embedded in vs code workspace. You do not need to modify your environment to run/debug apps within vs code.
### CMake Building, Running, Debugging

From <https://code.visualstudio.com/docs/cpp/cmake-linux>

You control CMake via buttons in the status bar on the bottom. Button descriptions from left to right.

1. Select Build Variant: Debug, Release, MinSizeRel, RelWithDebInfo. "CMake: [Debug]: Ready" (i in a circle icon)
2. Select Active Kit - compiler/linker/build sytem (wrench icon). Current kit in brackets. For Windows, Visual Studio Community 2022, I selected "Visual Studio Community 2022 Release - amd64"
3. Build the selected target. "Build" (gear icon).
4. Set the default target. Target is listed in brackets.
5. Launch debugger for selected target (bug icon).
6. Launch selected target in terminal window (play icon).
7. Set the target to launch. Launch target listed in brackets.

### One Time Setup

1. Verify Build Variant (i.e `Debug`)
2. Verify active kit in status bar is expected (i.e. `Visual Studio Community 2022 Release - amd64`)
3. Verify default build target (i.e. `ALL_BUILD`)
4. Verify launch target (i.e. `hello_osg`)
5. To start debugging, click on bug icon in status bar

### To reset

Delete ./build directory

### To run CMake configure

This should happen automatically as needed (for example, when you click on Build).

To run manually: Ctrl+Shift+P > CMake: Configure

To start debugger (CMake): Ctrl+F5

## TODO

- Get pdb to work for osgTerrain (symbols not loading for some reason, works for other OSG elements)
- Create a library that goes to ./include and ./build/lib
- cpack: create .msi/.deb installer https://cmake.org/cmake/help/latest/manual/cpack.1.html#manual:cpack(1)
- ctest - unit test
- cmake vs bazel - pro/con
  - VS Code plugins
    - CMake - <https://github.com/microsoft/vscode-cmake-tools>
      - 2,674 commits
      - 117 contributors
      - As of 5/13/22: 20 hours since last commit
    - Bazel - <https://github.com/bazelbuild/vscode-bazel>
      - 182 commits
      - 25 contributors
      - As of 5/13/22, 3.5 months since last commit
- Test in Qt Creator, Clion, others?
- Document Visual Studio, Visual Studio Code building, debugging, running
- Integration with Bazel:
  - Bazel ingest CMake
    - <https://github.com/bazelbuild/rules_foreign_cc>
  - CMake to bazel generator
- List all osg environment variables like from here https://github.com/esmini/esmini/blob/master/docs/osg_options_and_env_variables.txt?msclkid=32f39220b03511ec8ba55e72d8c7b519
- Document osg .exe's: examples, tools
- Get Qt apps to run from command line
- Document qt apps
- Make hello_osg do something
- Build for VS Code, document
- Build on WSL - Ubuntu, document
- Build on Ubuntu, document
- Build on mac, document
- You can save ~25GB if you remove .obj files from *third_party/vcpkg/buildtrees*
  - Should allow you to debug third_party source
  - Downside: If you re-run setup.ps1, vcpkg will need to build all of these .obj again which could take several hours vs a few seconds if everything is already built
- List OSG books
- List links to Qt/OSG API's
