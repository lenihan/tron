add_executable (parseJson_app "QTreeView_app.cpp")
find_package(Qt5 COMPONENTS Core REQUIRED)  
target_link_libraries(QTreeView_app Qt5::Core)

