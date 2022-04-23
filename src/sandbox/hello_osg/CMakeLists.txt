project(hello_osg)
add_executable (
    ${PROJECT_NAME} 
    hello_osg.cpp
    Resources/reflect.png
)

find_package(osg REQUIRED)
find_package(osgViewer REQUIRED)
find_package(osgGA REQUIRED)
find_package(osgSim REQUIRED)
find_package(osgDB REQUIRED)
find_package(OpenThreads REQUIRED)
find_package(OpenGL REQUIRED)

target_link_libraries(${PROJECT_NAME} ${OSG_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGGA_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGSIM_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGDB_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OPENTHREADS_LIBRARY})
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
        ${CONFIG}/reflect.png
        COPYONLY
    )
    if (CONFIG STREQUAL "Debug")
        message("XXXXXXXX")

        execute_process(COMMAND pwsh -nop -c "${CMAKE_HOME_DIRECTORY}/Set-Env.ps1 -Path debug.env && mkdir ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG}/$((Get-Item $env:OSG_LIBRARY_PATH).BaseName)")
        execute_process(COMMAND pwsh -nop -c "${CMAKE_HOME_DIRECTORY}/Set-Env.ps1 -Path debug.env && Copy-Item $env:OSG_LIBRARY_PATH/osgdb_pngd.dll ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG}/$((Get-Item $env:OSG_LIBRARY_PATH).BaseName)/osgdb_pngd.dll")
        execute_process(COMMAND pwsh -nop -c "${CMAKE_HOME_DIRECTORY}/Set-Env.ps1 -Path debug.env && Copy-Item $env:OSG_LIBRARY_PATH/osgdb_pngd.pdb ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG}/$((Get-Item $env:OSG_LIBRARY_PATH).BaseName)/osgdb_pngd.pdb")
        else()
        message("YYYYY")
        execute_process(COMMAND pwsh -nop -c "${CMAKE_HOME_DIRECTORY}/Set-Env.ps1 -Path .env && mkdir ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG}/$((Get-Item $env:OSG_LIBRARY_PATH).BaseName)")
        execute_process(COMMAND pwsh -nop -c "${CMAKE_HOME_DIRECTORY}/Set-Env.ps1 -Path .env && Copy-Item $env:OSG_LIBRARY_PATH/osgdb_png.dll ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG}/$((Get-Item $env:OSG_LIBRARY_PATH).BaseName)/osgdb_png.dll")
    endif()

endforeach()

# TODO: 

# OSG_LIBRARY_PATH=C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\osg\osgPlugins-3.6.5
# Copy to Debug "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\debug\tools\osg\osgPlugins-3.6.5\osgdb_pngd.dll"
# Copy to Debug "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\debug\tools\osg\osgPlugins-3.6.5\osgdb_pngd.pdb"
# Copy to Release "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\osg\osgPlugins-3.6.5\osgdb_png.dll"

# Load points from "C:\Users\david\Downloads\test\00a282b3-4f02-4588-a380-9dcc9a87548c\log_map_archive_00a282b3-4f02-4588-a380-9dcc9a87548c.json"

