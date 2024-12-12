import QtQuick
import QtQml

QtObject {
    id: labyrinthLogic

    property int width: 40
    property int height: 30
    property int boulder_cnt: 50

    property var player: ({ "x": 3, "y": 3, "type": "Player" })
    property var gate: ({ "x": 37, "y": 27, "type": "Gate" })
    property var boulders: []

    signal playerMoved()
    signal gateArrived()

    function initializeLabyrinth() {
        boulders = []

        for (let b = 0; b < boulder_cnt; ++b) {
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

    function checkBounds(newX, newY) {
        return (newX >= 0 && newX < width && newY >= 0 && newY < height)
    }

    function checkBoulders(newX, newY) {
        for (let boulder of boulders) {
            if (newX === boulder.x && newY === boulder.y)
                return false
        }
        return true
    }

    function checkGate(newX, newY) {
        return (newX === gate.x && newY === gate.y)
    }

    function handleKey(key) {
        let move = { x: 0, y: 0 };

        if (key === Qt.Key_Up || key === Qt.Key_W) {
            move.y = -1;
        } else if (key === Qt.Key_Down || key === Qt.Key_S) {
            move.y = 1;
        } else if (key === Qt.Key_Left || key === Qt.Key_A) {
            move.x = -1;
        } else if (key === Qt.Key_Right || key === Qt.Key_D) {
            move.x = 1;
        }

        let newX = player.x + move.x;
        let newY = player.y + move.y;

        // check collisions
        let inBounds = checkBounds(newX, newY);
        let notBlocked = checkBoulders(newX, newY);
        let gateReached = checkGate(newX, newY);

        if (inBounds && notBlocked) {
            player.x = newX;
            player.y = newY;
            if (gateReached) {
                gateArrived();
            } else {
                playerMoved();
            }
        }
    }
}
