import QtQuick
import QtQuick.Controls

Item{
    width: 800
    height: 640

    Rectangle {
        anchors.fill: parent
        color: "lightblue"

        Text {
            text: "Hallo Galgenmann"
            font.pixelSize: 24
            anchors.centerIn: parent
        }

        Button {
            text: "Zurück"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            onClicked: {
                windowStack.pop()
            }
        }
    }
}
