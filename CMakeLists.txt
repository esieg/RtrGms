cmake_minimum_required(VERSION 3.16)

project(RtrGms VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appRtrGms
    main.cpp
    Galgenmann.qrc
)

qt_add_qml_module(appRtrGms
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
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appRtrGms PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appRtrGms
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appRtrGms
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appRtrGms
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
