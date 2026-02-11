import QtQuick
import QtQuick.Controls
import APP 1.0

Rectangle {
    id: display
    width: 1920
    height: 1080
    color: Constants.backgroundMain

    readonly property int baseW: 1920
    readonly property int baseH: 1080

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
            id: up
            x: 0
            y: 0
            width: 1920
            height: 193
            color: Constants.fontPrimary

            Rectangle {
                id: part1
                width: Constants.designWidth
                height: 91
                color: Constants.missionPrimary
                border.color: Constants.black
                border.width: part1.border.width
                rotation: part1.rotation
                anchors.verticalCenterOffset: -51
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent

                Image {
                    id: voltage
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1509
                    anchors.rightMargin: 366
                    anchors.topMargin: 0
                    anchors.bottomMargin: 46
                    source: "images/voltaje.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: flower
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 1828
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    source: "images/flor.svg"
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
                    anchors.rightMargin: 1409
                    anchors.topMargin: 20
                    anchors.bottomMargin: 19
                    clip: false
                    font.weight: Font.ExtraBold
                    font.pointSize: 30
                    font.family: "Calistoga"
                }

                Text {
                    id: timeMission
                    color: Constants.fontPrimary
                    text: "T: 00:00.00"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 954
                    anchors.rightMargin: 738
                    anchors.topMargin: 20
                    anchors.bottomMargin: 19
                    style: Text.Normal
                    font.weight: Font.Bold
                    font.pointSize: 30
                    font.family: "Calistoga"
                }

                Image {
                    id: temperature
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1500
                    anchors.rightMargin: 360
                    anchors.topMargin: 45
                    anchors.bottomMargin: 1
                    source: "images/tempe (1).svg"
                    fillMode: Image.PreserveAspectFit
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
                    anchors.bottomMargin: 48
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
                    anchors.bottomMargin: 3
                    font.weight: Font.ExtraBold
                    font.pointSize: 25
                    font.family: "Calistoga"
                }

                Image {
                    id: logoU
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1692
                    anchors.rightMargin: 137
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    source: "images/logoU.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Image {
                    id: colombia
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1783
                    anchors.rightMargin: -1
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    source: "images/colombia.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                id: flightPhases
                width: Constants.designWidth
                height: 91
                color: Constants.missionPrimary
                border.color: Constants.black
                border.width: flightPhases.border.width
                anchors.verticalCenterOffset: 51
                anchors.centerIn: parent

                Text {
                    id: ascent
                    color: Constants.fontPrimary
                    text: "ASCENT"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 100
                    anchors.rightMargin: 1709
                    anchors.topMargin: 10
                    anchors.bottomMargin: 43
                    rotation: ascent.rotation
                    font.weight: Font.Medium
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
                    anchors.rightMargin: 1208
                    anchors.topMargin: 10
                    anchors.bottomMargin: 43
                    rotation: apogee.rotation
                    font.weight: Font.Medium
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
                    anchors.rightMargin: 643
                    anchors.topMargin: 10
                    anchors.bottomMargin: 43
                    rotation: mainChute.rotation
                    font.weight: Font.Medium
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
                    anchors.rightMargin: 106
                    anchors.topMargin: 10
                    anchors.bottomMargin: 43
                    rotation: touchDown.rotation
                    font.weight: Font.Medium
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
                    anchors.topMargin: 54
                    anchors.bottomMargin: 17
                }
            }

            Rectangle {
                id: bar
                x: 0
                y: 91
                width: 1920
                height: 10
                color: Constants.fontPrimary
            }
        }



        Loader {
            id: loader
            x: 0
            y: 191
            width: 1920
            height: 889





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

        Rectangle {
            id: data2
            x: 0
            y: 890
            width: Constants.designWidth
            height: 191
            opacity: 0.6
            color: Constants.backgroundOverlay
            border.color: Constants.black
            border.width: data2.border.width
            anchors.verticalCenter: loader.verticalCenter
            rotation: data2.anchors.baselineOffset
            anchors.verticalCenterOffset: 350

            Rectangle {
                id: rectangleAltitude
                opacity: 1
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 840
                anchors.rightMargin: 880
                anchors.topMargin: 3
                anchors.bottomMargin: 1

                Text {
                    id: altitude
                    color: Constants.fontSecondary
                    text: "ALTITUDE"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 31
                    anchors.rightMargin: 32
                    anchors.topMargin: -2
                    anchors.bottomMargin: 151
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Text {
                    id: altitudeValue1
                    color: Constants.fontSecondary
                    text: "0 ft"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 76
                    anchors.rightMargin: 78
                    anchors.topMargin: 79
                    anchors.bottomMargin: 70
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
                    anchors.leftMargin: 74
                    anchors.rightMargin: 75
                    anchors.topMargin: 123
                    anchors.bottomMargin: 26
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
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    anchors.topMargin: 44
                    anchors.bottomMargin: -17
                }
            }

            Rectangle {
                id: rectangleAcceleration
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 1130
                anchors.rightMargin: 560
                anchors.topMargin: 3
                anchors.bottomMargin: 1

                Text {
                    id: accelerationValue1
                    color: Constants.fontSecondary
                    text: "0 ft/s²"
                    elide: Text.ElideNone
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 77
                    anchors.rightMargin: 71
                    anchors.topMargin: 83
                    anchors.bottomMargin: 66
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
                    anchors.leftMargin: 77
                    anchors.rightMargin: 66
                    anchors.topMargin: 122
                    anchors.bottomMargin: 27
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
                    anchors.leftMargin: 13
                    anchors.rightMargin: 7
                    anchors.topMargin: -2
                    anchors.bottomMargin: 151
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Dial {
                    id: dialacceleration
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 38
                    anchors.rightMargin: 32
                    anchors.topMargin: 44
                    anchors.bottomMargin: -17
                }
            }

            Rectangle {
                id: rectangleSpeed
                opacity: 1
                visible: true
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 540
                anchors.rightMargin: 1180
                anchors.topMargin: 3
                anchors.bottomMargin: 1

                Dial {
                    id: dialSpeed
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 21
                    anchors.rightMargin: 19
                    anchors.topMargin: 44
                    anchors.bottomMargin: -17
                }

                Text {
                    id: speedValue2
                    color: Constants.fontSecondary
                    text: "0 m/s"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 60
                    anchors.rightMargin: 63
                    anchors.topMargin: 122
                    anchors.bottomMargin: 27
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Text {
                    id: speedValue1
                    color: Constants.fontSecondary
                    text: "0 ft/s"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 60
                    anchors.rightMargin: 68
                    anchors.topMargin: 83
                    anchors.bottomMargin: 66
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
                    anchors.leftMargin: 50
                    anchors.rightMargin: 61
                    anchors.topMargin: -2
                    anchors.bottomMargin: 151
                    font.weight: Font.Thin
                    font.pointSize: 22
                    font.family: "Calistoga"
                }
            }

            Rectangle {
                id: rectangleLatitude
                color: Constants.transparentData
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 25
                anchors.rightMargin: 1535
                anchors.topMargin: 30
                anchors.bottomMargin: 9

                Text {
                    id: latitudeValue
                    color: Constants.fontSecondary
                    text: "0.0000000 N"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 156
                    anchors.rightMargin: 14
                    anchors.topMargin: 78
                    anchors.bottomMargin: 36
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
                    anchors.leftMargin: 180
                    anchors.rightMargin: 37
                    anchors.topMargin: 34
                    anchors.bottomMargin: 80
                    verticalAlignment: Text.AlignTop
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Image {
                    id: latitudeImage
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 1
                    anchors.rightMargin: 199
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
                anchors.leftMargin: 1480
                anchors.rightMargin: 80
                anchors.topMargin: 30
                anchors.bottomMargin: 9

                Text {
                    id: longitudeValue
                    color: Constants.fontSecondary
                    text: "0.0000000 N"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 162
                    anchors.rightMargin: 8
                    anchors.topMargin: 78
                    anchors.bottomMargin: 36
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
                    anchors.leftMargin: 174
                    anchors.rightMargin: 20
                    anchors.topMargin: 34
                    anchors.bottomMargin: 80
                    font.weight: Font.Bold
                    font.pointSize: 22
                    font.family: "Calistoga"
                }

                Image {
                    id: longitudeImage
                    opacity: 1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: -10
                    anchors.rightMargin: 210
                    anchors.topMargin: 11
                    anchors.bottomMargin: 7
                    verticalAlignment: Image.AlignVCenter
                    source: "images/coordenada.svg"
                    clip: true
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
}
