project(QTreeView)
add_executable (${PROJECT_NAME} QTreeView.cpp Darcula_SimGUI_Merged.qss)
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)  
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Widgets)

# configure_file(Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss COPYONLY)
# configure_file(Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE_INIT}/Darcula_SimGUI_Merged.qss COPYONLY)

# Works, except if app is built, won't update .qss in PRE_BUILD|PRE_LINK|POST_BUILD
# add_custom_command(
#     TARGET ${PROJECT_NAME} PRE_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss
# )

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Darcula_SimGUI_Merged.qss ${CMAKE_CURRENT_BINARY_DIR}/Darcula_SimGUI_Merged.qss
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Darcula_SimGUI_Merged.qss
)


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