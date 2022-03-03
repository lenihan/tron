add_executable (parseJson "parseJson.cpp")
find_package(Qt5 COMPONENTS Core REQUIRED)  
target_link_libraries(parseJson Qt5::Core)