import QtQuick
import QtQuick.Window

Window {
    id: mainWindowScreen
    width: 960
    height: 600
    visible: true
    title: "Cattleya Ground Station - Interface"

    FocusScope {
        anchors.fill: parent
        focus: true
        Component.onCompleted: forceActiveFocus()

        Loader {
            id: mainLoader
            anchors.fill: parent
            source: "MainScreen.qml"

            onLoaded: {
                if (!item) {
                    console.log("App.qml - mainLoader loaded null item")
                    return;
                }

                console.log("App.qml - mainLoader loaded item", item)

                // me conecto al signal para cambiar a control panel
                if (item.showControlPanelRequested) {
                    item.showControlPanelRequested.connect(function() {
                        console.log("App.qml - showControlPanelRequested received")
                        mainLoader.source = "ControlPanel.qml"
                    })
                }

                if (item.showTelemetryRequested) {
                    item.showTelemetryRequested.connect(function() {
                        console.log("App.qml - showTelemetryRequested received")
                        mainLoader.source = "MainScreen.qml"
                    })
                }
            }
        }

        Keys.onPressed: (event) => {
            let hasManager = (typeof serialManager !== "undefined");

            switch (event.key) {
                // enter para empezar a grabar, delete para parar
                case Qt.Key_Enter:
                case Qt.Key_Return:
                    if (hasManager) serialManager.createFile();
                    break;

                case Qt.Key_Delete:
                    console.log("Cerrando archivo...");
                    if (hasManager) serialManager.closeFile();
                    break;

                // Q, W, E, R para cambiar fases de vuelo manualmente si me equivoco
                case Qt.Key_Q:
                    console.log("Boost manual detectado");
                    if (hasManager) {
                        serialManager.manualBoostDetected();
                        serialManager.closeFile();
                    }
                    break;

                case Qt.Key_W:
                case Qt.Key_M:
                    console.log("Apogeo manual detectado");
                    if (hasManager) serialManager.manualApogeeDetected();
                    break;

                case Qt.Key_E:
                    console.log("Main manual detectado");
                    if (hasManager) serialManager.manualMainDetected();
                    break;

                case Qt.Key_R:
                    console.log("Landing manual detectado");
                    if (hasManager) serialManager.manualLandingDetected();
                    break;

                case Qt.Key_T:
                    console.log("Reset de tiempo de referencia");
                    if (hasManager) serialManager.setReferenceTime();
                    break;

                // Z, X, F, O, S, L para mandar comandos al cohete
                case Qt.Key_Z:
                    if (hasManager) serialManager.sendData('z');
                    break;

                case Qt.Key_X:
                    if (hasManager) serialManager.sendData('x');
                    break;

                case Qt.Key_S:
                    console.log("Confirmación de estación terrena");
                    if (hasManager) serialManager.sendData('s');
                    break;

                case Qt.Key_L:
                    console.log("Cambiando frecuencia...");
                    if (hasManager) serialManager.sendFrequencyChange();
                    break;

                //CONTROL DE INTERFAZ Y VISTAS
                case Qt.Key_C:

                    if (mainLoader.source.toString().includes("TelemetryScreen.qml")) {
                        mainLoader.source = "CameraScreen.qml";
                    } else {
                        mainLoader.source = "TelemetryScreen.qml";
                    }
                    break;

                case Qt.Key_P:

                    mainWindowScreen.visibility = (mainWindowScreen.visibility === Window.FullScreen)
                        ? Window.Maximized
                        : Window.FullScreen;
                    break;

                case Qt.Key_F1:
                    if (mainLoader.item.sectionTimeLine)
                        mainLoader.item.sectionTimeLine.visible = !mainLoader.item.sectionTimeLine.visible;
                    break;

                case Qt.Key_F2:
                    if (mainLoader.item.sectionMainData)
                        mainLoader.item.sectionMainData.visible = !mainLoader.item.sectionMainData.visible;
                    break;

                case Qt.Key_F3:
                    if (mainLoader.item.sectionTimer)
                        mainLoader.item.sectionTimer.visible = !mainLoader.item.sectionTimer.visible;
                    break;

                case Qt.Key_F4:
                    if (mainLoader.item.sectionStatusInfo)
                        mainLoader.item.sectionStatusInfo.visible = !mainLoader.item.sectionStatusInfo.visible;
                    break;

                case Qt.Key_F5:
                    if (mainLoader.item.rectangle6)
                        mainLoader.item.rectangle6.visible = !mainLoader.item.rectangle6.visible;
                    break;

                case Qt.Key_F6:
                    // Cambio de color del Log
                    if (mainLoader.item && mainLoader.item.txtLog) {
                        let currentColor = mainLoader.item.txtLog.color.toString();
                        mainLoader.item.txtLog.color = (currentColor === "#ffffff") ? "#000000" : "#ffffff";
                    }
                    break;
            }
        }
    }
}
