project(hello_osg)
add_executable (${PROJECT_NAME} hello_osg.cpp)
project_common()
target_link_libraries(${PROJECT_NAME} ${OSGFX_LIBRARY} ${OSGGA_LIBRARY} ${OSGDB_LIBRARY} ${OSGVIEWER_LIBRARY} ${OSG_LIBRARY} ${OPENTHREADS_LIBRARY} ${OPENGL_LIBRARY})