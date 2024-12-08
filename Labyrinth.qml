pragma ComponentBehavior: Bound // needed, for access to labyrinth in deeper nesting

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Item{
    id: qLabyrinth

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    property int steps: 0
    property int maxSteps: 50
    property int boulders: 50
    property int gameWidth: 800
    property int gameHeight: 600
    property int fieldSize: 20
    property var labyrinth: {} // is managed trough cpp
    property var boulderPositions: []

    Component.onCompleted: {
        resetGame();
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
                Layout.preferredWidth: qLabyrinth.gameWidth
                Layout.preferredHeight: qLabyrinth.gameHeight
                Layout.alignment: Qt.AlignHCenter
                color: "lightgray"

                Grid {
                    id: playfield
                    anchors.centerIn: parent
                    columns: Math.floor(qLabyrinth.gameWidth / qLabyrinth.fieldSize)
                    rows: Math.floor(qLabyrinth.gameHeight / qLabyrinth.fieldSize)

                    Repeater {
                        model: playfield.columns * playfield.rows
                        Rectangle {
                            width: qLabyrinth.fieldSize
                            height: qLabyrinth.fieldSize
                            opacity: 0
                            required property int index

                            //save rectangle === field in the map
                            Component.onCompleted: {
                                if (qLabyrinth.labyrinth) {
                                    var x = Math.floor(index % playfield.columns)
                                    var y = Math.floor(index / playfield.columns)
                                    qLabyrinth.labyrinth.addField(x, y, {id: parent})
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
                        qLabyrinth.resetGame()
                        windowStack.pop()
                    }
                }
                Button {
                    text: "Neues Spiel"
                    onClicked: qLabyrinth.resetGame()
                }
            }
        }
    }

    // define functions
    function resetGame() {

    }

    function setBoulders() {
        while (boulderPositions.length < boulders) {
            var randomIndex = Math.floor(Math.random() * (columns * rows));
            if (boulderPositions.indexOf(randomIndex) === -1) { // get sure the boulders are unique
                boulderPositions.push(randomIndex);
            }
        }
    }
}
