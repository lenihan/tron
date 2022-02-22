# CMakeList.txt : CMake project for hello_qt, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)

# Add source to this project's executable.
add_executable (hello_qt "hello_qt.cpp")

# find_package(Qt5 ...) files...
# vcpkg\installed\x64-windows\share\cmake\Qt5\Qt5Config.cmake
# vcpkg\installed\x64-windows\share\cmake\Qt5\Qt5ModuleLocation.cmake
#  
# vcpkg\ports\qtbase\portfile.cmake
# vcpkg\ports\qtbase\cmake\qt_port_details.cmake
# vcpkg\ports\qtbase\vcpkg.json
message("hello_qt!!!!!!!!!!!!!!!!")
find_package(Qt5 COMPONENTS Widgets REQUIRED)  

target_link_libraries(hello_qt Qt5::Widgets)

# TODO:
# 1: Add step to copy         C:\Users\david\src\hello_world\third_party\vcpkg\buildtrees\qt5-base\x64-windows-dbg\plugins\platforms to 
#                             C:\Users\david\src\hello_world\out\build\x64-Debug\src\hello_qt
# 2: Copy required dll's/pdb's  
#    cp  C:\Users\david\src\hello_world\third_party\vcpkg\installed\x64-windows\debug\bin\* C:\Users\david\src\hello_world\out\build\x64-Debug\src\hello_qt
# 3: Fix out\build\x64-Debug\src\hello_qt\hello_qt.exe...remove src
# DONE! 4: Get rid of david...make generic
# DONE! 5: Integrate vcpkg...see vcpkg/readme.md
# DONE! 6: Can't step into Qt source code...fix!
# 7: Make .pdb know where source code is by calling `subst k: ~\src\hello_world\third_party\vcpkg` from cmake