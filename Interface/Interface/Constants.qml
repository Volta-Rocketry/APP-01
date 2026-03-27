pragma Singleton
import QtQuick
import QtQuick.Studio.Application

QtObject {
    readonly property int designWidth: 1920
    readonly property int designHeight: 1080


    readonly property int designWidthloader: 1920
    readonly property int designHeightloader: 720

    readonly property font baseFont: Qt.font({
        family: Qt.application.font.family,
        pixelSize: Qt.application.font.pixelSize
    })

    readonly property font largeFont: Qt.font({
        family: Qt.application.font.family,
        pixelSize: Qt.application.font.pixelSize * 1.6
    })

    readonly property color backgroundOverlay: "#e4d9ff"
    readonly property color missionPrimary: "#4f1e53"
    readonly property color phasesBar: "#E27341"
    readonly property color fontPrimary: "#ffffff"
    readonly property color fontSecondary: "#64327a"
    readonly property color backgroundMain: "#e7e7e7"
    readonly property color backgroundPanel: "#f5f5f5"
    readonly property color transparentData: "#00FFFFFF"
    readonly property color black: "#000000"

    property string relativeFontDirectory: qsTr("fonts")

}
