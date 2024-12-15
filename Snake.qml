import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

pragma ComponentBehavior: Bound

Item {
    id: snake

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    property var logic // get logic class from main
    property int fieldSize: 8
    property bool running: true
    property int resizefactor: 3 // TODO: Have to work on the size properly

    Component.onCompleted: {
        forceActiveFocus()
        gameTimer.start()
    }

    Connections {
        target: snake.logic
        function onGameOver() { snake.running = false }
        function onScoreUpdate() {scoreText.text = "Score: " + (snake.logic.body.length -1)}
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
                text: "Snake"
                font.pixelSize: 36
                color: "#4C0E52"
                horizontalAlignment: Text.AlignHCenter
            }

            // Playfield
            Rectangle {
                Layout.preferredWidth: snake.logic.width * snake.fieldSize * resizefactor
                Layout.preferredHeight: snake.logic.height * snake.fieldSize * resizefactor
                Layout.alignment: Qt.AlignHCenter
                visible: snake.running

                Grid {
                    id: playfield
                    anchors.centerIn: parent
                    columns: snake.logic.width
                    rows: snake.logic.height

                    Repeater {
                        model: snake.logic.width * snake.logic.height
                        Rectangle {
                            width: snake.fieldSize * snake.resizefactor
                            height: snake.fieldSize * snake.resizefactor
                            color: "lightgrey"
                            opacity: 100
                            required property int index

                            Image {
                                id: icon
                                anchors.centerIn: parent
                                width: implicitWidth * snake.resizefactor
                                height: implicitHeight * snake.resizefactor
                            }

                            // check if any object should be here displayed
                            Component.onCompleted: {
                                updateIcon();
                            }

                            function updateIcon() {
                                let x = index % snake.logic.width;
                                let y = Math.floor(index / snake.logic.width);
                                let body = false;

                                var snakelength = snake.logic.body.length;

                                // TODO: <Tail/Head/Body>_North_South...
                                for(var i = 0; i < snakelength; i++) {
                                    if (x === snake.logic.body[i].x && y === snake.logic.body[i].y) {
                                        body = true;
                                        if(i === snakelength - 1) {
                                            icon.source = "qrc:/Assets/Snake/Tail1.png";
                                        } else {
                                            icon.source = "qrc:/Assets/Snake/Body1.png";
                                        }
                                        break
                                    }
                                }

                                if (x === snake.logic.head.x && y === snake.logic.head.y) {
                                    icon.source = "qrc:/Assets/Snake/Head1.png";
                                } else if (x === snake.logic.fruit.x && y === snake.logic.fruit.y) {
                                    icon.source = "qrc:/Assets/Snake/Fruit.png";
                                } else if (!body){
                                    icon.source = "";
                                }
                            }

                            Connections {
                                target: snake.logic
                                function onRepaint() { updateIcon() }
                            }
                        }
                    }
                }
            }

            // GameOver
            Text {
                Layout.fillWidth: true
                visible: !snake.running
                font.pixelSize: 36
                color: "#4C0E52"
                text: "Game Over"
                horizontalAlignment: Text.AlignHCenter
            }

            // Score
            Text {
                id: scoreText
                Layout.fillWidth: true
                visible: true
                font.pixelSize: 24
                color: "#6abe30"
                text: "Score: " + (snake.logic.body.length -1)
                horizontalAlignment: Text.AlignHCenter
            }

            // controll buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                Button {
                    text: "Spiel beenden"
                    onClicked: {
                        resetGame()
                        windowStack.pop()
                    }
                }
                // TODO: check if snake.running is reset to true, after gameover
                Button {
                    text: "Neues Spiel"
                    onClicked: resetGame()
                }
            }
        }
    }

    // define functions
    function resetGame() {
        logic.resetGame()
        running = true
    }

    Timer {
        id: gameTimer
        interval: snake.logic.baseFrame / snake.logic.speed
        repeat: true
        running: true
        onTriggered: {
            snake.logic.newFrame()
            console.log(running)
        }
    }

    Keys.onPressed: function(event) {
        logic.handleKey(event.key)
    }
}
