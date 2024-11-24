import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item{
    id: galgenmann
    width: 800
    height: 640

    property int errors: 0
    property int maxErrors: 8
    property string word: ""
    property string guessedLetters: ""

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

        // Galgenmann-Picture
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            color: "lightgray"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 50
                text: (galgenmann.errors < galgenmann.maxErrors ? String(galgenmann.errors + 1) : "Game Over")
            }
        }

        // Guessed and guessable letters
        RowLayout {
            Layout.fillWidth: true
            visible: !(galgenmann.errors >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
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
            visible: !(galgenmann.errors >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
            text: `Fehler: ${galgenmann.errors} von ${galgenmann.maxErrors}`
            font.pixelSize: 18
        }

        // Until now guessed letters
        Text {
            Layout.fillWidth: true
            visible: !(galgenmann.errors >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
            text: `Bisher geschätzt: ${galgenmann.guessedLetters.split("").join(", ")}`
            font.pixelSize: 18
        }

        // Entryline and sendbutton
        RowLayout {
            Layout.fillWidth: true
            visible: !(galgenmann.errors >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord())
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
            visible: galgenmann.errors >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord()
            font.pixelSize: 18
            text: qsTr("Das Wort war:\t" + galgenmann.word)
        }

        // Result at the end of the game
        Text {
            Layout.fillWidth: true
            visible: galgenmann.errors >= galgenmann.maxErrors || galgenmann.guessedLettersContainsWord()
            font.pixelSize: 24
            color: galgenmann.errors >= galgenmann.maxErrors ? "red" : "green"
            text: galgenmann.errors >= galgenmann.maxErrors ? "Du hast verloren" : "Du hast gewonnen"
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
                errors++;
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
        errors = 0;
        guessedLetters = "";
        selectRandomWord()
    }
}
