project(QTreeView)
add_executable (${PROJECT_NAME} QTreeView.cpp ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss)
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)  
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Widgets)

# Publish latest Darcula_SimGUI_Merged.qss to working directory
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Darcula_SimGUI_Merged.qss
    COMMENT "[add_custom_command]: ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss"
)
