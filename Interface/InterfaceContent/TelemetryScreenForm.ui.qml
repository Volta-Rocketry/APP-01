
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick3D
import QtQuick.Controls
import Interface 1.0
import QtQuick.Layouts
import QtCharts
import QtLocation
import QtPositioning
import "../Generated/QtQuick3D/Test"
import "../Generated/QtQuick3D/Final"

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
    property bool mapHasGps: true
    property var mapPath: []
    property real mapZoomLevel: 17.5

    property real rocketX: 0.0
    property real rocketY: 0.0
    property real rocketZ: 0.0
    property real rocketRotationX: -90.0
    property real rocketRotationY: 0.0
    property real rocketRotationZ: 0.0

    // Vista 3D del cohete
    Rectangle {
        id: rocket3dSection
        color: Constants.backgroundMain
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.25

        View3D {
            id: euler_angles
            anchors.fill: parent
            anchors.margins: 12
            camera: orthographicCamera

            environment: SceneEnvironment {
                clearColor: Constants.missionPrimary
                backgroundMode: SceneEnvironment.Color
            }

            DirectionalLight {
                x: 1.529
                y: -1.242
                z: -89.18201
                brightness: 0.87
                eulerRotation.z: -2.07888
                eulerRotation.x: -0.79765
                eulerRotation.y: -0.98224
            }

            OrthographicCamera {
                id: orthographicCamera
                x: rocketX
                y: rocketZ
                clipNear: 10
                horizontalMagnification: 0.75
                clipFar: 800
                scale.z: display.height * 0.00046
                scale.y: display.height * 0.00046
                scale.x: display.height * 0.00046
                z: 372.98022
            }

            Test {
                id: testImg
                scale.z: display.height * 0.02778
                scale.y: display.height * 0.01852
                scale.x: display.height * 0.01852
                eulerRotation.z: 0
                eulerRotation.y: 90
                eulerRotation.x: -90
                visible: false
            }

            Final {
                id: _final
                position: Qt.vector3d(rocketX, rocketY, rocketZ)
                scale.z: display.height * 0.00139
                scale.y: display.height * 0.00139
                scale.x: display.height * 0.00139
                eulerRotation.x: rocketRotationX
                eulerRotation.y: rocketRotationY
                eulerRotation.z: rocketRotationZ
                z: 0.00001
            }
        }
    }

    // Gráfico de Altitud vs Tiempo
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
            anchors.rightMargin: 13
            anchors.topMargin: 0
            anchors.bottomMargin: 0

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
                titleText: "Altitude (ft)"
                min: 0
                max: 1000
            }

            SplineSeries {
                id: altitudeSeries
                axisX: axisX
                axisY: axisY
                color: "#00FF00"
                width: 2
            }
        }
    }

    // Mapa
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
            anchors.leftMargin: -27
            anchors.rightMargin: 8
            anchors.topMargin: 16
            anchors.bottomMargin: 8

            Plugin {
                id: mapPlugin
                name: "osm"
                PluginParameter {
                    name: "osm.mapping.custom.scheme"
                    value: "https"
                }
                PluginParameter {
                    name: "osm.mapping.custom.host"
                    value: "a.tile.openstreetmap.org"
                }
                PluginParameter {
                    name: "osm.mapping.custom.path"
                    value: "/{z}/{x}/{y}.png"
                }
                PluginParameter {
                    name: "osm.mapping.custom.useragent"
                    value: "QtLocationOpenStreetMap"
                }
            }

            Map {
                id: telemetryMap
                anchors.fill: parent
                plugin: mapPlugin
                zoomLevel: mapZoomLevel
                copyrightsVisible: false

                MapPolyline {
                    id: trajectoryLine
                    line.color: "#800080"
                    line.width: 7
                    path: mapPath
                    visible: mapPath.length > 0
                }

                MapCircle {
                    id: trajectoryStartMarker
                    center: mapPath.length > 0 ? mapPath[0] : null
                    radius: 8
                    color: "#FFB300"
                    border.width: 2
                    border.color: "#FFFFFF"
                    visible: mapPath.length > 0
                    z: 3
                }

                MapCircle {
                    id: trajectoryEndMarker
                    center: mapPath.length > 0 ? mapPath[mapPath.length - 1] : null
                    radius: 12
                    color: "#FF4500"
                    border.width: 2
                    border.color: "#FFFFFF"
                    visible: mapPath.length > 0
                    z: 4
                }

                MapQuickItem {
                    id: currentPositionMarker
                    coordinate: mapPath.length > 0 ? mapPath[mapPath.length - 1] : null
                    anchorPoint.x: rocketIcon.width / 2
                    anchorPoint.y: rocketIcon.height / 2
                    visible: mapPath.length > 0
                    z: 5

                    sourceItem: Item {
                        id: rocketIcon
                        width: 30
                        height: 40

                        // Cuerpo del cohete
                        Rectangle {
                            x: 10
                            y: 5
                            width: 10
                            height: 25
                            color: "#9D4EDD"
                            radius: 3
                        }

                        // Punta del cohete
                        Canvas {
                            x: 12
                            y: 0
                            width: 6
                            height: 6
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.fillStyle = "#E0AAFF"
                                ctx.beginPath()
                                ctx.moveTo(3, 0)
                                ctx.lineTo(6, 6)
                                ctx.lineTo(0, 6)
                                ctx.closePath()
                                ctx.fill()
                            }
                        }

                        // Aleta izquierda
                        Canvas {
                            x: 6
                            y: 20
                            width: 8
                            height: 12
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.fillStyle = "#C77DFF"
                                ctx.beginPath()
                                ctx.moveTo(0, 0)
                                ctx.lineTo(8, 0)
                                ctx.lineTo(2, 12)
                                ctx.closePath()
                                ctx.fill()
                            }
                        }

                        // Aleta derecha
                        Canvas {
                            x: 16
                            y: 20
                            width: 8
                            height: 12
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.fillStyle = "#C77DFF"
                                ctx.beginPath()
                                ctx.moveTo(8, 0)
                                ctx.lineTo(0, 0)
                                ctx.lineTo(6, 12)
                                ctx.closePath()
                                ctx.fill()
                            }
                        }

                        // Fuego del cohete
                        Canvas {
                            x: 12
                            y: 30
                            width: 6
                            height: 8
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.fillStyle = "#FF6B35"
                                ctx.beginPath()
                                ctx.moveTo(1, 0)
                                ctx.lineTo(3, 8)
                                ctx.lineTo(5, 0)
                                ctx.lineTo(4, 4)
                                ctx.lineTo(2, 4)
                                ctx.closePath()
                                ctx.fill()
                            }
                        }

                        Rectangle {
                            x: 11
                            y: 30
                            width: 8
                            height: 10
                            color: "#FFD60A"
                            opacity: 0.6
                            radius: 2
                        }
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                color: "#55000000"
                visible: mapPath.length === 0

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

    Item {
        id: __materialLibrary__
    }
}
