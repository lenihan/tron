add_executable (parseJson_app "parseJson_app.cpp")
find_package(Qt5 COMPONENTS Widgets REQUIRED)  
target_link_libraries(parseJson_app Qt5::Widgets)