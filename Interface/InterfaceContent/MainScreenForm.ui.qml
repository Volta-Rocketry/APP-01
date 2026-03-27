

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
                    text: "0 ft/s²"
                    elide: Text.ElideNone
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 74
                    anchors.rightMargin: 74
                    anchors.topMargin: 89
                    anchors.bottomMargin: 60
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Text {
                    id: accelerationValue2
                    color: Constants.fontSecondary
                    text: "0 m/s²"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 74
                    anchors.rightMargin: 69
                    anchors.topMargin: 133
                    anchors.bottomMargin: 16
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
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
                    font.family: "Calistoga"
                }

                Dial {
                    id: dialAcceleration
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
                    x: 76
                    y: 89
                    color: Constants.fontSecondary
                    text: "0 ft"
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Text {
                    id: altitudeValue2
                    color: Constants.fontSecondary
                    text: "0 m"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 76
                    anchors.rightMargin: 73
                    anchors.topMargin: 126
                    anchors.bottomMargin: 23
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
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
                    font.family: "Calistoga"
                }

                Dial {
                    id: dialAltitude
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
                    text: "0 ft/s"
                    elide: Text.ElideNone
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 67
                    anchors.rightMargin: 61
                    anchors.topMargin: 89
                    anchors.bottomMargin: 60
                    verticalAlignment: Text.AlignTop
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
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
                    font.family: "Calistoga"
                }

                Text {
                    id: speedValue2
                    color: Constants.fontSecondary
                    text: "0 m/s"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 64
                    anchors.rightMargin: 59
                    anchors.topMargin: 133
                    anchors.bottomMargin: 16
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Dial {
                    id: dialSpeed
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
                    text: "0.0000000 N"
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
                    font.family: "Calistoga"
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
                    font.family: "Calistoga"
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
                    text: "0.0000000 W"
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
                    font.family: "Calistoga"
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
                    font.family: "Calistoga"
                }
            }
        }

        Loader {
            id: loader
            y: 191
            width: 1920
            height: 712
            source: "TelemetryScreenForm.ui.qml"
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
                    anchors.leftMargin: 1500
                    anchors.rightMargin: 375
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
                    anchors.leftMargin: 1500
                    anchors.rightMargin: 375
                    anchors.topMargin: 45
                    anchors.bottomMargin: 2
                    source: "images/tempe (1).svg"
                    anchors.verticalCenterOffset: -494
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: nameMission
                    color: Constants.fontPrimary
                    text: "MISSION CATTALEYA"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 100
                    anchors.rightMargin: 1422
                    anchors.topMargin: 17
                    anchors.bottomMargin: 15
                    anchors.verticalCenterOffset: -494
                    clip: false
                    font.weight: Font.Thin
                    font.pointSize: 30
                    font.family: "Calistoga"
                }

                Text {
                    id: timeValue
                    color: Constants.fontPrimary
                    text: "T: 00:00.00"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 889
                    anchors.rightMargin: 773
                    anchors.topMargin: 17
                    anchors.bottomMargin: 13
                    anchors.verticalCenterOffset: -494
                    font.weight: Font.Thin
                    font.pointSize: 35
                    font.family: "Calistoga"
                }

                Text {
                    id: voltageValue
                    color: Constants.fontPrimary
                    text: "0.00 v"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1560
                    anchors.rightMargin: 261
                    anchors.topMargin: 0
                    anchors.bottomMargin: 49
                    anchors.verticalCenterOffset: -494
                    font.weight: Font.ExtraBold
                    font.pointSize: 25
                    font.family: "Calistoga"
                }

                Text {
                    id: temperatureValue
                    color: Constants.fontPrimary
                    text: "0° f"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1560
                    anchors.rightMargin: 302
                    anchors.topMargin: 45
                    anchors.bottomMargin: 4
                    anchors.verticalCenterOffset: -494
                    font.weight: Font.ExtraBold
                    font.pointSize: 25
                    font.family: "Calistoga"
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
                    anchors.leftMargin: 1689
                    anchors.rightMargin: 139
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
                    color: Constants.fontPrimary
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
                    font.family: "Calistoga"
                }

                Text {
                    id: apogee
                    color: Constants.fontPrimary
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
                    font.family: "Calistoga"
                }

                Text {
                    id: mainChute
                    color: Constants.fontPrimary
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
                    font.family: "Calistoga"
                }

                Text {
                    id: touchDown
                    color: Constants.fontPrimary
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
                    font.family: "Calistoga"
                }

                ProgressBar {
                    id: progressBar

                    from: 0
                    to: 4
                    value: 0
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 29
                    anchors.rightMargin: 21
                    anchors.topMargin: 55
                    anchors.bottomMargin: 16
                }
            }
        }
    }
}
