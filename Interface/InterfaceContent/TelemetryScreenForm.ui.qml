import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick3D
import Interface 1.0
import QtCharts
import QtLocation
import QtPositioning
import "../Generated/QtQuick3D/Cohete11"

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
    property real rocketViewportSize: Math.min(rocket3dSection.width,
                                               rocket3dSection.height)
    property real rocketYOffset: -300

    // Vista 3D del cohete
    Rectangle {
        id: rocket3dSection
        color: Constants.backgroundMain
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: topContentOffset
        anchors.bottom: parent.bottom
        width: parent.width * 0.25

        View3D {
            id: euler_angles
            anchors.fill: parent
            anchors.margins: 0
            anchors.leftMargin: 8
            anchors.rightMargin: 0
            anchors.topMargin: 16
            anchors.bottomMargin: 8
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
                x: 0
                y: 0
                clipNear: 1
                horizontalMagnification: 1.0
                verticalMagnification: 1.0
                clipFar: 5000
                scale.z: display.height * 0.00075
                scale.y: display.height * 0.00075
                scale.x: display.height * 0.00075
                z: 800
            }

            Cohete11 {
                id: _final
                position: Qt.vector3d(0, rocketYOffset, 0)
                scale.z: rocketViewportSize * 0.0004
                scale.y: rocketViewportSize * 0.0004
                scale.x: rocketViewportSize * 0.0004
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
        anchors.topMargin: topContentOffset
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
        anchors.topMargin: topContentOffset
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
                        Shape {
                            x: 12
                            y: 0
                            width: 6
                            height: 6

                            ShapePath {
                                strokeColor: "transparent"
                                fillColor: "#E0AAFF"
                                startX: 3
                                startY: 0
                                PathLine {
                                    x: 6
                                    y: 6
                                }
                                PathLine {
                                    x: 0
                                    y: 6
                                }
                                PathLine {
                                    x: 3
                                    y: 0
                                }
                            }
                        }

                        // Aleta izquierda
                        Shape {
                            x: 6
                            y: 20
                            width: 8
                            height: 12

                            ShapePath {
                                strokeColor: "transparent"
                                fillColor: "#C77DFF"
                                startX: 0
                                startY: 0
                                PathLine {
                                    x: 8
                                    y: 0
                                }
                                PathLine {
                                    x: 2
                                    y: 12
                                }
                                PathLine {
                                    x: 0
                                    y: 0
                                }
                            }
                        }

                        // Aleta derecha
                        Shape {
                            x: 16
                            y: 20
                            width: 8
                            height: 12

                            ShapePath {
                                strokeColor: "transparent"
                                fillColor: "#C77DFF"
                                startX: 8
                                startY: 0
                                PathLine {
                                    x: 0
                                    y: 0
                                }
                                PathLine {
                                    x: 6
                                    y: 12
                                }
                                PathLine {
                                    x: 8
                                    y: 0
                                }
                            }
                        }

                        // Fuego del cohete
                        Shape {
                            x: 12
                            y: 30
                            width: 6
                            height: 8

                            ShapePath {
                                strokeColor: "transparent"
                                fillColor: "#FF6B35"
                                startX: 1
                                startY: 0
                                PathLine {
                                    x: 3
                                    y: 8
                                }
                                PathLine {
                                    x: 5
                                    y: 0
                                }
                                PathLine {
                                    x: 4
                                    y: 4
                                }
                                PathLine {
                                    x: 2
                                    y: 4
                                }
                                PathLine {
                                    x: 1
                                    y: 0
                                }
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

/*##^##
Designer {
    D{i:0}D{i:2;cameraSpeed3d:25;cameraSpeed3dMultiplier:1}
}
##^##*/
