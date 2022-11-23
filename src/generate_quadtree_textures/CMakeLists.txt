project(generate_quadtree_textures)
add_executable (${PROJECT_NAME} generate_quadtree_textures.cpp)
project_common()
target_link_libraries(${PROJECT_NAME} ${OSGVIEWER_LIB} ${OSGGA_LIB} ${OSGDB_LIB} ${OSG_LIB} ${OPENGL_LIB})
