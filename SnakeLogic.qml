import QtQuick
import QtQml

QtObject {
    id: snakeLogic

    property int width: 30
    property int height: 20

    property int baseFrame: 4000
    property int oSpeed: 5

    property var head: ({ x: 0, y: 0})
    property var body: [{ x: 0, y: 0}]
    property var fruit: ({ x: 0, y: 0})
    property var move: ({x: 0, y: 0, direction: "North"})
    property int speed: oSpeed
    property bool grow: false

    signal repaint()
    signal gameOver()
    signal scoreUpdate()

    function initializeSnake() {
        /* Initialize the Game */
        // set random movement of the snake
        var directions = ["North", "West", "East", "South"];
        var index = Math.floor(Math.random() * directions.length);
        let direction = directions[index];

        switch (direction) {
            case "North":
                move.x = 0;
                move.y = -1;
                break;
            case "South":
                move.x = 0;
                move.y = 1;
                break;
            case "West":
                move.x = -1;
                move.y = 0;
                break;
            case "East":
                move.x = 1;
                move.y = 0;
                break;
        }
        move.direction = direction

        // set random position of the snake
        head.x = Math.floor(Math.random() * (width - 10)) + 5;
        head.y = Math.floor(Math.random() * (height - 10)) + 5;

        // and add the tail
        body[0].x = head.x - move.x;
        body[0].y = head.y - move.y;

        // set random position of the fruit
        setFruitPosition();
    }

    function setFruitPosition() {
        /* set the Fruit to a new Position */
        fruit.x = Math.floor(Math.random() * (width));
        fruit.y = Math.floor(Math.random() * (height));
    }

    function checkEdge(newX, newY) {
        /* check if Snakehead hit the edge of the playfield */
        return (newX === -1 || newX === width || newY === -1 || newY === height)
    }

    function checkCollision(newX, newY) {
        /* check if Snakehead collides with the body (not tail) */
        for (var i = 0; i < body.length - 1; i++) {
            if (head.x === body[i].x && head.y === body[i].y) {
                return true;
            }
        }
        return false;
    }

    function checkFruit(newX, newY) {
        /* check if Snakehead collides with the fruit */
        if (head.x === fruit.x && head.y === fruit.y) {
            grow = true;
            setFruitPosition();
        }
    }

    function handleKey(key) {
        /* handle user input */
        if (key === Qt.Key_Up || key === Qt.Key_W) {
            move.x = 0;
            move.y = -1;
        } else if (key === Qt.Key_Down || key === Qt.Key_S) {
            move.x = 0;
            move.y = 1;
        } else if (key === Qt.Key_Left || key === Qt.Key_A) {
            move.x = -1;
            move.y = 0;
        } else if (key === Qt.Key_Right || key === Qt.Key_D) {
            move.x = 1;
            move.y = 0;
        }
    }

    function newFrame() {
        /* calculate next Frame */
        let newX = head.x + move.x;
        let newY = head.y + move.y;

        // check collisions
        let edgeCollision = checkEdge(newX, newY);
        let bodyCollision = checkCollision(newX, newY);
        checkFruit(newX, newY);

        if (edgeCollision || bodyCollision) {
            gameOver()
        } else {
            var max = body.length - 1;
            var tail = { x: body[max].x, y: body[max].y}

            // move body and tail
            for (var i = max; i > 0; i--) {
                body[i].x = body[i-1].x;
                body[i].y = body[i-1].y;
            }
            body[0].x = head.x
            body[0].y = head.y

            // move the head
            head.x = newX;
            head.y = newY;

            // add snake segment, if fruit was eaten
            if(grow) {
                body.push(tail);
                speed += 1;
                grow = false;
                scoreUpdate();
            }
        }
        for (var i = 0; i < body.length; i++) {
            console.log(`Body ${i}: ${body[i].x}, ${body[i].y}`)
        }
        repaint();
    }

    function resetGame() {
        /* reset the game */
        body = [];
        body = [{ x: 0, y: 0}];
        speed = oSpeed;
        initializeSnake();
        scoreUpdate();
        repaint();
    }
}
