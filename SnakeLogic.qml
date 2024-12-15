import QtQuick
import QtQml

QtObject {
    id: snakeLogic

    property int width: 30
    property int height: 20

    property int baseFrame: 4000
    property int oSpeed: 8

    property var head: ({ x: 0, y: 0})
    property var body: [{ x: 0, y: 0, direction: "North"}]
    property var fruit: ({ x: 0, y: 0})
    property var move: ({x: 0, y: 0, direction: "North", last: "North"})
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
        body[0].direction = move.direction;

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
        move.last = move.direction;
        if (key === Qt.Key_Up || key === Qt.Key_W) {
            move.x = 0;
            move.y = -1;
            move.direction = "North";
        } else if (key === Qt.Key_Down || key === Qt.Key_S) {
            move.x = 0;
            move.y = 1;
            move.direction = "South";
        } else if (key === Qt.Key_Left || key === Qt.Key_A) {
            move.x = -1;
            move.y = 0;
            move.direction = "West";
        } else if (key === Qt.Key_Right || key === Qt.Key_D) {
            move.x = 1;
            move.y = 0;
            move.direction = "East";
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
            var tail = { x: body[max].x, y: body[max].y, direction: body[max].direction }

            // move body and tail
            for (var i = max; i > 0; i--) {
                body[i].x = body[i-1].x;
                body[i].y = body[i-1].y;
                body[i].direction = body[i-1].direction;
            }
            body[0].x = head.x;
            body[0].y = head.y;
            if (move.direction === move.last) {
                body[0].direction = move.direction;
            } else if (move.direction === "North" && move.last === "East") {
                body[0].direction = "East_North";
            } else if (move.direction === "North" && move.last === "West") {
                body[0].direction = "West_North";
            } else if (move.direction === "South" && move.last === "East"){
                body[0].direction = "East_South";
            } else if (move.direction === "South" && move.last === "West") {
                body[0].direction = "West_South";
            } else if (move.direction === "East" && move.last === "North") {
               body[0].direction = "North_East";
            } else if (move.direction === "East" && move.last === "South") {
               body[0].direction = "South_East";
            } else if (move.direction === "West" && move.last === "North"){
               body[0].direction = "North_West";
            } else if (move.direction === "West" && move.last === "South") {
               body[0].direction = "South_West";
            } else {
                body[0].direction = move.direction;
            }

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

            // handle tail single direction
            handleTailSingleDirection()

            // save last direction
            move.last = move.direction;
        }
        repaint();
    }

    function handleTailSingleDirection() {
        /* handle body with curve to single diretion at tail */
        var max = body.length - 1;
        if (body[max].direction === "North_East" || body[max].direction === "South_East") {
            body[max].direction = "East";
        } else if (body[max].direction === "North_West" || body[max].direction === "South_West") {
            body[max].direction = "West";
        } else if (body[max].direction === "West_North" || body[max].direction === "East_North") {
            body[max].direction = "North";
        } else if (body[max].direction === "West_South" || body[max].direction === "East_South") {
            body[max].direction = "South";
        }
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
