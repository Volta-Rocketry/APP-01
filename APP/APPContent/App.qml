import QtQuick
import APP
import QtQuick.VirtualKeyboard

Window {
    width: mainScreen.width
    height: mainScreen.height

    visible: true
    title: "APP"

    Screen01 {
        id: mainScreen

        anchors.centerIn: parent
    }

    InputPanel {
        id: inputPanel
        property bool showKeyboard :  active
        y: showKeyboard ? parent.height - height : parent.height
        Behavior on y {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        anchors.leftMargin: Constants.width/10
        anchors.rightMargin: Constants.width/10
        anchors.left: parent.left
        anchors.right: parent.right
    }
}

