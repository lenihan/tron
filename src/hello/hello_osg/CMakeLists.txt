project(hello_osg)
add_executable (${PROJECT_NAME} hello_osg.cpp)
set_target_postfix()
target_link_libraries(${PROJECT_NAME} "opengl32.lib"  ${OSG_VIEWER_LIB} ${OSG_GA_LIB} ${OSG_DB_LIB} ${OSG_LIB})

