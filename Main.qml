import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Window {
    // Defining the Window
    visible: true
    width: 800
    height: 640
    title: qsTr("Retro Games")

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    //variables
    id: mainWindow
    property int playerCount: 1

    Notification {
        id: globalNotification
        anchors.bottom: parent.bottom
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
            width: 800
            height: 640

            Column {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 70
                anchors.rightMargin: 70
                spacing: 20

                // first line should rontain a row with 1 or 2 Player Games selection
                Row {
                    spacing: 10

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
                    text: qsTr("Galgenmann")
                    visible: mainWindow.playerCount === 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: windowStack.push(Qt.resolvedUrl("Galgenmann.qml"))
                }

                Button {
                    text: qsTr("Labyrinth")
                    visible: mainWindow.playerCount === 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        globalNotification.message = "Labyrinth ist noch nicht implementiert"
                        globalNotification.showNotification()
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
