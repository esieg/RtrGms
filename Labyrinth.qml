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
        /*console.log("Logic in Presentation")
        console.log(`${logic.player.type}: ${logic.player.x},${logic.player.y}`)
        console.log(`${logic.gate.type}: ${logic.gate.x},${logic.gate.y}`)
        for (let boulder of logic.boulders) {
            console.log(`${boulder.type}: ${boulder.x},${boulder.y}`)
        }*/
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
                                // TODO: Nochmal X und Y überprüfen, auch in der Logik!
                                x = index % labyrinth.logic.width
                                y = Math.floor(index / labyrinth.logic.width)
                                if(x === labyrinth.logic.player.x && y === labyrinth.logic.player.y) {
                                    icon.source = "qrc:/Assets/Labyrinth/Hero.png"
                                } else if (x === labyrinth.logic.gate.x && y === labyrinth.logic.gate.y) {
                                    icon.source = "qrc:/Assets/Labyrinth/Gate.png"
                                } else if (labyrinth.logic.boulders.some(boulder => boulder.x === x && boulder.y === y)) {
                                    icon.source = "qrc:/Assets/Labyrinth/Boulder.png"
                                }
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

    // Focus Handling
    focus: true
    Keys.enabled: true
    Keys.onPressed: {
        console.log("Key Pressed:", event.key)
        // Beispiel: Key-Ereignisse weitergeben
        if (logic) {
            logic.handleKeyPress(event.key); // Implementiere die Funktion in der Logik
        }
    }

}
