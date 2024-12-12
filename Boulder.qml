import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

pragma ComponentBehavior: Bound

Item {
    id: boulder

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    property var logic // get logic class from main
    property int fieldSize: 20
    property bool success: false

    Component.onCompleted: {
        forceActiveFocus()
    }

    Connections {
        target: boulder.logic
        function onGateArrived() { boulder.success = true }
    }

    Flickable {
        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: columnLayout.implicitHeight + 100

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            Text {
                Layout.fillWidth: true
                text: "Labyrinth"
                font.pixelSize: 36
                color: "#4C0E52"
                horizontalAlignment: Text.AlignHCenter
            }

            // Playfield
            Rectangle {
                Layout.preferredWidth: boulder.logic.width * boulder.fieldSize
                Layout.preferredHeight: boulder.logic.height * boulder.fieldSize
                Layout.alignment: Qt.AlignHCenter
                visible: !boulder.success

                Grid {
                    id: playfield
                    anchors.centerIn: parent
                    columns: boulder.logic.width
                    rows: boulder.logic.height

                    Repeater {
                        model: boulder.logic.width * boulder.logic.height
                        Rectangle {
                            width: boulder.fieldSize
                            height: boulder.fieldSize
                            color: "lightgrey"
                            opacity: 100
                            required property int index

                            Image {
                                id: icon
                                anchors.centerIn: parent
                            }

                            // check if any object should be here displayed
                            Component.onCompleted: {
                                updateIcon();
                            }

                            function updateIcon() {
                                let x = index % boulder.logic.width;
                                let y = Math.floor(index / boulder.logic.width);
                                if (x === boulder.logic.player.x && y === boulder.logic.player.y) {
                                    icon.source = "qrc:/Assets/Boulder/Hero.png";
                                } else if (x === boulder.logic.gate.x && y === boulder.logic.gate.y) {
                                    icon.source = "qrc:/Assets/Boulder/Gate.png";
                                } else if (boulder.logic.boulders.some(boulder => boulder.x === x && boulder.y === y)) {
                                    icon.source = "qrc:/Assets/Boulder/Boulder.png";
                                } else {
                                    icon.source = ""; // Keine Grafik anzeigen
                                }
                            }

                            Connections {
                                target: boulder.logic
                                function onPlayerMoved() { updateIcon() }
                            }
                        }
                    }
                }
            }

            // WonRectangle
            Text {
                Layout.fillWidth: true
                visible: boulder.success
                font.pixelSize: 24
                color: "#6abe30"
                text: "Du hast gewonnen"
                horizontalAlignment: Text.AlignHCenter
            }


            Rectangle {
                Layout.preferredWidth: boulder.logic.width * boulder.fieldSize
                Layout.preferredHeight: boulder.logic.height * boulder.fieldSize
                visible: boulder.success

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/Assets/Boulder/Arrived.png"
                    width: 240
                    height: 240
                    fillMode: Image.Stretch
                    smooth: false
                }
            }


            // controll buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                Button {
                    text: "Spiel beenden"
                    onClicked: {
                        boulder.resetGame()
                        windowStack.pop()
                    }
                }
                Button {
                    text: "Neues Spiel"
                    onClicked: boulder.resetGame()
                }
            }
        }
    }

    // define functions
    function resetGame() {
        success = false
        logic.reset()
    }

    Keys.onPressed: function(event) {
        logic.handleKey(event.key)
    }
}
