import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Item{
    id: galgenmann
    width: 800
    height: 640

    // without this, we get problems at MacOS darkmode
    Material.theme: Material.Light

    property int maxErrors: 8
    property string word: ""
    property string guessedLetters: ""
    property string missGuessedLetters: ""

    ListView {
        id: wordModel //container to load all the words
        width: 0
        height: 0
        model: WordList { }
    }

    Component.onCompleted: {
        selectRandomWord();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            Layout.fillWidth: true
            text: "Galgenmann"
            font.pixelSize: 36
            color: "#4C0E52"
            horizontalAlignment: Text.AlignHCenter
        }

        // Galgenmann-Picture
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            color: "lightgray"

            Image {
                anchors.centerIn: parent
                source: "qrc:/Assets/Galgenmann/Galgenmann_" + galgenmann.missGuessedLetters.length + ".png"
            }
        }

        // Guessed and guessable letters
        RowLayout {
            Layout.fillWidth: true
            visible: !(galgenmann.missGuessedLetters.length >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
            spacing: 5
            Repeater {
                model: galgenmann.word.length
                Text {
                    text: galgenmann.guessedLetters.indexOf(galgenmann.word[index]) >= 0 ? galgenmann.word[index] : "_"
                    font.pixelSize: 24
                }
            }
        }

        // Errorcounter
        Text {
            Layout.fillWidth: true
            visible: !(galgenmann.missGuessedLetters.length >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
            text: `Fehler: ${galgenmann.missGuessedLetters.length} von ${galgenmann.maxErrors}`
            font.pixelSize: 18
        }

        // Until now guessed letters
        Text {
            Layout.fillWidth: true
            visible: !(galgenmann.missGuessedLetters.length >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
            text: `Falsch geraten: ${galgenmann.missGuessedLetters.split("").join(", ")}`
            font.pixelSize: 18
        }

        // Entryline and sendbutton
        RowLayout {
            Layout.fillWidth: true
            visible: !(galgenmann.missGuessedLetters.length >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
            spacing: 10
            TextField {
                id: inputField
                Layout.fillWidth: true
                placeholderText: "Buchstaben eingeben"
                font.pixelSize: 18
                validator: RegularExpressionValidator { regularExpression: /^[a-zA-Z]$/ }
                inputMethodHints: Qt.ImhUppercaseOnly
                onTextChanged: text = text.toUpperCase();
                onAccepted: galgenmann.sendGuess()
            }
            Button {
                text: qsTr("Raten")
                onClicked: galgenmann.sendGuess()
            }
        }

        Text {
            Layout.fillWidth: true
            visible: galgenmann.missGuessedLetters.length >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord()
            font.pixelSize: 18
            text: qsTr("Das Wort war:\t" + galgenmann.word)
        }

        // Result at the end of the game
        Text {
            Layout.fillWidth: true
            visible: galgenmann.missGuessedLetters.length >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord()
            font.pixelSize: 24
            color: galgenmann.missGuessedLetters.length >= galgenmann.maxErrors ? "#4C0E52" : "#6abe30"
            text: galgenmann.missGuessedLetters.length >= galgenmann.maxErrors ? "Du hast verloren" : "Du hast gewonnen"
            horizontalAlignment: Text.AlignHCenter
        }

        // controll buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            Button {
                text: "Spiel beenden"
                onClicked: {
                    galgenmann.resetGame()
                    windowStack.pop()
                }
            }
            Button {
                text: "Neues Spiel"
                onClicked: galgenmann.resetGame()
            }
        }
    }

    // define functions
    function selectRandomWord() {
        if (wordModel.model.count > 0) {
            var randomIndex = Math.floor(Math.random() * wordModel.model.count);
            word = wordModel.model.get(randomIndex).word;
        }
    }

    function sendGuess() {
        if(inputField.text.length > 0) {
            let guess = inputField.text.toUpperCase();
            if(word.indexOf(guess) === -1) {
                missGuessedLetters += guess;
            } else if(guessedLetters.indexOf(guess) === -1) {
                guessedLetters += guess;
            }
            inputField.text = "";
        }
    }

    function guessedLettersContainsWord() {
        for (let i = 0; i < word.length; i++) {
            if(guessedLetters.indexOf(word[i]) == -1) {
                return false;
            }
        }
        return true;
    }

    function resetGame() {
        missGuessedLetters = "";
        guessedLetters = "";
        selectRandomWord()
    }
}
