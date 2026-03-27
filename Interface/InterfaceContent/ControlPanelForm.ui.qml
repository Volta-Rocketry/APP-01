

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

    width: 960
    height: 600
    opacity: 1
    color: "#e7e7e7"

    // --- ALIAS ORIGINALES ---
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

    Text {
        id: text1
        x: 337
        y: 16
        text: qsTr("CATTLEYA GROUND STATION ")
        font.pixelSize: 25
        verticalAlignment: Text.AlignTop
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
            x: -18
            y: 94
            height: 40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: txtTittleBaudRate.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 0

            currentIndex: 0
            model: cbBaudRateModel

            ListModel {
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
            id: text4
            x: 83
            y: 158
            text: qsTr("SERIAL PORT")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        ComboBox {
            id: cbSerialPort
            x: -608
            y: 205
            height: 40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: txtTittlePort.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 0

            currentIndex: 0
            model: cbSerialPortModel


            /*onActivated:{
                   serialConfig.savePortConnection(cbSerialPort.currentText)
               }*/
            ListModel {
                id: cbSerialPortModel
                ListElement {
                    key: "Test Mode"
                }
            }
        }

        Button {
            id: btnSearch
            x: 91
            y: 290
            width: 100
            height: 40
            text: "Search"
            anchors.right: parent.right
            anchors.rightMargin: 99
            autoRepeat: false
            flat: false


            /*onClicked:{

                   cbSerialPortModel.clear();

                   cbSerialPortModel.append({key: "Test Mode"});

                   let ports = serialConfig.searchPortInfo();

                   for (let i = 0; i < ports.length; i++) {
                       cbSerialPortModel.append({ key: ports[i] });
                   }
               }*/
        }
    }

    Rectangle {
        id: rectangle1
        x: 650
        y: 101
        width: 290
        height: 410
        color: "#e7e7e7"
        radius: 30
        border.width: 3

        Text {
            id: text5
            x: 48
            y: 40
            text: qsTr("ESTIMATED APOGEE")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        Text {
            id: text6
            x: 22
            y: 164
            text: qsTr("ESTIMATED MAIN DEPLOY")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        Text {
            id: text7
            x: 48
            y: 288
            text: qsTr("ROCKET FREQUENCY")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        Text {
            id: text10
            x: 105
            y: 100
            text: qsTr("10000 ft")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        Text {
            id: text11
            x: 105
            y: 225
            text: qsTr("10000 ft")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        Text {
            id: text12
            x: 125
            y: 347
            text: qsTr("0 Hz")
            font.pixelSize: 20
            font.family: "Calistoga"
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
            id: text8
            x: 75
            y: 43
            text: qsTr("SELECT ROUTE")
            font.pixelSize: 20
            font.family: "Calistoga"
        }

        Button {
            id: btnSelectRoute
            x: 50
            y: 100
            width: 200
            height: 32
            text: qsTr("Select Route")
            anchors.top: txtTittleSelectRoute.bottom
            anchors.topMargin: 0
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
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
        }

        Switch {
            id: swtSaveStart
            x: 163
            y: 297
            text: "AutoStart"
            checked: true
        }

        Switch {
            id: swtSaveFinish
            x: 163
            y: 344
            text: "AutoStop"
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.fillWidth: true
            checked: true
        }

        ColumnLayout {
            x: 65
            y: 204
            anchors.margins: 15
            spacing: 15
        }
    }

    Rectangle {
        id: rectangle3
        x: 413
        y: 552
        width: 165
        height: 40
        color: "#e7e7e7"

        Text {
            id: text13
            x: 26
            y: 8
            text: qsTr("CONNECTED")
            font.pixelSize: 20
        }
    }

    Image {
        id: file
        x: 195
        y: 0
        width: 601
        height: 600
        opacity: 0.3
        source: "images/file.svg"
        fillMode: Image.PreserveAspectFit
    }
}
