# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#
cmake_minimum_required(VERSION 3.8)

# From https://github.com/Microsoft/vcpkg#vcpkg-as-a-submodule
# Do this before project()
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_HOME_DIRECTORY}/third_party/vcpkg/scripts/buildsystems/vcpkg.cmake
  CACHE STRING "Vcpkg toolchain file")

project("tron")

include_directories("${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include")

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

# # Include sub-projects.
add_subdirectory("src/hello/hello_cmake")
add_subdirectory("src/hello/hello_osg")
add_subdirectory("src/hello/hello_osg_terrain_tile")
add_subdirectory("src/hello/hello_osg_textured_quad")
add_subdirectory("src/hello/hello_qt")
add_subdirectory("src/vector_map")
add_subdirectory("src/osgbillboard")
add_subdirectory("src/osgterrain")
add_subdirectory("src/osgthreadedterrain")
add_subdirectory("src/test_json_to_osgb")
add_subdirectory("src/sandbox/parseJson")
add_subdirectory("src/sandbox/QTreeView")
