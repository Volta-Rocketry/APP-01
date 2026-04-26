
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

    width: Constants.designWidth
    height: Constants.designHeight

    property alias content: content
    property alias loader: loader

    property string latitudeText: "0.0000000 N"
    property string longitudeText: "0.0000000 W"
    property string altitudeFtText: "0 ft"
    property string altitudeMText: "0 m"
    property string speedFtText: "0 ft/s"
    property string speedMText: "0 m/s"
    property string accelerationFtText: "0 ft/s²"
    property string accelerationMText: "0 m/s²"
    property string voltageText: "0.00 v"
    property string temperatureText: "0° f"
    property string timeText: "T: 00:00.00"
    property real flightPhaseValue: 0
    property real missionProgressValue: 0
    property real speedDialValue: 0
    property real altitudeDialValue: 0
    property real accelerationDialValue: 0

    Item {
        id: content
        width: baseW
        height: baseH
        anchors.fill: parent

        transform: Scale {
            origin.x: 0
            origin.y: 0
            xScale: display.width / baseW
            yScale: display.height / baseH
        }

        Rectangle {
            id: down
            x: 0
            width: 1920
            height: 177
            opacity: 1
            visible: true
            color: Constants.backgroundMain
            anchors.verticalCenter: loader.verticalCenter
            anchors.verticalCenterOffset: 450
            clip: false

            Rectangle {
                id: rectangleAcceleration
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 1137
                anchors.rightMargin: 553
                anchors.topMargin: -13
                anchors.bottomMargin: 3

                Text {
                    id: accelerationValue1
                    color: Constants.fontSecondary
                    text: accelerationFtText
                    elide: Text.ElideNone
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 60
                    anchors.rightMargin: 88
                    anchors.topMargin: 89
                    anchors.bottomMargin: 60
                    font.weight: Font.Thin
                    font.pointSize: 18
                    font.family: "Nasalization"
                }

                Text {
                    id: accelerationValue2
                    color: Constants.fontSecondary
                    text: accelerationMText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 58
                    anchors.rightMargin: 86
                    anchors.topMargin: 133
                    anchors.bottomMargin: 16
                    font.weight: Font.Thin
                    font.pointSize: 18
                    font.family: "Nasalization"
                }

                Text {
                    id: acceleration
                    color: Constants.fontSecondary
                    text: "ACCELERATION"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.rightMargin: 17
                    anchors.topMargin: 7
                    anchors.bottomMargin: 142
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Dial {
                    id: dialAcceleration
                    from: 0
                    to: 200
                    value: accelerationDialValue
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 29
                    anchors.rightMargin: 41
                    anchors.topMargin: 48
                    anchors.bottomMargin: -21
                }
            }

            Rectangle {
                id: rectangleAltitude
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 849
                anchors.rightMargin: 871
                anchors.topMargin: -13
                anchors.bottomMargin: 3

                Text {
                    id: altitudeValue1
                    x: 57
                    y: 88
                    color: Constants.fontSecondary
                    text: altitudeFtText
                    font.weight: Font.Thin
                    font.pointSize: 18
                    font.family: "Nasalization"
                }

                Text {
                    id: altitudeValue2
                    color: Constants.fontSecondary
                    text: altitudeMText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 57
                    anchors.rightMargin: 92
                    anchors.topMargin: 126
                    anchors.bottomMargin: 23
                    font.weight: Font.Thin
                    font.pointSize: 18
                    font.family: "Nasalization"
                }

                Text {
                    id: altitude
                    color: Constants.fontSecondary
                    text: "ALTITUDE"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 30
                    anchors.rightMargin: 33
                    anchors.topMargin: 7
                    anchors.bottomMargin: 142
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Dial {
                    id: dialAltitude
                    from: 0
                    to: 11000
                    value: altitudeDialValue
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 22
                    anchors.rightMargin: 18
                    anchors.topMargin: 48
                    anchors.bottomMargin: -21
                }
            }

            Rectangle {
                id: rectangleSpeed
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 538
                anchors.rightMargin: 1182
                anchors.topMargin: -13
                anchors.bottomMargin: 3

                Text {
                    id: speedValue1
                    color: Constants.fontSecondary
                    text: speedFtText
                    elide: Text.ElideNone
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 53
                    anchors.rightMargin: 92
                    anchors.topMargin: 91
                    anchors.bottomMargin: 71
                    verticalAlignment: Text.AlignTop
                    font.weight: Font.Thin
                    font.pointSize: 18
                    font.family: "Nasalization"
                }

                Text {
                    id: speed
                    color: Constants.fontSecondary
                    text: "SPEED"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 58
                    anchors.rightMargin: 53
                    anchors.topMargin: 7
                    anchors.bottomMargin: 142
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Text {
                    id: speedValue2
                    color: Constants.fontSecondary
                    text: speedMText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 53
                    anchors.rightMargin: 70
                    anchors.topMargin: 131
                    anchors.bottomMargin: 18
                    font.weight: Font.Thin
                    font.pointSize: 18
                    font.family: "Nasalization"
                }

                Dial {
                    id: dialSpeed
                    from: 0
                    to: 500
                    value: speedDialValue
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 23
                    anchors.rightMargin: 17
                    anchors.topMargin: 48
                    anchors.bottomMargin: -21
                }
            }

            Rectangle {
                id: rectangleLatitude
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 29
                anchors.rightMargin: 1531
                anchors.topMargin: 12
                anchors.bottomMargin: 13

                Text {
                    id: latitudeValue
                    color: Constants.fontSecondary
                    text: latitudeText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 152
                    anchors.rightMargin: 18
                    anchors.topMargin: 84
                    anchors.bottomMargin: 30
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Text {
                    id: latitude
                    color: Constants.fontSecondary
                    text: "LATITUDE"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 176
                    anchors.rightMargin: 41
                    anchors.topMargin: 49
                    anchors.bottomMargin: 65
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Image {
                    id: coordinateImage1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: -8
                    anchors.rightMargin: 208
                    anchors.topMargin: 11
                    anchors.bottomMargin: 7
                    source: "images/coordenada.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: coordinateImage
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1452
                    anchors.rightMargin: -1252
                    anchors.topMargin: 11
                    anchors.bottomMargin: 7
                    source: "images/coordenada.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                id: rectangleLongitude
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 1483
                anchors.rightMargin: 77
                anchors.topMargin: 12
                anchors.bottomMargin: 13

                Text {
                    id: longitudeValue
                    color: Constants.fontSecondary
                    text: longitudeText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 154
                    anchors.rightMargin: 7
                    anchors.topMargin: 84
                    anchors.bottomMargin: 30
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Text {
                    id: longitude
                    color: Constants.fontSecondary
                    text: "LONGITUDE"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 171
                    anchors.rightMargin: 23
                    anchors.topMargin: 49
                    anchors.bottomMargin: 65
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }
            }
        }

        Loader {
            id: loader
            y: 191
            width: 1920
            height: 712
            source: "TelemetryScreen.qml"
        }
        Rectangle {
            id: up
            x: 0
            y: 0
            width: 1920
            height: 193
            color: Constants.fontPrimary

            Rectangle {
                id: part1
                x: 0
                width: 1920
                height: 92
                color: Constants.missionPrimary
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -51

                Image {
                    id: voltage
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1317
                    anchors.rightMargin: 558
                    anchors.topMargin: 0
                    anchors.bottomMargin: 47
                    source: "images/voltaje.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: colombia
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1777
                    anchors.rightMargin: -5
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    source: "images/colombia.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: temperature
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1317
                    anchors.rightMargin: 558
                    anchors.topMargin: 47
                    anchors.bottomMargin: 0
                    source: "images/tempe (1).svg"
                    anchors.verticalCenterOffset: -494
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: nameMission
                    color: Constants.fontPrimary
                    text: "MISSION CATTLEYA  "
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 100
                    anchors.rightMargin: 1422
                    anchors.topMargin: 24
                    anchors.bottomMargin: 8
                    anchors.verticalCenterOffset: -494
                    clip: false
                    font.weight: Font.Thin
                    font.pointSize: 30
                    font.family: "Nasalization"
                }

                Text {
                    id: timeValue
                    color: Constants.fontPrimary
                    text: timeText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 782
                    anchors.rightMargin: 880
                    anchors.topMargin: 17
                    anchors.bottomMargin: 13
                    anchors.verticalCenterOffset: -494
                    font.weight: Font.Thin
                    font.pointSize: 35
                    font.family: "Nasalization"
                }

                Text {
                    id: voltageValue
                    color: Constants.fontPrimary
                    text: voltageText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1381
                    anchors.rightMargin: 440
                    anchors.topMargin: 2
                    anchors.bottomMargin: 47
                    anchors.verticalCenterOffset: -494
                    font.weight: Font.ExtraBold
                    font.pointSize: 25
                    font.family: "Nasalization"
                }

                Text {
                    id: temperatureValue
                    color: Constants.fontPrimary
                    text: temperatureText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1423
                    anchors.rightMargin: 440
                    anchors.topMargin: 49
                    anchors.bottomMargin: 0
                    anchors.verticalCenterOffset: -494
                    font.weight: Font.ExtraBold
                    font.pointSize: 25
                    font.family: "Nasalization"
                }

                Image {
                    id: flower
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 1820
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    source: "images/flor.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: logoU
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1549
                    anchors.rightMargin: 279
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    source: "images/logoU.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: logoU1
                    x: 2882
                    y: -94
                    source: "images/logoU.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: nameMission1
                    color: Constants.fontPrimary
                    text: "TEAM "
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1647
                    anchors.rightMargin: 149
                    anchors.topMargin: 0
                    anchors.bottomMargin: 32
                    font.weight: Font.Thin
                    font.pointSize: 30
                    font.family: "Nasalization"
                    clip: false
                    anchors.verticalCenterOffset: -494
                }

                Text {
                    id: nameMission2
                    color: Constants.fontPrimary
                    text: "41"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1684
                    anchors.rightMargin: 112
                    anchors.topMargin: 40
                    anchors.bottomMargin: -8
                    font.weight: Font.Thin
                    font.pointSize: 30
                    font.family: "Nasalization"
                    clip: false
                    anchors.verticalCenterOffset: -494
                }
            }

            Rectangle {
                id: flightPhases
                x: 0
                width: 1920
                height: 94
                color: Constants.missionPrimary
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 49

                Text {
                    id: ascent
                    color: flightPhaseValue >= 1 ? "#ffffff" : "#caa6d2"
                    text: "ASCENT"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 100
                    anchors.rightMargin: 1706
                    anchors.topMargin: 11
                    anchors.bottomMargin: 42
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Text {
                    id: apogee
                    color: flightPhaseValue >= 2 ? "#ffffff" : "#caa6d2"
                    text: "APOGEE"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 600
                    anchors.rightMargin: 1205
                    anchors.topMargin: 11
                    anchors.bottomMargin: 42
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Text {
                    id: mainChute
                    color: flightPhaseValue >= 3 ? "#ffffff" : "#caa6d2"
                    text: "MAIN CHUTE"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1100
                    anchors.rightMargin: 638
                    anchors.topMargin: 11
                    anchors.bottomMargin: 42
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                Text {
                    id: touchDown
                    color: flightPhaseValue >= 4 ? "#ffffff" : "#caa6d2"
                    text: "TOUCH DOWN"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1625
                    anchors.rightMargin: 100
                    anchors.topMargin: 11
                    anchors.bottomMargin: 42
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Nasalization"
                }

                // Progress Bar Background
                Rectangle {
                    id: progressBarBackground
                    color: "#333333"
                    radius: 8
                    clip: true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 29
                    anchors.rightMargin: 21
                    anchors.topMargin: 55
                    anchors.bottomMargin: 16

                    // Progress Bar Fill
                    Rectangle {
                        id: progressBar
                        color: "#FF8C00"
                        radius: 8
                        height: parent.height
                        width: (missionProgressValue / 100) * parent.width

                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }
        }
    }
}
