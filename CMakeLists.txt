# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.

cmake_minimum_required(VERSION 3.16)
project("tron")

# Use `dump_vars()` to see cmake variables. Helpful for debugging.
function(dump_vars)
  get_cmake_property(_variableNames VARIABLES)
  list (SORT _variableNames)
  foreach (_variableName ${_variableNames})
      message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()
endfunction()

# setup find_package() to search in vcpkg/installed/<TRIPLET>/lib, vcpkg/installed/<TRIPLET>/debug/lib
# This line must come before any calls to `find_package()`
include(${CMAKE_SOURCE_DIR}/third_party/vcpkg/scripts/buildsystems/vcpkg.cmake)

# Windows-only fix
# When VCPKG_APPLOCAL_DEPS is set to ON (default), it copies the needed third party .dll's to same
# directory as the built binary app. BUT...it does NOT copy over the .pdb files. .pdb files are
# used by the debugger to connect a .dll to its source code.
# Set VCPKG_APPLOCAL_DEPS to "OFF" and built binary app will use PATH environment
# variable to get its third party .dll's from where the originals live: 
#   vcpkg/installed/<TRIPLET>/bin 
#   vcpkg/installed/<TRIPLET>/debug/bin
# In the case of debug libraries, the .dll lives next to the .pdb so it will be found by the debugger and
# thus you will be able to step into third party source code.
# The vcpkg code that does the .dll copying is located here:
# https://github.com/microsoft/vcpkg/blob/619b29470031781e0c787eff32dbc7d8568bdbe6/scripts/buildsystems/vcpkg.cmake#L360:L408
set(VCPKG_APPLOCAL_DEPS OFF)

# Find OpenSceneGraph packages
find_package(osg REQUIRED)                          # To use: target_link_libraries(${PROJECT_NAME} ${OSG_LIBRARY});
find_package(osgAnimation REQUIRED)                 # To use: target_link_libraries(${PROJECT_NAME} ${OSGANIMATION_LIBRARY});
find_package(osgDB REQUIRED)                        # To use: target_link_libraries(${PROJECT_NAME} ${OSGDB_LIBRARY});
find_package(osgFX REQUIRED)                        # To use: target_link_libraries(${PROJECT_NAME} ${OSGFX_LIBRARY});
find_package(osgGA REQUIRED)                        # To use: target_link_libraries(${PROJECT_NAME} ${OSGGA_LIBRARY});
find_package(osgManipulator REQUIRED)               # To use: target_link_libraries(${PROJECT_NAME} ${OSGMANIPULATOR_LIBRARY});
find_package(osgParticle REQUIRED)                  # To use: target_link_libraries(${PROJECT_NAME} ${OSGPARTICLE_LIBRARY});
find_package(osgPresentation REQUIRED)              # To use: target_link_libraries(${PROJECT_NAME} ${OSGPRESENTATION_LIBRARY});
find_package(osgShadow REQUIRED)                    # To use: target_link_libraries(${PROJECT_NAME} ${OSGSHADOW_LIBRARY});
find_package(osgSim REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} ${OSGSIM_LIBRARY});
find_package(osgTerrain REQUIRED)                   # To use: target_link_libraries(${PROJECT_NAME} ${OSGTERRAIN_LIBRARY});
find_package(osgText REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} ${OSGTEXT_LIBRARY});
find_package(osgUtil REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} ${OSGUTIL_LIBRARY});
find_package(osgViewer REQUIRED)                    # To use: target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIBRARY});
find_package(osgVolume REQUIRED)                    # To use: target_link_libraries(${PROJECT_NAME} ${OSGVOLUME_LIBRARY});
find_package(osgWidget REQUIRED)                    # To use: target_link_libraries(${PROJECT_NAME} ${OSGWIDGET_LIBRARY});
      
# Find OpenGL     
find_package(OpenGL REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} ${OPENGL_LIBRARY});

