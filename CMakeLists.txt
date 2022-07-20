# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#
cmake_minimum_required(VERSION 3.8)

project("tron")

# Group ALL_BUILD.vcxproj and ZERO_CHECK.vcxproj under "CMakePredifinedTargets"
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Directory for output files
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib 
  CACHE PATH "Output directory for static libraries.")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
  CACHE PATH "Output directory for shared libraries.")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
  CACHE PATH "Output directory for executables and DLL's.")

foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
  string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${CMAKE_BINARY_DIR}/bin" CACHE PATH "" FORCE)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${CMAKE_BINARY_DIR}/lib" CACHE PATH "" FORCE)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${CMAKE_BINARY_DIR}/lib" CACHE PATH "" FORCE)
endforeach()

# Make add postfix to non-Release artifacts
set(CMAKE_DEBUG_POSTFIX _Debug) 
set(CMAKE_MINSIZEREL_POSTFIX _MinSizeRel)
set(CMAKE_RELWITHDEBINFO_POSTFIX _RelWithDebInfo)

function(set_target_postfix)
  set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
  set_target_properties(${PROJECT_NAME} PROPERTIES MINSIZEREL_POSTFIX ${CMAKE_MINSIZEREL_POSTFIX})
  set_target_properties(${PROJECT_NAME} PROPERTIES RELWITHDEBINFO_POSTFIX ${CMAKE_RELWITHDEBINFO_POSTFIX})
endfunction()

function(require_path_exists PATH)
  if(NOT EXISTS ${PATH})
    message(FATAL_ERROR "Required file not found: ${PATH}")
  endif()
endfunction()

# Setup Qt include paths, library paths
#   Example use: ${QT5CORE_LIB} for Qt5Core.lib, ${QT5WIDGETS_LIB} for Qt5Widgets.lib
set(QT_DIR third_party/qt5/build/qtbase)
set(QT_LIB_DIR ${QT_DIR}/lib)
if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
  set(QT_LIB_DIR_RELEASE ${QT_LIB_DIR})
  set(QT_LIB_DIR_DEBUG ${QT_LIB_DIR})
elseif(${CMAKE_SYSTEM_NAME} STREQUAL Linux)
  # TODO
endif()
list(APPEND QT_LIB_BASE_NAMES AccessibilitySupport Concurrent Core DBus DeviceDiscoverySupport EdidSupport EglSupport EventDispatcherSupport FbSupport FontDatabaseSupport Gui Network OpenGL OpenGLExtensions PlatformCompositorSupport PrintSupport Sql Test ThemeSupport Widgets WindowsUIAutomationSupport Xml)
foreach(NAME ${QT_LIB_BASE_NAMES})
  include_directories(${QT_DIR}/include/Qt${NAME})
  if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
    set(RELEASE_LIB_PATH ${CMAKE_SOURCE_DIR}/${QT_LIB_DIR_RELEASE}/Qt5${NAME}.lib)
    set(DEBUG_LIB_PATH ${CMAKE_SOURCE_DIR}/${QT_LIB_DIR_DEBUG}/Qt5${NAME}d.lib)
  elseif(${CMAKE_SYSTEM_NAME} STREQUAL Linux)
    # TODO
  endif()
  require_path_exists(${RELEASE_LIB_PATH})
  require_path_exists(${DEBUG_LIB_PATH})
  string(TOUPPER QT5${NAME}_LIB VAR_NAME)
  set(${VAR_NAME} optimized ${RELEASE_LIB_PATH} debug ${DEBUG_LIB_PATH})
endforeach()
include_directories(${QT_DIR}/include)


