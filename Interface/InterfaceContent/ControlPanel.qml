import QtQuick
import Qt.labs.platform

ControlPanelForm {
    function parsePositiveInt(textValue) {
        let cleaned = String(textValue).replace(/[^0-9]/g, "")
        if (cleaned === "") {
            return 0
        }
        let value = parseInt(cleaned, 10)
        return isNaN(value) ? 0 : value
    }

    function syncConnectionUiState() {
        if (typeof serialManager === "undefined" || !serialManager) {
            btnConnect.text = "Connect"
            return
        }

        btnConnect.text = serialManager.getMicroConfirmation() ? "Stop Connection" : "Connect"
    }

    function restoreControlValues() {
        if (typeof serialManager === "undefined" || !serialManager) {
            return
        }

        const savedRoute = serialManager.getFilePath()
        if (savedRoute && savedRoute !== "") {
            txtRouteSelected.text = savedRoute
        }

        const savedFileName = serialManager.getFileName()
        if (savedFileName && savedFileName !== "") {
            edtFileName.text = savedFileName
        }

        const savedFreq = serialManager.getFrequency()
        if (savedFreq && savedFreq !== "") {
            edtTittleFrecuency.text = savedFreq
        }

        const savedApogee = serialManager.getEstApogeeAlt()
        if (savedApogee > 0) {
            edtEstimatedApogee.text = savedApogee + " ft"
        }

        const savedMain = serialManager.getEstMainAlt()
        if (savedMain > 0) {
            edtEstimatedMain.text = savedMain + " ft"
        }
    }

    function refreshSerialPortModel() {
        if (typeof serialManager === "undefined" || !serialManager) {
            return
        }

        const savedPort = serialManager.getSelectedPortDescription()
        const ports = serialManager.searchPortInfo()

        cbSerialPortModel.clear()

        let hasSavedPort = false
        if (ports && ports.length > 0) {
            for (let i = 0; i < ports.length; i++) {
                cbSerialPortModel.append({ "key": ports[i] })
                if (ports[i] === savedPort) {
                    hasSavedPort = true
                }
            }
        }

        if (!hasSavedPort && savedPort && savedPort !== "") {
            cbSerialPortModel.append({ "key": savedPort })
            hasSavedPort = true
        }

        if (cbSerialPortModel.count === 0) {
            cbSerialPortModel.append({ "key": "Test Mode" })
            cbSerialPort.currentIndex = 0
            serialManager.savePortConnection("Test Mode")
            return
        }

        if (hasSavedPort) {
            for (let j = 0; j < cbSerialPortModel.count; j++) {
                if (cbSerialPortModel.get(j).key === savedPort) {
                    cbSerialPort.currentIndex = j
                    break
                }
            }
        } else {
            cbSerialPort.currentIndex = 0
            serialManager.savePortConnection(cbSerialPort.currentText)
        }
    }

    function initializeSaveSettings() {
        if (typeof serialManager === "undefined" || !serialManager) {
            return
        }

        serialManager.writeIntValue(1, swtSaveStart.checked ? 1 : 0)
        serialManager.writeIntValue(2, swtSaveFinish.checked ? 1 : 0)
        serialManager.writeStringValue(2, edtFileName.text)
        serialManager.setEstApogeeAlt(parsePositiveInt(edtEstimatedApogee.text))
        serialManager.setEstMainAlt(parsePositiveInt(edtEstimatedMain.text))
        serialManager.changeRocketFrequency(edtTittleFrecuency.text)

        let selectedRoute = txtRouteSelected.text
        if (selectedRoute === "SELECT ROUTE") {
            const defaultRoute = StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
            if (defaultRoute) {
                selectedRoute = defaultRoute.toString()
                txtRouteSelected.text = selectedRoute
            }
        }

        if (selectedRoute !== "" && selectedRoute !== "SELECT ROUTE") {
            serialManager.writeStringValue(1, selectedRoute)
        }
    }

    Component.onCompleted: {
        restoreControlValues()
        refreshSerialPortModel()
        syncConnectionUiState()
        initializeSaveSettings()
    }

    onVisibleChanged: {
        if (visible) {
            restoreControlValues()
            refreshSerialPortModel()
            syncConnectionUiState()
        }
    }

    Connections {
        target: backToTelemetryArea
        function onClicked() {
            console.log("ControlPanel - volvi a telemetria")
            showTelemetryRequested()
        }
    }

    Connections {
        target: serialManager
        function onMicrocontrollerConnectionStatus(status) {
            btnConnect.text = status ? "Stop Connection" : "Connect"
        }
        function onTelemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon) {
            console.log("Telemetria recibida en panel:",
                        "Ax=" + Ax.toFixed(2),
                        "Ay=" + Ay.toFixed(2),
                        "Az=" + Az.toFixed(2),
                        "Lat=" + lat.toFixed(6),
                        "Lon=" + lon.toFixed(6))
        }
    }

    btnSearch.onClicked: {
        refreshSerialPortModel()
        console.log("Puertos refrescados. Selección actual: " + cbSerialPort.currentText)
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

    edtEstimatedApogee.onTextChanged: {
        serialManager.setEstApogeeAlt(parsePositiveInt(edtEstimatedApogee.text))
    }

    edtEstimatedMain.onTextChanged: {
        serialManager.setEstMainAlt(parsePositiveInt(edtEstimatedMain.text))
    }

    edtTittleFrecuency.onTextChanged: {
        serialManager.changeRocketFrequency(edtTittleFrecuency.text)
    }
}