# Find Qt packages
# find_package parses Qt5*Config.cmake files located in third_party/vcpkg/installed/x64-linux/share/cmake
find_package(Qt5AccessibilitySupport REQUIRED)      # To use: target_link_libraries(${PROJECT_NAME} ${Qt5AccessibilitySupport_LIBRARIES});
find_package(Qt5Concurrent REQUIRED)                # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Concurrent_LIBRARIES});
find_package(Qt5Core REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Core_LIBRARIES});
find_package(Qt5DBus REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} ${Qt5DBus_LIBRARIES});
find_package(Qt5DeviceDiscoverySupport REQUIRED)    # To use: target_link_libraries(${PROJECT_NAME} ${Qt5DeviceDiscoverySupport_LIBRARIES});
find_package(Qt5EdidSupport REQUIRED)               # To use: target_link_libraries(${PROJECT_NAME} ${Qt5EdidSupport_LIBRARIES});
find_package(Qt5EventDispatcherSupport REQUIRED)    # To use: target_link_libraries(${PROJECT_NAME} ${Qt5EventDispatcherSupport_LIBRARIES});
find_package(Qt5FbSupport REQUIRED)                 # To use: target_link_libraries(${PROJECT_NAME} ${Qt5FbSupport_LIBRARIES});
find_package(Qt5FontDatabaseSupport REQUIRED)       # To use: target_link_libraries(${PROJECT_NAME} ${Qt5FontDatabaseSupport_LIBRARIES});
find_package(Qt5Gui REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Gui_LIBRARIES});
find_package(Qt5Network REQUIRED)                   # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Network_LIBRARIES});
find_package(Qt5OpenGL REQUIRED)                    # To use: target_link_libraries(${PROJECT_NAME} ${Qt5OpenGL_LIBRARIES});
find_package(Qt5OpenGLExtensions REQUIRED)          # To use: target_link_libraries(${PROJECT_NAME} ${Qt5OpenGLExtensions_LIBRARIES});
find_package(Qt5PlatformCompositorSupport REQUIRED) # To use: target_link_libraries(${PROJECT_NAME} ${Qt5PlatformCompositorSupport_LIBRARIES});
find_package(Qt5PrintSupport REQUIRED)              # To use: target_link_libraries(${PROJECT_NAME} ${Qt5PrintSupport_LIBRARIES});
find_package(Qt5Sql REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Sql_LIBRARIES});
find_package(Qt5Test REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Test_LIBRARIES});
find_package(Qt5ThemeSupport REQUIRED)              # To use: target_link_libraries(${PROJECT_NAME} ${Qt5ThemeSupport_LIBRARIES});
find_package(Qt5Widgets REQUIRED)                   # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Widgets_LIBRARIES});
find_package(Qt5Xml REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} ${Qt5Xml_LIBRARIES});

# Add vcpkg to include path: third_party/vcpkg/installed/<TRIPLET>/include (same location that osg header is in)
include_directories(${OSG_INCLUDE_DIR})

# Directory for output files
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib CACHE PATH "Output directory for static libraries.")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib CACHE PATH "Output directory for shared libraries.")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE PATH "Output directory for executables and DLL's.")
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
  string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib CACHE PATH "Output directory for ${OUTPUTCONFIG} static libraries" FORCE)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib CACHE PATH "Output directory for ${OUTPUTCONFIG} shared libraries" FORCE)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin CACHE PATH "Output directory for ${OUTPUTCONFIG} executables and DLL's." FORCE)
endforeach()

# Do things for every project
#   Add postfix to non-Release artifacts
#   Setup debug environment for Visual Studio
set(CMAKE_DEBUG_POSTFIX _Debug)
set(CMAKE_MINSIZEREL_POSTFIX _MinSizeRel)
set(CMAKE_RELWITHDEBINFO_POSTFIX _RelWithDebInfo)
file(STRINGS .env env_file NEWLINE_CONSUME)
function(project_common)   # Call this after `project()` in each CMakeLists.txt file
  set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
  set_target_properties(${PROJECT_NAME} PROPERTIES MINSIZEREL_POSTFIX ${CMAKE_MINSIZEREL_POSTFIX})
  set_target_properties(${PROJECT_NAME} PROPERTIES RELWITHDEBINFO_POSTFIX ${CMAKE_RELWITHDEBINFO_POSTFIX})
  set_target_properties(${PROJECT_NAME} PROPERTIES VS_DEBUGGER_ENVIRONMENT ${env_file})
endfunction()

# Visual Studio: Group ALL_BUILD.vcxproj and ZERO_CHECK.vcxproj under "CMakePredifinedTargets"
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Include sub-projects
add_subdirectory(src/hello/hello_cmake)
add_subdirectory(src/hello/hello_qt)
add_subdirectory(src/hello/hello_osg)
