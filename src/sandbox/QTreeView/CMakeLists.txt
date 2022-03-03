project(QTreeView)
add_executable (${PROJECT_NAME} QTreeView.cpp Darcula_SimGUI_Merged.qss)
# add_executable (QTreeView QTreeView.cpp Darcula_SimGUI_Merged.qss)
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)  
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Widgets)
# target_link_libraries(QTreeView Qt5::Core Qt5::Widgets)
configure_file(Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss COPYONLY)
# configure_file(Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE_INIT}/Darcula_SimGUI_Merged.qss COPYONLY)


# message(${PROJECT_NAME})
# message("THERE")

# macro(print_all_variables)
#     message(STATUS "print_all_variables------------------------------------------{")
#     get_cmake_property(_variableNames VARIABLES)
#     foreach (_variableName ${_variableNames})
#         message(STATUS "${_variableName}=${${_variableName}}")
#     endforeach()
#     message(STATUS "print_all_variables------------------------------------------}")
# endmacro()

# print_all_variables()