# Setup OSG
set(OSG_DIR "third_party/OpenSceneGraph")
include_directories("${OSG_DIR}/include")
include_directories("${OSG_DIR}/build/Release/include")
set(OSG_LIB_RELEASE_DIR "${OSG_DIR}/build/Release/lib")
set(OSG_LIB_DEBUG_DIR   "${OSG_DIR}/build/Debug/lib")
find_library(OSG_OPENTHREADS_LIB_RELEASE  NAMES OpenThreads.lib      PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_OPENTHREADS_LIB_DEBUG    NAMES OpenThreadsd.lib     PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_LIB_RELEASE              NAMES osg.lib              PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_LIB_DEBUG                NAMES osgd.lib             PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_ANIMATION_LIB_RELEASE    NAMES osgAnimation.lib     PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_ANIMATION_LIB_DEBUG      NAMES osgAnimationd.lib    PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_DB_LIB_RELEASE           NAMES osgDB.lib            PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_DB_LIB_DEBUG             NAMES osgDBd.lib           PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_FX_LIB_RELEASE           NAMES osgFX.lib            PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_FX_LIB_DEBUG             NAMES osgFXd.lib           PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_GA_LIB_RELEASE           NAMES osgGA.lib            PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_GA_LIB_DEBUG             NAMES osgGAd.lib           PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_MANIPULATOR_LIB_RELEASE  NAMES osgManipulator.lib   PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_MANIPULATOR_LIB_DEBUG    NAMES osgManipulatord.lib  PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_PARTICLE_LIB_RELEASE     NAMES osgParticle.lib      PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_PARTICLE_LIB_DEBUG       NAMES osgParticled.lib     PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_PRESENTATION_LIB_RELEASE NAMES osgPresentation.lib  PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_PRESENTATION_LIB_DEBUG   NAMES osgPresentationd.lib PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_SHADOW_LIB_RELEASE       NAMES osgShadow.lib        PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_SHADOW_LIB_DEBUG         NAMES osgShadowd.lib       PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_SIM_LIB_RELEASE          NAMES osgSim.lib           PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_SIM_LIB_DEBUG            NAMES osgSimd.lib          PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_TERRAIN_LIB_RELEASE      NAMES osgTerrain.lib       PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_TERRAIN_LIB_DEBUG        NAMES osgTerraind.lib      PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_TEXT_LIB_RELEASE         NAMES osgText.lib          PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_TEXT_LIB_DEBUG           NAMES osgTextd.lib         PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_UI_LIB_RELEASE           NAMES osgUI.lib            PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_UI_LIB_DEBUG             NAMES osgUId.lib           PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_UTIL_LIB_RELEASE         NAMES osgUtil.lib          PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_UTIL_LIB_DEBUG           NAMES osgUtild.lib         PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_VIEWER_LIB_RELEASE       NAMES osgViewer.lib        PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_VIEWER_LIB_DEBUG         NAMES osgViewerd.lib       PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_VOLUME_LIB_RELEASE       NAMES osgVolume.lib        PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_VOLUME_LIB_DEBUG         NAMES osgVolumed.lib       PATHS ${OSG_LIB_DEBUG_DIR})
find_library(OSG_WIDGET_LIB_RELEASE       NAMES osgWidget.lib        PATHS ${OSG_LIB_RELEASE_DIR})
find_library(OSG_WIDGET_LIB_DEBUG         NAMES osgWidgetd.lib       PATHS ${OSG_LIB_DEBUG_DIR})
set(OSG_OPENTHREADS_LIB  optimized ${OSG_OPENTHREADS_LIB_RELEASE}  debug ${OSG_OPENTHREADS_LIB_DEBUG})
set(OSG_LIB              optimized ${OSG_LIB_RELEASE}              debug ${OSG_LIB_DEBUG})
set(OSG_ANIMATION_LIB    optimized ${OSG_ANIMATION_LIB_RELEASE}    debug ${OSG_ANIMATION_LIB_DEBUG})
set(OSG_DB_LIB           optimized ${OSG_DB_LIB_RELEASE}           debug ${OSG_DB_LIB_DEBUG})
set(OSG_FX_LIB           optimized ${OSG_FX_LIB_RELEASE}           debug ${OSG_FX_LIB_DEBUG})
set(OSG_GA_LIB           optimized ${OSG_GA_LIB_RELEASE}           debug ${OSG_GA_LIB_DEBUG})
set(OSG_MANIPULATOR_LIB  optimized ${OSG_MANIPULATOR_LIB_RELEASE}  debug ${OSG_MANIPULATOR_LIB_DEBUG})
set(OSG_PARTICLE_LIB     optimized ${OSG_PARTICLE_LIB_RELEASE}     debug ${OSG_PARTICLE_LIB_DEBUG})
set(OSG_PRESENTATION_LIB optimized ${OSG_PRESENTATION_LIB_RELEASE} debug ${OSG_PRESENTATION_LIB_DEBUG})
set(OSG_SHADOW_LIB       optimized ${OSG_SHADOW_LIB_RELEASE}       debug ${OSG_SHADOW_LIB_DEBUG})
set(OSG_SIM_LIB          optimized ${OSG_SIM_LIB_RELEASE}          debug ${OSG_SIM_LIB_DEBUG})
set(OSG_TERRAIN_LIB      optimized ${OSG_TERRAIN_LIB_RELEASE}      debug ${OSG_TERRAIN_LIB_DEBUG})
set(OSG_TEXT_LIB         optimized ${OSG_TEXT_LIB_RELEASE}         debug ${OSG_TEXT_LIB_DEBUG})
set(OSG_UI_LIB           optimized ${OSG_UI_LIB_RELEASE}           debug ${OSG_UI_LIB_DEBUG})
set(OSG_UTIL_LIB         optimized ${OSG_UTIL_LIB_RELEASE}         debug ${OSG_UTIL_LIB_DEBUG})
set(OSG_VIEWER_LIB       optimized ${OSG_VIEWER_LIB_RELEASE}       debug ${OSG_VIEWER_LIB_DEBUG})
set(OSG_VOLUME_LIB       optimized ${OSG_VOLUME_LIB_RELEASE}       debug ${OSG_VOLUME_LIB_DEBUG})
set(OSG_WIDGET_LIB       optimized ${OSG_WIDGET_LIB_RELEASE}       debug ${OSG_WIDGET_LIB_DEBUG})


# Include sub-projects.
add_subdirectory("src/hello/hello_cmake")
add_subdirectory("src/hello/hello_qt")
add_subdirectory("src/hello/hello_osg")
# add_subdirectory("src/hello/hello_osg_terrain_tile")
# add_subdirectory("src/hello/hello_osg_textured_quad")
# add_subdirectory("src/vector_map")
# add_subdirectory("src/osgbillboard")
# add_subdirectory("src/osgterrain")
# add_subdirectory("src/osgthreadedterrain")
# add_subdirectory("src/test_json_to_osgb")
# add_subdirectory("src/sandbox/parseJson")
# add_subdirectory("src/sandbox/QTreeView")

# get_cmake_property(_variableNames VARIABLES)
# foreach (_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()