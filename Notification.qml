import QtQuick
import QtQuick.Controls

Item {
    id: notification
    property string message: "Default Notification Message"
    property color backgroundColor: "lightyellow"
    property color foregroundColor: "black"
    property int displayDuration: 4000

    width: parent.width
    height: 70
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    opacity: 0.0
    visible: false
    z: 100 // get sure, notification will be displayed

    Rectangle {
        id: notificationBar
        width: parent.width
        height: parent.height
        color: notification.backgroundColor
        radius: 8

        Text {
            anchors.centerIn: parent
            text: notification.message
            color: notification.foregroundColor
        }
    }

    SequentialAnimation {
        id: notificationAnimation
        running: false
        onRunningChanged: if (!running) notification.visible = false

        ScriptAction { script: notification.visible = true }
        PropertyAnimation {
            target: notification
            property: "opacity"
            to: 1.0
            duration: 300
        }

        PauseAnimation { duration: notification.displayDuration }

        PropertyAnimation {
            target: notification
            property: "opacity"
            to: 0.0
            duration: 300
        }
    }

    // show a new Notification
    function showNotification() {
        // first, check that no other Notification is shown
        if (notificationAnimation.running) {
            notificationAnimation.stop();
        }
        notificationAnimation.start();
    }
}
