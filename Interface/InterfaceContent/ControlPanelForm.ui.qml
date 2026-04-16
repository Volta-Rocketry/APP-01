
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
import QtQuick.Effects

Rectangle {
    id: controlPanelForm
    color: Constants.backgroundMain
    
    readonly property int baseW: 1920
    readonly property int baseH: 1200
    
    width: Constants.designWidth
    height: Constants.designHeight

    signal showTelemetryRequested()

    property alias btnSearch: btnSearch
    property alias cbBaudRate: cbBaudRate
    property alias cbSerialPort: cbSerialPort
    property alias btnConnect: btnConnect
    property alias cbSerialPortModel: cbSerialPortModel
    property alias btnSelectRoute: btnSelectRoute
    property alias txtRouteSelected: txtRouteSelected
    property alias edtFileName: edtFileName
    property alias swtSaveFinish: swtSaveFinish
    property alias swtSaveStart: swtSaveStart
    property alias edtEstimatedApogee: edtEstimatedApogee
    property alias edtEstimatedMain: edtEstimatedMain
    property alias edtTittleFrecuency: edtTittleFrecuency
    property alias backToTelemetryArea: backToTelemetryArea

    Item {
        id: content
        width: baseW
        height: baseH
        anchors.fill: parent

        transform: Scale {
            origin.x: 0
            origin.y: 0
            xScale: controlPanelForm.width / baseW
            yScale: controlPanelForm.height / baseH
        }

        Text {
            id: text1
            x: 674
            y: 32
            text: qsTr("CATTLEYA GROUND STATION")
            font.pixelSize: 50
            font.bold: true
            font.family: "Calistoga"
        }

        Text {
            id: text2
            x: 870
            y: 110
            text: qsTr("SETTINGS")
            font.pixelSize: 50
            font.bold: true
            font.family: "Calistoga"
        }

        Rectangle {
            id: rectangle
            x: 36
            y: 204
            width: 580
            height: 820
            color: Constants.backgroundPanel
            radius: 60
            border.width: 6

            Text {
                id: text3
                x: 182
                y: 98
                text: qsTr("BAUD RATE")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            ComboBox {
                id: cbBaudRate
                y: 188
                height: 80
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 30
                anchors.rightMargin: 30
                model: ListModel {
                    id: cbBaudRateModel
                    ListElement { key: "115200" }
                    ListElement { key: "9600" }
                    ListElement { key: "1200" }
                    ListElement { key: "2400" }
                    ListElement { key: "4800" }
                    ListElement { key: "19200" }
                    ListElement { key: "38400" }
                    ListElement { key: "57600" }
                }
            }

            Text {
                id: txtTittlePort
                x: 166
                y: 316
                text: qsTr("SERIAL PORT")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            ComboBox {
                id: cbSerialPort
                y: 410
                height: 80
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 30
                anchors.rightMargin: 30
                model: ListModel {
                    id: cbSerialPortModel
                    ListElement { key: "Test Mode" }
                }
            }

            Button {
                id: btnSearch
                x: 36
                y: 550
                width: 200
                height: 80
                text: "Search"
            }

            Button {
                id: btnConnect
                x: 280
                y: 550
                width: 200
                height: 80
                text: "Connect"
            }
        }

        Rectangle {
            id: rectangle2
            x: 674
            y: 204
            width: 580
            height: 820
            color: Constants.backgroundPanel
            radius: 60
            border.width: 6

            Text {
                id: txtRouteSelected
                x: 168
                y: 84
                text: qsTr("SELECT ROUTE")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            Button {
                id: btnSelectRoute
                y: 200
                height: 64
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 30
                anchors.rightMargin: 30
                text: qsTr("Select Route")
            }

            Text {
                id: text9
                x: 188
                y: 330
                text: qsTr("FILE NAME")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            TextField {
                id: edtFileName
                x: 16
                y: 408
                width: 548
                height: 78
                text: "Mission_Cattleya"
            }

            Switch {
                id: swtSaveStart
                x: 288
                y: 596
                text: "AutoStart"
                checked: true
            }

            Switch {
                id: swtSaveFinish
                x: 288
                y: 688
                text: "AutoStop"
                checked: true
            }
        }

        Rectangle {
            id: rectangle1
            x: 1312
            y: 204
            width: 580
            height: 820
            color: Constants.backgroundPanel
            radius: 60
            border.width: 6

            Text {
                id: txtTittleEstimatedApogee
                x: 96
                y: 80
                text: qsTr("ESTIMATED APOGEE")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            TextEdit {
                id: edtEstimatedApogee
                x: 192
                y: 194
                text: qsTr("10000 ft")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            Text {
                id: txtTittleEstimatedMainDeploy
                x: 44
                y: 328
                text: qsTr("ESTIMATED MAIN DEPLOY")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            TextEdit {
                id: edtEstimatedMain
                x: 204
                y: 448
                text: qsTr("10000 ft")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            Text {
                id: txtTittleFrecuency
                x: 96
                y: 576
                text: qsTr("ROCKET FREQUENCY")
                font.pixelSize: 40
                font.family: "Calistoga"
            }

            TextEdit {
                id: edtTittleFrecuency
                x: 234
                y: 684
                text: qsTr("0 Hz")
                font.pixelSize: 40
                font.family: "Calistoga"
            }
        }

        Image {
            id: file
            anchors.fill: parent
            anchors.margins: 20
            opacity: 0.1
            source: "images/file.svg"
            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            id: backToTelemetryArea
            anchors.left: parent.left
            anchors.top: parent.top
            width: 240
            height: 240
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            z: 999
        }
    }
}
