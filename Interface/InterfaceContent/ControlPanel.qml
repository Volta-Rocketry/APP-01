import QtQuick
import Qt.labs.platform

ControlPanelForm {

    Connections {
        target: serialManager
        function onMicrocontrollerConnectionStatus(status) {
            btnConnect.text = status ? "End Connection" : "Start Connection"
        }
    }

    btnSearch.onClicked: {
        cbSerialPortModel.clear()

        let ports = serialManager.searchPortInfo()

        console.log("Puertos detectados por el sistema: " + JSON.stringify(ports))

        if (ports && ports.length > 0) {
            for (var i = 0; i < ports.length; i++) {
                cbSerialPortModel.append({ "key": ports[i] })
            }
        } else {
            cbSerialPortModel.append({ "key": "No ports found" })
            console.log("Error: C++ no detectó ningún hardware conectado.")
        }
    }

    cbSerialPort.onActivated: {
        if (cbSerialPort.currentText !== "No ports found") {
            serialManager.savePortConnection(cbSerialPort.currentText)
        }
    }

    cbBaudRate.onActivated: serialManager.setBaudRateMode(cbBaudRate.currentIndex)

    btnConnect.onClicked: {
        let confirmation = serialManager.getMicroConfirmation()
        if (confirmation) {
            serialManager.endConnection()
        } else {
            serialManager.microcontrollerConnection()
        }
    }

    btnSelectRoute.onClicked: folderDialog.open()

    FolderDialog {
        id: folderDialog
        folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

        onAccepted: {
            serialManager.writeStringValue(1, folderDialog.folder.toString())
            txtRouteSelected.text = folderDialog.folder.toString()
        }

        onRejected: {
            console.log("Selección de carpeta cancelada")
        }
    }

    swtSaveFinish.onCheckedChanged: {
        serialManager.writeIntValue(2, swtSaveFinish.checked ? 1 : 0)
    }

    swtSaveStart.onCheckedChanged: {
        serialManager.writeIntValue(1, swtSaveStart.checked ? 1 : 0)
    }

    edtFileName.onTextChanged: {
        serialManager.writeStringValue(2, edtFileName.text)
    }

    edtTittleFrecuency.onTextChanged: {
        serialManager.changeRocketFrequency(edtTittleFrecuency.text)
    }
}
