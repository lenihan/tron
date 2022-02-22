add_executable (parseJson_app "parseJson_app.cpp")
find_package(Qt5 COMPONENTS Core REQUIRED)  
target_link_libraries(parseJson_app Qt5::Core)