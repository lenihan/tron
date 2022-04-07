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
# Convert reflect.rgb to reflect.png via osgconv