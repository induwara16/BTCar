cmake_minimum_required(VERSION 3.16)

project(BTCar VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Bluetooth LinguistTools)

qt_standard_project_setup()

qt_add_executable(appBTCar
    main.cpp
)

qt_add_qml_module(appBTCar
    URI BTCar
    VERSION 1.0
    QML_FILES qml/Main.qml
    QML_FILES qml/pages/ControlPage.qml
    QML_FILES qml/pages/DevicesPage.qml
    QML_FILES qml/pages/HelpPage.qml
    QML_FILES qml/pages/HomePage.qml
    QML_FILES qml/pages/SettingsPage.qml
    QML_FILES qml/components/BaseDialog.qml
    QML_FILES qml/components/Header.qml
    QML_FILES qml/components/List.qml
    SOURCES platformutil.h platformutil.cpp
    SOURCES bluetooth.h bluetooth.cpp
    RESOURCES fonts/Oswald-Regular.ttf icons/BTCar/material/scalable/arrow-back.svg icons/BTCar/material/scalable/arrow-bottom-left.svg icons/BTCar/material/scalable/arrow-bottom-right.svg icons/BTCar/material/scalable/arrow-down.svg icons/BTCar/material/scalable/arrow-top-left.svg icons/BTCar/material/scalable/arrow-top-right.svg icons/BTCar/material/scalable/arrow-up.svg icons/BTCar/material/scalable/bluetooth-connect.svg icons/BTCar/material/scalable/bluetooth-off.svg icons/BTCar/material/scalable/bullhorn-outline.svg icons/BTCar/material/scalable/car-light-high.svg icons/BTCar/material/scalable/cellphone.svg icons/BTCar/material/scalable/chevron-right.svg icons/BTCar/material/scalable/devices.svg icons/BTCar/material/scalable/download.svg icons/BTCar/material/scalable/hamburger-menu.svg icons/BTCar/material/scalable/help.svg icons/BTCar/material/scalable/home.svg icons/BTCar/material/scalable/monitor.svg icons/BTCar/material/scalable/refresh.svg icons/BTCar/material/scalable/robot.svg icons/BTCar/material/scalable/send.svg icons/BTCar/material/scalable/settings.svg icons/BTCar/material/scalable/upload.svg icons/BTCar/material/scalable/web.svg icons/BTCar/index.theme images/drawer.svg images/favicon.ico images/logo.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appBTCar PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appBTCar
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appBTCar
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Bluetooth
)

include(GNUInstallDirs)
install(TARGETS appBTCar
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

set_property(TARGET appBTCar APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

add_custom_target(appBTCar_other_files ALL
    SOURCES inkscape/logo.svg inkscape/logo-android.svg inkscape/drawer.svg inkscape/inkscape.sh .gitignore BTCar_si_LK.ts LICENSE README.md
)

qt_add_translations(appBTCar
    TS_FILES BTCar_si_LK.ts
)
