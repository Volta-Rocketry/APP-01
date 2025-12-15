import QtQuick
import APP_01

Window {
    width: mainScreen.width
    height: mainScreen.height

    visible: true
    title: "APP_01"

    Screen01 {
        id: mainScreen

        anchors.centerIn: parent
    }

}

