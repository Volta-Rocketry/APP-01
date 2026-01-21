import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import APP 1.0

Rectangle {
    id: display
    width: 1920
    height: 1080
    color: "#f5f5f5"

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
            id: rectangle
            x: 0
            width: 1920
            height: 92
            color: "#4f1e53"

            Image {
                id: voltaje
                x: 1500
                y: 0
                height: 45
                source: "images/voltaje.svg"
                fillMode: Image.PreserveAspectFit
            }
        }
        Rectangle {
            id: rectangle1
            x: 0
            y: 191
            width: 1920
            height: 889
            color: "#f5f5f5"

            ChartView {
                id: spline
                x: 459
                y: 40
                width: 950
                height: 641
                title: "ALTITUDE VS TIME"

                localizeNumbers: false
                dropShadowEnabled: true
                backgroundRoundness: 6.7
                titleColor: "#000000"
                backgroundColor: "#e7e7e7"
                antialiasing: true

                Image {
                    id: colombia
                    x: 1318
                    y: -231
                    width: 148
                    height: 92
                    source: "images/colombia.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
        Rectangle {
            id: rectangle2
            x: 0
            y: 100
            width: 1920
            height: 91
            color: "#4f1e53"
        }

        Rectangle {
            id: rectangle3
            x: 0
            y: 901
            width: 1920
            height: 177
            opacity: 0.6
            color: "#e7e7e7"
        }

        Rectangle {
            id: rectangle4
            x: 1460
            y: 222
            width: 460
            height: 324
            color: "#888888"
        }

        Rectangle {
            id: rectangle5
            x: 1460
            y: 546
            width: 460
            height: 324
            color: "#000000"
        }

        Rectangle {
            id: rectangle6
            x: 29
            y: 222
            width: 387
            height: 648
            color: "#000000"

            Image {
                id: imageToStl
                x: 21
                y: 697
                width: 116
                height: 144
                source: "images/ImageToStl.com_equator.svg"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: imageToStl1
                x: 1471
                y: 710
                width: 122
                height: 119
                source: "images/ImageToStl.com_equator.svg"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: coordenada
                x: -8
                y: 702
                width: 160
                height: 134
                source: "images/coordenada.svg"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: coordenada1
                x: 1452
                y: 702
                width: 160
                height: 134
                source: "images/coordenada.svg"
                fillMode: Image.PreserveAspectFit
            }
        }
        Dial {
            id: dial4
            x: 871
            y: 936
        }

        Text {
            id: text11
            x: 596
            y: 895
            color: "#64327a"
            text: "SPEED"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text15
            x: 605
            y: 977
            color: "#64327a"
            text: "0 ft/s"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text14
            x: 602
            y: 1021
            color: "#64327a"
            text: "0 m/s"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Dial {
            id: dial5
            x: 561
            y: 936
        }

        Text {
            id: text9
            x: 205
            y: 962
            color: "#64327a"
            text: "LATITUDE"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text20
            x: 181
            y: 997
            color: "#64327a"
            text: "0.0000000 N"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text10
            x: 1654
            y: 962
            color: "#64327a"
            text: "LONGITUDE"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text21
            x: 1637
            y: 997
            color: "#64327a"
            text: "0.0000000 W"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text18
            x: 1211
            y: 977
            color: "#64327a"
            text: "0 ft/s²"
            elide: Text.ElideNone
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text19
            x: 1211
            y: 1021
            color: "#64327a"
            text: "0 m/s²"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text13
            x: 1140
            y: 895
            color: "#64327a"
            text: "ACCELERATION"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Dial {
            id: dial6
            x: 1166
            y: 936
        }

        Image {
            id: caca2
            x: 0
            y: 0
            width: 94
            height: 91
            source: "images/caca (2).svg"
            anchors.verticalCenterOffset: -494
            fillMode: Image.PreserveAspectFit

            Image {
                id: flor
                x: 0
                y: 0
                width: 100
                height: 92
                source: "images/flor.svg"
                fillMode: Image.PreserveAspectFit
            }
        }
        Text {
            id: text1
            x: 100
            y: 17
            height: 60
            color: "#ffffff"
            text: "MISSION CATTALEYA"
            anchors.verticalCenterOffset: -494
            clip: false
            font.weight: Font.Thin
            font.pointSize: 30
            font.family: "Calistoga"
        }

        Text {
            id: text2
            x: 889
            y: 17
            color: "#ffffff"
            text: "T: 00:00.00"
            anchors.verticalCenterOffset: -494
            font.weight: Font.Thin
            font.pointSize: 35
            font.family: "Calistoga"
        }

        Image {
            id: whatsAppImage20260115At16
            x: 1783
            height: 91
            source: "images/WhatsApp Image 2026-01-15 at 16.54.34.svg"
            anchors.verticalCenterOffset: -494
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: ba
            x: 1500
            height: 45
            source: "images/ba.svg"
            anchors.verticalCenterOffset: -494
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: tempe1
            x: 1500
            y: 45
            height: 45
            source: "images/tempe (1).svg"
            anchors.verticalCenterOffset: -494
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text3
            x: 1560
            color: "#ffffff"
            text: "0.00 v"
            anchors.verticalCenterOffset: -494
            font.weight: Font.ExtraBold
            font.pointSize: 25
            font.family: "Calistoga"

            Image {
                id: logoU
                x: 129
                y: 0
                height: 92
                source: "images/logoU.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text {
            id: text4
            x: 1560
            y: 45
            color: "#ffffff"
            text: "0° f"
            anchors.verticalCenterOffset: -494
            font.weight: Font.ExtraBold
            font.pointSize: 25
            font.family: "Calistoga"
        }

        Image {
            id: svg
            x: 1690
            height: 91
            source: "images/svg.svg"
            anchors.verticalCenterOffset: -494
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text5
            x: 100
            y: 111
            color: "#ffffff"
            text: "ASCENT"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text6
            x: 600
            y: 111
            color: "#ffffff"
            text: "APOGEE"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text7
            x: 1100
            y: 111
            color: "#ffffff"
            text: "MAIN CHUTE"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text8
            x: 1625
            y: 111
            color: "#ffffff"
            text: "TOUCH DOWN"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text16
            x: 925
            y: 977
            color: "#64327a"
            text: "0 ft"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text17
            x: 925
            y: 1014
            color: "#64327a"
            text: "0 m"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text12
            x: 879
            y: 895
            color: "#64327a"
            text: "ALTITUDE"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        ProgressBar {
            id: progressBar
            x: 29
            y: 155
            width: 1870
            height: 20

            from: 0
            to: 4
            value: 0
        }
    }
}
