
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: controlPanelForm
    width: 960
    height: 600
    color: "#e7e7e7"

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

    Text {
        id: text1
        x: 337
        y: 16
        text: qsTr("CATTLEYA GROUND STATION")
        font.pixelSize: 25
        font.bold: true
        font.family: "Calistoga"
    }

    Text {
        id: text2
        x: 435
        y: 55
        text: qsTr("SETTINGS")
        font.pixelSize: 25
        font.bold: true
        font.family: "Calistoga"
    }

    Rectangle {
        id: rectangle
        x: 18
        y: 102
        width: 290
        height: 410
        color: "#e7e7e7"
        radius: 30
        border.width: 3

        Text {
            id: text3
            x: 91
            y: 49
            text: qsTr("BAUD RATE")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        ComboBox {
            id: cbBaudRate
            y: 94
            height: 40
            anchors.left: parent.left
            anchors.right: parent.right
            model: ListModel {
                id: cbBaudRateModel
                ListElement {
                    key: "115200"
                }
                ListElement {
                    key: "9600"
                }
                ListElement {
                    key: "1200"
                }
                ListElement {
                    key: "2400"
                }
                ListElement {
                    key: "4800"
                }
                ListElement {
                    key: "19200"
                }
                ListElement {
                    key: "38400"
                }
                ListElement {
                    key: "57600"
                }
            }
        }

        Text {
            id: txtTittlePort
            x: 83
            y: 158
            text: qsTr("SERIAL PORT")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        ComboBox {
            id: cbSerialPort
            y: 205
            height: 40
            anchors.horizontalCenter: txtTittlePort.horizontalCenter
            model: ListModel {
                id: cbSerialPortModel
                ListElement {
                    key: "Test Mode"
                }
            }
        }
    }

    Rectangle {
        id: rectangle2
        x: 337
        y: 102
        width: 290
        height: 410
        color: "#e7e7e7"
        radius: 30
        border.width: 3

        Text {
            id: txtRouteSelected
            x: 84
            y: 42
            text: qsTr("SELECT ROUTE")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        Button {
            id: btnSelectRoute
            y: 100
            height: 32
            text: qsTr("Select Route")
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Text {
            id: text9
            x: 94
            y: 165
            text: qsTr("FILE NAME")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        TextField {
            id: edtFileName
            x: 8
            y: 204
            width: 274
            height: 39
            text: "Mission_Cattleya"
        }

        Switch {
            id: swtSaveStart
            x: 144
            y: 298
            text: "AutoStart"
            checked: true
        }

        Switch {
            id: swtSaveFinish
            x: 144
            y: 344
            text: "AutoStop"
            checked: true
        }

        Rectangle {
            id: rectangle1
            x: 318
            y: 0
            width: 290
            height: 410
            color: "#e7e7e7"
            radius: 30
            border.width: 3

            Text {
                id: txtTittleEstimatedApogee
                x: 48
                y: 40
                text: qsTr("ESTIMATED APOGEE")
                font.pixelSize: 20
                font.family: "Calistoga"
            }

            TextEdit {
                id: edtEstimatedApogee
                x: 96
                y: 97
                text: qsTr("10000 ft")
                font.pixelSize: 20
                font.family: "Calistoga"
            }

            Text {
                id: txtTittleEstimatedMainDeploy
                x: 22
                y: 164
                text: qsTr("ESTIMATED MAIN DEPLOY")
                font.pixelSize: 20
                font.family: "Calistoga"
            }

            TextEdit {
                id: edtEstimatedMain
                x: 102
                y: 224
                text: qsTr("10000 ft")
                font.pixelSize: 20
                font.family: "Calistoga"
            }

            Text {
                id: txtTittleFrecuency
                x: 48
                y: 288
                text: qsTr("ROCKET FREQUENCY")
                font.pixelSize: 20
                font.family: "Calistoga"
            }

            TextEdit {
                id: edtTittleFrecuency
                x: 117
                y: 342
                text: qsTr("0 Hz")
                font.pixelSize: 20
                font.family: "Calistoga"
            }
        }

        Button {
            id: btnSearch
            x: -229
            y: 284
            width: 100
            height: 40
            text: "Search"
        }

        Button {
            id: btnConnect
            x: 84
            y: 447
            width: 100
            height: 40
            text: "Connect"
        }

        Image {
            id: file
            anchors.centerIn: parent
            width: 841
            height: 583
            opacity: 0.1
            source: "images/file.svg"
            fillMode: Image.PreserveAspectFit
        }
    }
}
