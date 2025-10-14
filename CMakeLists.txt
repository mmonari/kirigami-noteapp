cmake_minimum_required(VERSION 3.20)
project(kirigami-noteapp VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

# Suppress Vulkan warnings (not needed for this application)
set(CMAKE_DISABLE_FIND_PACKAGE_Vulkan TRUE)
set(CMAKE_DISABLE_FIND_PACKAGE_WrapVulkanHeaders TRUE)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 Widgets)
find_package(KF6CoreAddons REQUIRED)
find_package(KF6I18n REQUIRED)

add_executable(kirigami-noteapp main.cpp)

target_link_libraries(kirigami-noteapp
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Widgets
    KF6::CoreAddons
    KF6::I18n
)

# Copy QML file to build directory
configure_file(${CMAKE_SOURCE_DIR}/main.qml ${CMAKE_BINARY_DIR}/main.qml COPYONLY)
