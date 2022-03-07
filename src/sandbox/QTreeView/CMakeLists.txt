project(QTreeView)
add_executable(
    ${PROJECT_NAME} 
    QTreeView.cpp 
    Assets/Darcula_SimGUI_Merged.qss
)
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)  
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Widgets)

# Copy style sheet to location of built application
foreach(CONFIG IN LISTS CMAKE_CONFIGURATION_TYPES)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/assets/Darcula_SimGUI_Merged.qss 
        ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG}/Darcula_SimGUI_Merged.qss
        COPYONLY
    )
endforeach()

# Create "Asset" folder for style sheet in Visual Studio
source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR} 
    FILES assets/Darcula_SimGUI_Merged.qss
)