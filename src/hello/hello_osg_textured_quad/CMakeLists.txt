project(hello_osg_textured_quad)
add_executable (${PROJECT_NAME} hello_osg_textured_quad.cpp)
project_common()
target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIB} ${OSGGA_LIB} ${OSGDB_LIB} ${OSG_LIB})