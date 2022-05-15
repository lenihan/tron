project(parseJson)
add_executable(
    ${PROJECT_NAME} 
    parseJson.cpp
    Assets/simulation_config_2in1.json
    Assets/simulation_config-all_cmds.json
    Assets/simulation_config.json
)
set_target_postfix()
find_package(Qt5 COMPONENTS Core REQUIRED)  
target_link_libraries(${PROJECT_NAME} Qt5::Core)
find_package(Qt5 COMPONENTS Widgets REQUIRED)  
target_link_libraries(${PROJECT_NAME} Qt5::Widgets)

# Copy json to bin location
configure_file(
    Assets/simulation_config_2in1.json
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/simulation_config_2in1.json
    COPYONLY
)
configure_file(
    Assets/simulation_config-all_cmds.json
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/simulation_config-all_cmds.json
    COPYONLY
)
configure_file(
    Assets/simulation_config.json
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/simulation_config.json
    COPYONLY
)

# Create "Asset" folder for style sheet in Visual Studio
source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR} 
    FILES Assets/simulation_config_2in1.json
)
source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR} 
    FILES Assets/simulation_config-all_cmds.json
)
source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR} 
    FILES Assets/simulation_config.json
)