# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#
cmake_minimum_required(VERSION 3.13)
project("tron")


set(CMAKE_TOOLCHAIN_FILE "third_party/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE STRING "Vcpkg toolchain file")

# Find Qt packages
# find_package parses Qt5*Config.cmake files located in third_party/vcpkg/installed/x64-linux/share/cmake
find_package(Qt5AccessibilitySupport REQUIRED)      # To use: target_link_libraries(${PROJECT_NAME} Qt5::AccessibilitySupport)
find_package(Qt5Concurrent REQUIRED)                # To use: target_link_libraries(${PROJECT_NAME} Qt5::Concurrent)
find_package(Qt5Core REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} Qt5::Core)
find_package(Qt5DBus REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} Qt5::DBus)
find_package(Qt5DeviceDiscoverySupport REQUIRED)    # To use: target_link_libraries(${PROJECT_NAME} Qt5::DeviceDiscoverySupport)
find_package(Qt5EdidSupport REQUIRED)               # To use: target_link_libraries(${PROJECT_NAME} Qt5::EdidSupport)
find_package(Qt5EventDispatcherSupport REQUIRED)    # To use: target_link_libraries(${PROJECT_NAME} Qt5::EventDispatcherSupport)
find_package(Qt5FbSupport REQUIRED)                 # To use: target_link_libraries(${PROJECT_NAME} Qt5::FbSupport)
find_package(Qt5FontDatabaseSupport REQUIRED)       # To use: target_link_libraries(${PROJECT_NAME} Qt5::FontDatabaseSupport)
find_package(Qt5Gui REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} Qt5::Gui)
find_package(Qt5Network REQUIRED)                   # To use: target_link_libraries(${PROJECT_NAME} Qt5::Network)
find_package(Qt5OpenGL REQUIRED)                    # To use: target_link_libraries(${PROJECT_NAME} Qt5::OpenGL)
find_package(Qt5OpenGLExtensions REQUIRED)          # To use: target_link_libraries(${PROJECT_NAME} Qt5::OpenGLExtensions)
find_package(Qt5PlatformCompositorSupport REQUIRED) # To use: target_link_libraries(${PROJECT_NAME} Qt5::PlatformCompositorSupport)
find_package(Qt5PrintSupport REQUIRED)              # To use: target_link_libraries(${PROJECT_NAME} Qt5::PrintSupport)
find_package(Qt5Sql REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} Qt5::Sql)
find_package(Qt5Test REQUIRED)                      # To use: target_link_libraries(${PROJECT_NAME} Qt5::Test)
find_package(Qt5ThemeSupport REQUIRED)              # To use: target_link_libraries(${PROJECT_NAME} Qt5::ThemeSupport)
find_package(Qt5Widgets REQUIRED)                   # To use: target_link_libraries(${PROJECT_NAME} Qt5::Widgets)
find_package(Qt5Xml REQUIRED)                       # To use: target_link_libraries(${PROJECT_NAME} Qt5::Xml)

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

# Group ALL_BUILD.vcxproj and ZERO_CHECK.vcxproj under "CMakePredifinedTargets"
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# # Utility function that will exit with error if PATH does not exist
# function(require_path_exists PATH)
#   if(NOT EXISTS ${PATH})
#     message(FATAL_ERROR "Required file not found: ${PATH}")
#   endif()
# endfunction()

