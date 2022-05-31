project(vector_map)
add_executable (
    ${PROJECT_NAME} 
    vector_map.cpp
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



