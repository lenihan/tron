project(maptiles)
add_executable (${PROJECT_NAME} main.cc)
set_target_postfix()
target_link_libraries(${PROJECT_NAME} ${OSGFX_LIB} ${OSGVIEWER_LIB} ${OSGGA_LIB} ${OSGDB_LIB} ${OSG_LIB} ${OPENGL_LIB})
