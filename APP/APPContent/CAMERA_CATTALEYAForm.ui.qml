import QtQuick
import QtQuick.Controls
import APP 1.0

Rectangle {
    id: display
    width: 1920
    height: 1080
    color: Constants.backgroundColor

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
            y: 0
            width: 1920
            height: 91
            color: "#4f1e53"

            Rectangle {
                id: rectangle1
                x: 0
                y: 91
                width: 1920
                height: 10
                color: "#ffffff"
            }

            Image {
                id: voltaje
                x: 1509
                y: 0
                height: 45
                source: "images/voltaje.svg"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: flor
                x: 0
                y: 0
                height: 91
                source: "images/flor.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            id: rectangle2
            x: 0
            y: 101
            width: 1920
            height: 91
            color: "#4f1e53"
        }

        Image {
            id: caca2
            x: 0
            height: 91
            anchors.top: parent.top
            anchors.topMargin: 0
            source: "images/caca (2).svg"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text1
            x: 100
            y: 20
            color: "#ffffff"
            text: "MISSION CATTALEYA"
            clip: false
            font.weight: Font.ExtraBold
            font.pointSize: 30
            font.family: "Calistoga"
        }

        Text {
            id: text2
            x: 954
            y: 20
            color: "#ffffff"
            text: "T: 00:00.00"
            style: Text.Normal
            font.weight: Font.Bold
            font.pointSize: 30
            font.family: "Calistoga"
        }

        Image {
            id: whatsAppImage20260115At16
            x: 1783
            width: 137
            height: 91
            anchors.top: parent.top
            anchors.topMargin: 0
            source: "images/WhatsApp Image 2026-01-15 at 16.54.34.svg"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: tempe1
            x: 1500
            y: 45
            width: 60
            height: 45
            source: "images/tempe (1).svg"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text3
            x: 1560
            color: "#ffffff"
            text: "0.00 v"
            font.weight: Font.ExtraBold
            font.pointSize: 25
            font.family: "Calistoga"
        }

        Text {
            id: text4
            x: 1560
            y: 45
            color: "#ffffff"
            text: "0° f"
            font.weight: Font.ExtraBold
            font.pointSize: 25
            font.family: "Calistoga"
        }

        Text {
            id: text5
            x: 100
            y: 111
            color: "#ffffff"
            text: "ASCENT"
            font.weight: Font.Medium
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text6
            x: 600
            y: 111
            color: "#ffffff"
            text: "APOGEE"
            font.weight: Font.Medium
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text7
            x: 1100
            y: 111
            color: "#ffffff"
            text: "MAIN CHUTE"
            font.weight: Font.Medium
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text8
            x: 1625
            y: 111
            color: "#ffffff"
            text: "TOUCH DOWN"
            font.weight: Font.Medium
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

        Rectangle {
            id: rectangle4
            x: 0
            y: 191
            width: 1920
            height: 889
            color: "#000000"

            Image {
                id: colombia
                x: 1783
                y: -191
                width: 138
                height: 91
                source: "images/colombia.svg"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: logoU
                x: 1692
                y: -191
                height: 91
                source: "images/logoU.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            id: rectangle5
            x: 1560
            y: 191
            width: 360
            height: 199
            color: "#888888"
        }

        Rectangle {
            id: rectangle3
            x: 0
            y: 889
            width: 1920
            height: 189
            opacity: 0.6
            color: "#e4d9ff"
        }
        Image {
            id: coordenada
            x: 26
            y: 930
            width: 160
            height: 134
            source: "images/coordenada.svg"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: coordenada1
            x: 1470
            y: 930
            width: 160
            height: 134
            source: "images/coordenada.svg"
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: text9
            x: 205
            y: 953
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

        Image {
            id: imageToStl1
            height: 165
            source: "images/ImageToStl.com_equator.svg"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text10
            x: 1654
            y: 953
            color: "#64327a"
            text: "LONGITUDE"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text21
            x: 1642
            y: 997
            color: "#64327a"
            text: "0.0000000 N"
            font.weight: Font.Bold
            font.pointSize: 22
            font.family: "Calistoga"
        }
        Dial {
            id: dial4
            x: 860
            y: 936
        }

        Text {
            id: text11
            x: 590
            y: 890
            color: "#64327a"
            text: "SPEED"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text15
            x: 600
            y: 975
            color: "#64327a"
            text: "0 ft/s"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text14
            x: 600
            y: 1014
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
            id: text18
            x: 1207
            y: 975
            color: "#64327a"
            text: "0 ft/s²"
            elide: Text.ElideNone
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text19
            x: 1207
            y: 1014
            color: "#64327a"
            text: "0 m/s²"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text13
            x: 1143
            y: 890
            color: "#64327a"
            text: "ACCELERATION"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Dial {
            id: dial6
            x: 1168
            y: 936
        }
        Text {
            id: text16
            x: 916
            y: 971
            color: "#64327a"
            text: "0 ft"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }

        Text {
            id: text17
            x: 914
            y: 1015
            color: "#64327a"
            text: "0 m"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }
        Text {
            id: text12
            x: 871
            y: 890
            color: "#64327a"
            text: "ALTITUDE"
            font.weight: Font.Thin
            font.pointSize: 22
            font.family: "Calistoga"
        }
    }
}
