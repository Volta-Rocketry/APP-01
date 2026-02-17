import QtQuick
import QtQuick.Controls
import APP 1.0

Rectangle {
    id: display
    color: Constants.backgroundMain

    readonly property int baseW: 1920
    readonly property int baseH: 1080

    width: Constants.designWidthloader
    height: Constants.designHeightloader

    Rectangle {
        id: camera
        color: "#000000"
        anchors.fill: parent
    }
    Rectangle {
        id: map
        width: 360
        height: 199
        color: "#888888"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.topMargin: 0
    }
}
