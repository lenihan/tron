project(hello_osg_textured_quad)
add_executable (${PROJECT_NAME} hello_osg_textured_quad.cpp)
set_target_postfix()
target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIB} ${OSGGA_LIB} ${OSGDB_LIB} ${OSG_LIB})