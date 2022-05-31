project(hello_osg)
add_executable (
    ${PROJECT_NAME} 
    hello_osg.cpp
    Resources/reflect.png
)

set_target_postfix()

find_package(Qt5 COMPONENTS Core REQUIRED)
target_link_libraries(${PROJECT_NAME} Qt5::Core)

find_package(osg REQUIRED)
find_package(osgViewer REQUIRED)
find_package(osgGA REQUIRED)
find_package(osgSim REQUIRED)
find_package(osgDB REQUIRED)
find_package(OpenThreads REQUIRED)
find_package(osgUtil REQUIRED)
find_package(OpenGL REQUIRED)

target_link_libraries(${PROJECT_NAME} ${OSG_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGGA_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGSIM_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGDB_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OPENTHREADS_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGUTIL_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OPENGL_LIBRARIES})

# Create Resources directory
set(RESOURCES_DIR ${PROJECT_SOURCE_DIR}/Resources)
file(MAKE_DIRECTORY ${RESOURCES_DIR})

# convert reflect.rgb to reflect.png
set(OSG_DATA_DIR ${CMAKE_HOME_DIRECTORY}/third_party/OpenSceneGraph-Data)
set(INPUT_PATH ${OSG_DATA_DIR}/Images/reflect.rgb)
set(OUTPUT_PATH ${RESOURCES_DIR}/reflect.png)
set(CMD pwsh -nop -c "${CMAKE_HOME_DIRECTORY}/Set-Env.ps1 && osgconv ${INPUT_PATH} ${OUTPUT_PATH}")
execute_process(COMMAND ${CMD})

foreach(CONFIG IN LISTS CMAKE_CONFIGURATION_TYPES)
    configure_file(
        Resources/reflect.png
        ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/reflect.png
        COPYONLY
    )
endforeach()

# CMAKE_CURRENT_BINARY_DIR=C:/Users/david/repos/tron/out/build/src/sandbox/hello_osg
# CMAKE_ARCHIVE_OUTPUT_DIRECTORY_<CONFIG> - .lib, .a 
# CMAKE_LIBRARY_OUTPUT_DIRECTORY_<CONFIG> - .dll, .so
# CMAKE_RUNTIME_OUTPUT_DIRECTORY - .exe, .dll
# out/build
# out/bin/Debug
# out/bin/Release
# out/lib/Debug
# out/lib/Release
# src/include/sim

#https://cmake.org/cmake/help/latest/variable/CMAKE_ARCHIVE_OUTPUT_DIRECTORY_CONFIG.html
# add_custom_command(
#     OUTPUT
#     COMMAND
# )
# CMAKE_HOME_DIRECTORY
# get_cmake_property(_variableNames VARIABLES)
# foreach (_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()


