cmake_minimum_required(VERSION 3.16)

project(RtrGms VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

# ICON
set(MACOSX_BUNDLE_ICON_FILE Icon.icns)
set(app_icon_macos "${CMAKE_CURRENT_SOURCE_DIR}/Assets/General/Icon.icns")
set_source_files_properties(${app_icon_macos} PROPERTIES
          MACOSX_PACKAGE_LOCATION "Resources")

qt_add_executable(RtrGms
    MACOSX_BUNDLE
    main.cpp
    ${app_icon_macos}
)

qt_add_qml_module(RtrGms
    URI RtrGms
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Galgenmann.qml
        SOURCES
        SOURCES
        RESOURCES
        QML_FILES WordList.qml
        QML_FILES
        RESOURCES Galgenmann.qrc
        QML_FILES Notification.qml
        RESOURCES General.qrc
        RESOURCES Labyrinth.qrc
        QML_FILES LabyrinthLogic.qml
        QML_FILES Labyrinth.qml
        RESOURCES Boulder.qrc
        QML_FILES Boulder.qml BoulderLogic.qml
        RESOURCES Snake.qrc
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(RtrGms PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.RtrGms
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(RtrGms
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS RtrGms
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
