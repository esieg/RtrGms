import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Window {
    // Defining the Window
    visible: true
    width: Qt.platform.os === "ios" ? Screen.width : 800
    height: Qt.platform.os === "ios" ? Screen.height : 640
    title: qsTr("Rtr Gms")

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    //variables
    id: mainWindow
    property int playerCount: 1

    // Load QMLs
    Notification {
        id: globalNotification
        anchors.bottom: parent.bottom
    }

    LabyrinthLogic {
        id: labyrinthLogic
    }

    // Menu
    MenuBar {

        Menu {
            title: "Datei"
            MenuItem {
                text: "Beenden"
                onTriggered: console.log("Close triggered")
            }
        }

        Menu {
            title: "Hilfe"
            MenuItem {
                text: "Über"
                onTriggered: console.log("About triggered")
            }
        }
    }

    // Content Area
    StackView {
        id: windowStack
        anchors.fill: parent

        initialItem: Item {
            width: mainWindow.width
            height: mainWindow.height

            Row {
                width: parent.width
                height: parent.height
                //anchors.fill: parent
                spacing: 20

                Rectangle {
                    width: parent.width * 2 / 3
                    height: parent.height
                    color: "#4C0E52"

                    Image {
                        source: "qrc:/Assets/General/Icon.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        width: parent.width * 0.5
                        height: width
                        smooth: false
                    }
                }

                Column {
                    width: parent.width * 1 / 3 - parent.width / 20
                    anchors.top: parent.top
                    anchors.topMargin: 70
                    spacing: 20

                    // first line should rontain a row with 1 or 2 Player Games selection
                    Row {
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button {
                            text: "←"
                            enabled: mainWindow.playerCount > 1
                            onClicked: {
                                mainWindow.playerCount -= 1;
                            }
                        }

                        Text{
                            id: selectionText
                            text: mainWindow.playerCount + " Spieler"
                            font.pixelSize: 20
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Button {
                            text: "→"
                            enabled: mainWindow.playerCount < 2
                            onClicked: {
                                mainWindow.playerCount += 1;
                            }
                        }

                    }

                    Button {
                        icon.name: "Galgenmann"
                        icon.source: "qrc:/Assets/Galgenmann/Galgenmann_8.png"
                        icon.color: "transparent"
                        icon.width: 32
                        icon.height: 32
                        text: qsTr("Galgenmann")
                        visible: mainWindow.playerCount === 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: windowStack.push(Qt.resolvedUrl("Galgenmann.qml"))
                    }

                    Button {
                        icon.name: "Labyrinth"
                        icon.source: "qrc:/Assets/Labyrinth/Labyrinth.png"
                        icon.color: "transparent"
                        icon.width: 32
                        icon.height: 32
                        text: qsTr("Labyrinth")
                        visible: mainWindow.playerCount === 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            labyrinthLogic.initializeLabyrinth()
                            windowStack.push(Qt.resolvedUrl("Labyrinth.qml"), { logic: labyrinthLogic })
                        }
                    }

                    Button {
                        text: qsTr("Snake")
                        visible: mainWindow.playerCount === 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            globalNotification.message = "Snake ist noch nicht implementiert"
                            globalNotification.showNotification()
                        }
                    }

                    Button {
                        text: qsTr("Snake 2P")
                        visible: mainWindow.playerCount === 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            globalNotification.message = "Snake 2P ist noch nicht implementiert"
                            globalNotification.showNotification()
                        }
                    }

                    Button {
                        text: qsTr("Pong")
                        visible: mainWindow.playerCount === 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            globalNotification.message = "Pong ist noch nicht implementiert"
                            globalNotification.showNotification()
                        }
                    }

                    Button {
                        text: qsTr("Space Invaders")
                        visible: mainWindow.playerCount === 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            globalNotification.message = "Space Invaders ist noch nicht implementiert"
                            globalNotification.showNotification()
                        }
                    }

                    Button {
                        text: qsTr("Simple RPG")
                        visible: mainWindow.playerCount === 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            globalNotification.message = "Simple RPG ist noch nicht implementiert"
                            globalNotification.showNotification()
                        }
                    }
                }
            }
        }
    }
}
