project(hello_qt)
add_executable(${PROJECT_NAME} hello_qt.cpp)
project_common()
target_link_libraries(${PROJECT_NAME} ${Qt5Widgets_LIBRARIES} ${Qt5Core_LIBRARIES})