# # Setup Qt include paths, library variables
# #   Example use: ${QT5CORE_LIB} for Qt5Core.lib, ${QT5WIDGETS_LIB} for Qt5Widgets.lib
# set(QT_BUILD_DIR third_party/qt5/build)
# set(QT_DIR third_party/qt5/build/qtbase)
# if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
#   set(QT_LIB_DIR_RELEASE ${QT_BUILD_DIR}/qtbase/lib)
#   set(QT_LIB_DIR_DEBUG ${QT_LIB_DIR_RELEASE})
#   set(QT_INCLUDE_DIR third_party/qt5/build/qtbase/include)
# elseif(${CMAKE_SYSTEM_NAME} STREQUAL Linux)
#   set(QT_LIB_DIR_RELEASE ${QT_BUILD_DIR}/Release/qtbase/lib)
#   set(QT_LIB_DIR_DEBUG ${QT_BUILD_DIR}/Debug/qtbase/lib)
#   set(QT_INCLUDE_DIR third_party/qt5/build/Release/qtbase/include)
#   add_compile_options(-fPIC)
# endif()
# include_directories(${QT_INCLUDE_DIR})
# list(APPEND QT_LIB_BASE_NAMES Concurrent Core DBus Gui Network OpenGL PrintSupport Sql Test Widgets Xml)
# foreach(NAME ${QT_LIB_BASE_NAMES})
#   include_directories(${QT_INCLUDE_DIR}/Qt${NAME})
#   if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
#     set(RELEASE_LIB_PATH ${CMAKE_SOURCE_DIR}/${QT_LIB_DIR_RELEASE}/Qt5${NAME}.lib)
#     set(DEBUG_LIB_PATH ${CMAKE_SOURCE_DIR}/${QT_LIB_DIR_DEBUG}/Qt5${NAME}d.lib)
#   elseif(${CMAKE_SYSTEM_NAME} STREQUAL Linux)
#     set(RELEASE_LIB_PATH ${CMAKE_SOURCE_DIR}/${QT_LIB_DIR_RELEASE}/libQt5${NAME}.so)
#     set(DEBUG_LIB_PATH ${CMAKE_SOURCE_DIR}/${QT_LIB_DIR_DEBUG}/libQt5${NAME}d.so)
#   endif()
#   require_path_exists(${RELEASE_LIB_PATH})
#   require_path_exists(${DEBUG_LIB_PATH})
#   string(TOUPPER QT5${NAME}_LIB VAR_NAME)
#   set(${VAR_NAME} optimized ${RELEASE_LIB_PATH} debug ${DEBUG_LIB_PATH})
#   message(STATUS "Created library variable: \$\{${VAR_NAME}\}")
# endforeach()

# # Setup OSG include paths, library variables
# #   Example use: ${OSG_LIB} for osg.lib, ${OSGDB_LIB} for osgDB.lib, ${OPENTHREADS_LIB} for OpenThreads.lib
# set(OSG_DIR third_party/OpenSceneGraph)
# include_directories(${OSG_DIR}/include)
# include_directories(${OSG_DIR}/build/Release/include)
# set(OSG_LIB_DIR_RELEASE ${OSG_DIR}/build/Release/lib)
# set(OSG_LIB_DIR_DEBUG ${OSG_DIR}/build/Debug/lib)
# list(APPEND OSG_LIB_BASE_NAMES  OpenThreads osg osgAnimation osgDB osgFX osgGA osgManipulator osgParticle osgPresentation osgShadow osgSim osgTerrain osgText osgUI osgUtil osgViewer osgVolume osgWidget)
# foreach(NAME ${OSG_LIB_BASE_NAMES})
#   if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
#     set(RELEASE_LIB_PATH ${CMAKE_SOURCE_DIR}/${OSG_LIB_DIR_RELEASE}/${NAME}.lib)
#     set(DEBUG_LIB_PATH ${CMAKE_SOURCE_DIR}/${OSG_LIB_DIR_DEBUG}/${NAME}d.lib)
#   elseif(${CMAKE_SYSTEM_NAME} STREQUAL Linux)
#     set(RELEASE_LIB_PATH ${CMAKE_SOURCE_DIR}/${OSG_LIB_DIR_RELEASE}/lib${NAME}.so)
#     set(DEBUG_LIB_PATH ${CMAKE_SOURCE_DIR}/${OSG_LIB_DIR_DEBUG}/lib${NAME}d.so)
#   endif()
#   require_path_exists(${RELEASE_LIB_PATH})
#   require_path_exists(${DEBUG_LIB_PATH})
#   string(TOUPPER ${NAME}_LIB VAR_NAME)
#   set(${VAR_NAME} optimized ${RELEASE_LIB_PATH} debug ${DEBUG_LIB_PATH})
#   message(STATUS "Created library variable: \$\{${VAR_NAME}\}")
# endforeach()

# # Setup OpenGL library variable
# if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
#   set(OPENGL_LIB opengl32.lib)
# elseif(${CMAKE_SYSTEM_NAME} STREQUAL Linux)
#   set(OPENGL_LIB libGL.so)
# endif()
# message(STATUS "Created library variable: \$\{OPENGL_LIB\}")

# Include sub-projects
add_subdirectory(src/hello/hello_cmake)
add_subdirectory(src/hello/hello_qt)
add_subdirectory(src/hello/hello_osg)
# add_subdirectory(src/hello/hello_osg_terrain_tile)
# add_subdirectory(src/hello/hello_osg_textured_quad)
# add_subdirectory(src/vector_map)
# add_subdirectory(src/osgbillboard)
# add_subdirectory(src/osgterrain)
# add_subdirectory(src/osgthreadedterrain)
# add_subdirectory(src/test_json_to_osgb)
# add_subdirectory(src/sandbox/maptiles)
# add_subdirectory(src/sandbox/parseJson)
# add_subdirectory(src/sandbox/QTreeView)
# add_subdirectory(src/generate_quadtree_textures)


