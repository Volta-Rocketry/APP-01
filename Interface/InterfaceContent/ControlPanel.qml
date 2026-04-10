import QtQuick
import Qt.labs.platform

ControlPanelForm {

    Connections {
        target: serialManager
        function onMicrocontrollerConnectionStatus(status) {
            btnConnect.text = status ? "End Connection" : "Start Connection"
        }
        function onTelemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon) {

            txtAx.text = Ax.toFixed(2)
            txtAy.text = Ay.toFixed(2)
            txtAz.text = Az.toFixed(2)

            txtGx.text = Gx.toFixed(2)
            txtGy.text = Gy.toFixed(2)
            txtGz.text = Gz.toFixed(2)

            txtLat.text = lat.toFixed(6)
            txtLon.text = lon.toFixed(6)

            console.log("Telemetría actualizada")
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

            // Selecciona automáticamente el primero
            cbSerialPort.currentIndex = 0

            console.log("Puertos cargados correctamente")
        } else {
            cbSerialPortModel.append({ "key": "No ports found" })
            cbSerialPort.currentIndex = 0

            console.log("Error, C++ no detectó ningún hardware conectado.")
        }
    }

    cbSerialPort.onActivated: {
        let selectedPort = cbSerialPort.currentText

        console.log("Puerto seleccionado: " + selectedPort)

        if (selectedPort !== "No ports found" && selectedPort !== "") {
            serialManager.savePortConnection(selectedPort)
            console.log("Puerto enviado a C++ correctamente")
        } else {
            console.log("Selección inválida de puerto")
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
