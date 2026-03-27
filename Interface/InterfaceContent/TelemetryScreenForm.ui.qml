

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import Interface 1.0
import QtQuick.Layouts
import QtCharts

Rectangle {
    id: display
    color: Constants.backgroundMain

    readonly property int baseW: 1920
    readonly property int baseH: 1080

    width: Constants.designWidthloader
    height: Constants.designHeightloader

    ChartView {
        id: spline
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 459
        anchors.rightMargin: 511
        anchors.topMargin: 40
        anchors.bottomMargin: 31
        title: "ALTITUDE VS TIME"

        localizeNumbers: false
        dropShadowEnabled: true
        backgroundRoundness: 6.7
        titleColor: "#000000"
        backgroundColor: Constants.backgroundMain
        antialiasing: true
    }

    Rectangle {
        id: map
        color: "#888888"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 1460
        anchors.rightMargin: 0
        anchors.topMargin: 31
        anchors.bottomMargin: 357
    }

    Rectangle {
        id: camera
        color: "#000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 1460
        anchors.rightMargin: 0
        anchors.topMargin: 355
        anchors.bottomMargin: 33
    }

    Rectangle {
        id: rocket
        color: "#000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 29
        anchors.rightMargin: 1504
        anchors.topMargin: 31
        anchors.bottomMargin: 33
    }
}
