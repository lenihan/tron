add_executable (hello_qt "hello_qt.cpp")
find_package(Qt5 COMPONENTS Widgets REQUIRED)  
target_link_libraries(hello_qt Qt5::Widgets)

