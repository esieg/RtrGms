import QtQuick
import QtQml

QtObject {
    id: labyrinthLogic

    property int width: 40
    property int height: 30
    property int boulder_cnt: 50

    property var player: {"x": 3, "y": 3, "type": "Player"}
    property var gate: {"x": 37, "y": 27, "type": "Gate"}
    property var boulders: []

    function initializeLabyrinth() {
        boulders = []

        for(let b = 0; b < boulder_cnt; ++b) {
            let pos
            do {
                pos = {
                    "x": Math.floor(Math.random() * width),
                    "y": Math.floor(Math.random() * height),
                    "type": "Boulder"
                }
            } while (!isPositionUnique(pos))

            boulders.push(pos)
        }
    }

    function isPositionUnique(pos) {
        // check against Player
        if (pos.x === player.x && pos.y === player.y)
            return false
        // check against Gate
        if (pos.x === gate.x && pos.y === gate.y)
            return false
        // check against other boulders
        for (let boulder of boulders) {
            if (pos.x === boulder.x && pos.y === boulder.y)
                return false
        }
        return true
    }

    function handleKey(key) {
        if (key === Qt.Key_Up) {
            player.x -= 1;
        } else if (key === Qt.Key_Down) {
            player.x += 1;
        } else if (key === Qt.Key_Left) {
            player.y -= 1;
        } else if (key === Qt.Key_Right) {
            player.y += 1;
        }
        console.log(`Player: ${player.x}, ${player.y}`)
    }
}
