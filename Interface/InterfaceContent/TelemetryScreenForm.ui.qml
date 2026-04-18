
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
    readonly property int baseH: 712

    width: Constants.designWidth
    height: Constants.designHeight

    property alias spline: spline
    property alias axisX: axisX
    property alias axisY: axisY

    // Sección izquierda: Vista 3D del cohete (25% del ancho)
    Rectangle {
        id: rocket3dSection
        color: Constants.backgroundMain
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.25

        Rectangle {
            id: rocket3dArea
            color: "#222222"
            anchors.fill: parent
            anchors.margins: 10
            anchors.rightMargin: 32

            Text {
                anchors.centerIn: parent
                text: "3D ROCKET VIEW\n"
                font.pointSize: 18
                font.bold: true
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // Sección central: Gráfico de Altitud vs Tiempo (centro)
    Rectangle {
        id: chartSection
        color: Constants.backgroundMain
        anchors.left: rocket3dSection.right
        anchors.right: mapSection.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 40

        ChartView {
            id: spline
            anchors.fill: parent
            anchors.margins: 10
            anchors.leftMargin: 0
            anchors.rightMargin: 8
            anchors.topMargin: 12
            anchors.bottomMargin: 8

            title: "ALTITUDE VS TIME"
            titleFont.pointSize: 16
            titleFont.bold: true

            localizeNumbers: false
            dropShadowEnabled: true
            backgroundRoundness: 6
            titleColor: "#000000"
            backgroundColor: Constants.backgroundPanel
            antialiasing: true

            legend.visible: false

            ValueAxis {
                id: axisX
                titleText: "Time (s)"
                min: 0
                max: 100
            }

            ValueAxis {
                id: axisY
                titleText: "Altitude (m)"
                min: 0
                max: 1000
            }
        }
    }

    // Sección derecha: Mapa y telemetría adicional
    Rectangle {
        id: mapSection
        color: Constants.backgroundMain
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.15

        Rectangle {
            id: mapArea
            color: "#888888"
            anchors.fill: parent
            anchors.margins: 10
            anchors.leftMargin: -25

            Text {
                anchors.centerIn: parent
                text: "MAP VIEW"
                font.pointSize: 16
                font.bold: true
                color: "#ffffff"
            }
        }
    }
}
