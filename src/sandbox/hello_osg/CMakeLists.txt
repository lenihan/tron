# CMakeList.txt : CMake project for hello_qt, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)

# Add source to this project's executable.
add_executable (hello_osg "hello_osg.cpp")


find_package(osgViewer REQUIRED)
find_package(osgDB REQUIRED)

target_link_libraries(hello_osg ${OSGVIEWER_LIBRARIES})
target_link_libraries(hello_osg ${OSGDB_LIBRARIES})

# TODO:
# 1: Add step to copy         C:\Users\david\src\hello_world\third_party\vcpkg\buildtrees\qt5-base\x64-windows-dbg\plugins\platforms to 
#                             C:\Users\david\src\hello_world\out\build\x64-Debug\src\hello_qt

# NOTE: Does vcpkg.cmake already do dependency copy? 
#       See C:\Users\david\src\hello_world\third_party\vcpkg\scripts\buildsystems\vcpkg.cmake
#		    option(VCPKG_APPLOCAL_DEPS "Automatically copy dependencies into the output directory for executables." ON)
#           option(X_VCPKG_APPLOCAL_DEPS_SERIALIZED "(experimental) Add USES_TERMINAL to VCPKG_APPLOCAL_DEPS to force serialization." OFF)

# requires CMake 3.14
option(X_VCPKG_APPLOCAL_DEPS_INSTALL "(experimental) Automatically copy dependencies into the install target directory for executables. Requires CMake 3.14." OFF)

# 2: Copy required dll's/pdb's  
#    cp  C:\Users\david\src\hello_world\third_party\vcpkg\installed\x64-windows\debug\bin\* C:\Users\david\src\hello_world\out\build\x64-Debug\src\hello_qt
# 3: Fix out\build\x64-Debug\src\hello_qt\hello_qt.exe...remove src
# DONE! 4: Get rid of david...make generic
# DONE! 5: Integrate vcpkg...see vcpkg/readme.md
# DONE! 6: Can't step into Qt source code...fix!
# 7: Make .pdb know where source code is by calling `subst k: ~\src\hello_world\third_party\vcpkg` from cmake