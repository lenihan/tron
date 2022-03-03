add_executable (QTreeView "QTreeView.cpp")
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)  
target_link_libraries(QTreeView Qt5::Core Qt5::Widgets)

