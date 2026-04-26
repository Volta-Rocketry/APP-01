
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

    // Propiedades para la posición y rotación del cohete 3D
    property real rocketX: 0.0
    property real rocketY: 0.0
    property real rocketZ: 0.0
    property real rocketRotationX: -90.0
    property real rocketRotationY: 0.0
    property real rocketRotationZ: 0.0

    // Sección izquierda: Vista 3D del cohete (25% del ancho)
    Rectangle {
        id: rocket3dSection
        color: Constants.backgroundMain
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.25
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
                titleText: "Altitude (m)"
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
            }

            Map {
                id: telemetryMap
                anchors.fill: parent
                plugin: mapPlugin
                center: QtPositioning.coordinate(mapCenterLat, mapCenterLon)
                zoomLevel: mapZoomLevel
                copyrightsVisible: false

                MapPolyline {
                    id: trajectoryLine
                    line.color: "#00FF00"
                    line.width: 2
                    path: mapPath
                }

                MapCircle {
                    id: currentPositionMarker
                    center: QtPositioning.coordinate(mapCenterLat, mapCenterLon)
                    radius: 10
                    color: "#FF0000"
                    border.width: 1
                    border.color: "#FFFFFF"
                    visible: mapHasGps
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
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

    Item {
        id: __materialLibrary__
    }

    View3D {
        id: euler_angles
        x: 1523
        y: 127
        //anchors.left: speedometer.horizontalCenter
        anchors.fill: parent
        anchors.leftMargin: 36
        anchors.rightMargin: 1476
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        camera: orthographicCamera

        environment: SceneEnvironment {
            clearColor: Constants.missionPrimary
            backgroundMode: SceneEnvironment.Color
        }


        /*Model {
           id: object
           position: Qt.vector3d(0, 0, 0)
           source: "#Cube" //""assets/images/test.glb"
           scale: Qt.vector3d(2, 1, 1)
           materials: [ DefaultMaterial {
                   diffuseColor: "red"
               }
           ]
       }*/
        DirectionalLight {
            x: 1.529
            y: -1.242
            z: -89.18201
            brightness: 0.87
            eulerRotation.z: -2.07888
            eulerRotation.x: -0.79765
            eulerRotation.y: -0.98224
        }


        /*
        Missile5 {
            id: missile5
            x: 0
            y: 0
            position: Qt.vector3d(0, 0, 0)
            z: 0
            eulerRotation.z: 0
            eulerRotation.y: 0
            pivot.x: 0
            pivot.y: 0
            eulerRotation.x: 0
            scale.z: 1
            scale.y: 1
            scale.x: 1
            pivot.z: 0
            scale: Qt.vector3d(2, 1, 1)
        }

    }*/
        OrthographicCamera {
            id: orthographicCamera
            x: -0
            y: 0
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
