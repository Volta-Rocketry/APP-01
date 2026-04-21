
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
import QtLocation
import QtPositioning

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
    property alias telemetryMap: telemetryMap
    property real mapCenterLat: 0.0
    property real mapCenterLon: 0.0
    property bool mapHasGps: false
    property var mapPath: []
    property real mapZoomLevel: 17.5

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
        anchors.rightMargin: 28

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
        width: parent.width * 0.20

        Rectangle {
            id: mapArea
            color: "#888888"
            anchors.fill: parent
            anchors.margins: 8
            anchors.leftMargin: 0

            Plugin {
                id: mapPlugin
                name: "osm"
            }

            Map {
                id: telemetryMap
                anchors.fill: parent
                plugin: mapPlugin
                zoomLevel: mapZoomLevel
                center: QtPositioning.coordinate(mapCenterLat, mapCenterLon)
                activeMapType: supportedMapTypes.length > 0 ? supportedMapTypes[0] : null

                Behavior on center {
                    CoordinateAnimation {
                        duration: 350
                    }
                }

                MapPolyline {
                    path: mapPath
                    line.width: 4
                    line.color: "#FFB300"
                    smooth: true
                }

                MapCircle {
                    center: QtPositioning.coordinate(mapCenterLat, mapCenterLon)
                    radius: 25
                    color: "#55FF5722"
                    border.width: 2
                    border.color: "#FFFFFF"
                    visible: mapHasGps
                }

                MapQuickItem {
                    id: rocketMarker
                    visible: mapHasGps
                    coordinate: QtPositioning.coordinate(mapCenterLat, mapCenterLon)
                    anchorPoint.x: 14
                    anchorPoint.y: 14

                    sourceItem: Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: "#FF5722"
                        border.width: 2
                        border.color: "#FFFFFF"

                        Rectangle {
                            width: 14
                            height: 14
                            radius: 7
                            color: "#FFF"
                            anchors.centerIn: parent
                        }
                    }
                }

                Component.onCompleted: {
                    console.log("Map component completado")
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "#55000000"
                visible: !mapHasGps

                Text {
                    anchors.centerIn: parent
                    text: "Waiting for GPS..."
                    color: "#FFFFFF"
                    font.pointSize: 12
                    font.bold: true
                }
            }
        }
    }
}
