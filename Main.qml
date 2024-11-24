import QtQuick
import QtQuick.Controls

Window {
    // Defining the Window
    visible: true
    width: 800
    height: 640
    title: qsTr("Retro Games")

    //variables
    id: mainWindow
    property int playerCount: 1


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
                    onClicked: console.log("Labyrinth choosen")
                }

                Button {
                    text: qsTr("Snake")
                    visible: mainWindow.playerCount === 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: console.log("Snake choosen")
                }

                Button {
                    text: qsTr("Snake 2P")
                    visible: mainWindow.playerCount === 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: console.log("Snake 2P choosen")
                }

                Button {
                    text: qsTr("Pong")
                    visible: mainWindow.playerCount === 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: console.log("Pong choosen")
                }

                Button {
                    text: qsTr("Space Invaders")
                    visible: mainWindow.playerCount === 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: console.log("Space Invaders choosen")
                }

                Button {
                    text: qsTr("Simple RPG")
                    visible: mainWindow.playerCount === 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: console.log("Simple RPG choosen")
                }
            }
        }
    }

    // Content Area

}
