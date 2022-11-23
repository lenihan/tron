project(hello_qt)
add_executable(${PROJECT_NAME} "hello_qt.cpp")
project_common()
target_link_libraries(${PROJECT_NAME}  ${QT5WIDGETS_LIB} ${QT5CORE_LIB})
