project(hello_osg)
add_executable (
    ${PROJECT_NAME} 
    hello_osg.cpp
    Assets/reflect.rgb
)

find_package(osg REQUIRED)
find_package(osgViewer REQUIRED)
find_package(osgGA REQUIRED)
find_package(osgSim REQUIRED)
find_package(osgDB REQUIRED)
find_package(OpenGL)


target_link_libraries(${PROJECT_NAME} ${OSG_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGGA_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGSIM_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGDB_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OPENGL_LIBRARIES})


# Copy files to each configuration (Debug/Release/MilSizeRel/RelWithDebugInfo)
foreach(CONFIG IN LISTS CMAKE_CONFIGURATION_TYPES)
    configure_file(
        Assets/reflect.rgb
        ${CONFIG}/Assets/reflect.rgb
        COPYONLY
    )
endforeach()

# Create "Asset" folder in Visual Studio
source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR} 
    FILES Assets/reflect.rgb
)

# TODO: 
# Copy to Debug "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\debug\tools\osg\osgPlugins-3.6.5\osgdb_rgbd.dll"
# Copy to Debug "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\debug\tools\osg\osgPlugins-3.6.5\osgdb_rgbd.pdb"
# Copy to Release "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\osg\osgPlugins-3.6.5\osgdb_rgb.dll"
# Copy to Debug/Release: "C:\Users\david\repos\tron\third_party\OpenSceneGraph-Data\Images\reflect.rgb"
# Use reflect.png instead of rgb, converted via https://convertio.co/ (document this), saved in downloads
# Even better: use ~\repos\tron\third_party\vcpkg\installed\x64-windows\tools\osg\osgconv.exe...but it doesn't run for me from...fix this!
#   Use process monitor to figure out: 
#     1. start process monitor
#     2. Start capture
#     3. run C:\Users\david\repos\tron\third_party\vcpkg\buildtrees\osg\x64-windows-rel\bin\osgconv.exe
#     4. stop capture
#     5. Only show threads/process messages
#     6. search for osgconv.exe
#     7. right click process start pid > Include 'XXXXXX'
# List all osg environment variables like from here https://github.com/esmini/esmini/blob/master/docs/osg_options_and_env_variables.txt?msclkid=32f39220b03511ec8ba55e72d8c7b519



# OSGCONV.EXE
# 4 output locations for osg .exe's...
#       C:\Users\david\repos\tron\third_party\vcpkg\buildtrees\osg\x64-windows-dbg\bin\osgconvd.exe
#       C:\Users\david\repos\tron\third_party\vcpkg\buildtrees\osg\x64-windows-rel\bin\osgconv.exe
#       C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\osg\osgconv.exe
#       C:\Users\david\repos\tron\third_party\vcpkg\packages\osg_x64-windows\tools\osg\osgconv.exe

# OSG.DLL
# C:\Users\david\repos\tron\third_party\vcpkg\buildtrees\osg\x64-windows-rel\bin\osg.dll
# C:\Users\david\repos\tron\third_party\vcpkg\buildtrees\osg\x64-windows-dbg\bin\osgd.dll
# 
# C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\bin\osg.dll
# C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\debug\bin\osgd.dll
# 
# C:\Users\david\repos\tron\third_party\vcpkg\packages\osg_x64-windows\bin\osg.dll
# C:\Users\david\repos\tron\third_party\vcpkg\packages\osg_x64-windows\debug\bin\osgd.dll


# ZLIB1.DLL
# Can't find zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\buildtrees\zlib\x64-windows-rel\zlib1.dll

#   C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\openexr\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\qt5\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\qt5-activeqt\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\qt5-base\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\qt5-declarative\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\qt5-tools\bin\zlib1.dll

#   C:\Users\david\repos\tron\third_party\vcpkg\packages\openexr_x64-windows\tools\openexr\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\packages\qt5-activeqt_x64-windows\tools\qt5-activeqt\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\packages\qt5-base_x64-windows\tools\qt5\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\packages\qt5-base_x64-windows\tools\qt5-base\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\packages\qt5-declarative_x64-windows\tools\qt5-declarative\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\packages\qt5-tools_x64-windows\tools\qt5-tools\bin\zlib1.dll
#   C:\Users\david\repos\tron\third_party\vcpkg\packages\zlib_x64-windows\bin\zlib1.dll

# OSG_LIBRARY_PATH
# $OSG_VERSION = ((& "$ROOT/OpenSceneGraph/bin/osgversiond") -split ' ')[2]
# $OSG_LIBRARY_PATH="$ROOT/OpenSceneGraph/lib/osgPlugins-$OSG_VERSION"

get_cmake_property(_variableNames VARIABLES)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()

# SOLUTION!
# $env:PATH += ";C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\bin"
# C:\Users\david\repos\tron\third_party\vcpkg\buildtrees\osg\x64-windows-rel\bin\osgconv.exe

# TODO: setup.ps1 - create .env file with path to vcpkg\installed\x64-windows\bin"
# TODO: env.ps1 - read .env and update environment variables
if( -not (Test-Variable 'variable:IsWindows') )
{
    # We know we're on Windows PowerShell 5.1 or earlier
    $IsWindows = $true
    $IsLinux = $IsMacOS = $false
}
[IO.Path]::PathSeparator
Join-Path
