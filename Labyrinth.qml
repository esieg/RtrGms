import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

pragma ComponentBehavior: Bound

Item {
    id: labyrinth

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    property var logic // get logic class from main
    property int fieldSize: 20

    Component.onCompleted: {
        forceActiveFocus()
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
                Layout.preferredWidth: labyrinth.logic.width * labyrinth.fieldSize
                Layout.preferredHeight: labyrinth.logic.height * labyrinth.fieldSize
                Layout.alignment: Qt.AlignHCenter

                Grid {
                    id: playfield
                    anchors.centerIn: parent
                    columns: labyrinth.logic.width
                    rows: labyrinth.logic.height

                    Repeater {
                        model: labyrinth.logic.width * labyrinth.logic.height
                        Rectangle {
                            width: labyrinth.fieldSize
                            height: labyrinth.fieldSize
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
                                let x = index % labyrinth.logic.width;
                                let y = Math.floor(index / labyrinth.logic.width);
                                if (x === labyrinth.logic.player.x && y === labyrinth.logic.player.y) {
                                    icon.source = "qrc:/Assets/Labyrinth/Hero.png";
                                } else if (x === labyrinth.logic.gate.x && y === labyrinth.logic.gate.y) {
                                    icon.source = "qrc:/Assets/Labyrinth/Gate.png";
                                } else if (labyrinth.logic.boulders.some(boulder => boulder.x === x && boulder.y === y)) {
                                    icon.source = "qrc:/Assets/Labyrinth/Boulder.png";
                                } else {
                                    icon.source = ""; // Keine Grafik anzeigen
                                }
                            }

                            Connections {
                                target: labyrinth.logic
                                function onPlayerMoved() { updateIcon() }
                            }
                        }
                    }
                }
            }

            // controll buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                Button {
                    text: "Spiel beenden"
                    onClicked: {
                        labyrinth.resetGame()
                        windowStack.pop()
                    }
                }
                Button {
                    text: "Neues Spiel"
                    onClicked: labyrinth.resetGame()
                }
            }
        }
    }

    // define functions
    function resetGame() {

    }

    Keys.onPressed: function(event) {
        logic.handleKey(event.key)
    }
}
