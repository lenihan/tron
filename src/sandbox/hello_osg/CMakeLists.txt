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
find_package(OpenGL)

target_link_libraries(${PROJECT_NAME} ${OSG_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGGA_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGSIM_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OSGDB_LIBRARY})
target_link_libraries(${PROJECT_NAME} ${OPENGL_LIBRARIES})

# Create Resources directory
set(RESOURCES_DIR ${PROJECT_SOURCE_DIR}/Resources)
file(MAKE_DIRECTORY ${RESOURCES_DIR})

# Get `OSG_LIBRARY_PATH=XXX` from .env
file(STRINGS ${CMAKE_HOME_DIRECTORY}/.env ENV_FILE)
foreach(LINE ${ENV_FILE})
    string(FIND "${LINE}" "OSG_LIBRARY_PATH" INDEX)
    if(INDEX EQUAL 0)
        set(OSG_LIBRARY_PATH_SETTING ${LINE} )
        break()
    endif()
endforeach()

# Setup variables
set(VCPKG_TOOLS_DIR ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/tools)
set(VCPKG_BIN_DIR ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/bin)
set(OSG_DATA_DIR ${CMAKE_HOME_DIRECTORY}/third_party/OpenSceneGraph-Data)
set(PATH_SETTING PATH=${VCPKG_BIN_DIR})

# convert reflect.rgb to reflect.png
set(ENV_VARS ${OSG_LIBRARY_PATH_SETTING} ${PATH_SETTING})
set(EXE_PATH ${VCPKG_TOOLS_DIR}/osg/osgconv.exe)
set(INPUT_PATH ${OSG_DATA_DIR}/Images/reflect.rgb)
set(OUTPUT_PATH ${RESOURCES_DIR}/reflect.png)
set(CMD -E env ${ENV_VARS} ${EXE_PATH} ${INPUT_PATH} ${OUTPUT_PATH})
execute_process(COMMAND cmake ${CMD})

# TODO: 
# Copy to Debug "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\debug\tools\osg\osgPlugins-3.6.5\osgdb_rgbd.dll"
# Copy to Debug "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\debug\tools\osg\osgPlugins-3.6.5\osgdb_rgbd.pdb"
# Copy to Release "C:\Users\david\repos\tron\third_party\vcpkg\installed\x64-windows\tools\osg\osgPlugins-3.6.5\osgdb_rgb.dll"
# Copy to Debug/Release: "C:\Users\david\repos\tron\third_party\OpenSceneGraph-Data\Images\reflect.rgb"
# Load points from "C:\Users\david\Downloads\test\00a282b3-4f02-4588-a380-9dcc9a87548c\log_map_archive_00a282b3-4f02-4588-a380-9dcc9a87548c.json"