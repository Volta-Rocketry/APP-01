import QtQuick
import QtQuick.Controls
import QtCharts

MainScreenForm {
    id: mainScreenRoot
    signal showControlPanelRequested()

    // para guardar todos los datos que llegan del micro
    property real latitude: 0.0
    property real longitude: 0.0
    property real altitude: 0.0
    property real speed: 0.0
    property real acceleration: 0.0
    property real voltage: 0.0
    property real temperature: 0.0
    property real time: 0.0

    property var timeData: []
    property var altitudeData: []
    property real maxAltitude: 0.0
    property int dataPointsCount: 0

    Connections {
        target: typeof serialManager !== "undefined" ? serialManager : null

        function onTelemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon) {
            // actualizo lat y lon
            latitude = lat
            longitude = lon

            latitudeText = lat.toFixed(7) + " N"
            longitudeText = lon.toFixed(7) + " W"

            console.log("MainScreen - Telemetría IMU: Lat=" + lat + ", Lon=" + lon)
        }

        function onAltitudeUpdated(altitudeValue) {
            altitude = altitudeValue

            altitudeFtText = (altitudeValue * 3.28084).toFixed(0) + " ft"
            altitudeMText = altitudeValue.toFixed(0) + " m"
            altitudeDialValue = Math.max(0, Math.min(5000, altitudeValue))

            addAltitudeData(time, altitudeValue)
            
            console.log("MainScreen - Altitud actualizada: " + altitudeValue + " m")
        }

        function onSpeedUpdated(speedValue) {
            speed = speedValue

            speedFtText = (speedValue * 3.28084).toFixed(1) + " ft/s"
            speedMText = speedValue.toFixed(1) + " m/s"
            speedDialValue = Math.max(0, Math.min(600, speedValue))

            console.log("MainScreen - Velocidad actualizada: " + speedValue + " m/s")
        }

        function onAccelerationUpdated(accelValue) {
            acceleration = accelValue

            accelerationFtText = (accelValue * 3.28084).toFixed(1) + " ft/s²"
            accelerationMText = accelValue.toFixed(1) + " m/s²"
            accelerationDialValue = Math.max(0, Math.min(30, accelValue))

            console.log("MainScreen - Aceleración actualizada: " + accelValue + " m/s²")
        }

        function onVoltageUpdated(voltageValue) {
            voltage = voltageValue

            voltageText = voltageValue.toFixed(2) + " v"

            console.log("MainScreen - Voltaje actualizado: " + voltageValue + " v")
        }

        function onTemperatureUpdated(temperatureValue) {
            temperature = temperatureValue

            temperatureText = temperatureValue.toFixed(0) + "° f"

            console.log("MainScreen - Temperatura actualizada: " + temperatureValue + " °")
        }

        function onTimeUpdated(timeValue) {
            time = timeValue

            let minutes = Math.floor(timeValue / 60)
            let seconds = Math.floor(timeValue % 60)
            let milliseconds = Math.floor((timeValue % 1) * 100)

            let timeStr = "T: " + String(minutes).padStart(2, '0') + 
                        ":" + String(seconds).padStart(2, '0') + 
                        "." + String(milliseconds).padStart(2, '0')

            timeText = timeStr

            console.log("MainScreen - Tiempo actualizado: " + timeStr)
        }

        // función para actualizar la barra de progreso segun la fase del vuelo
        function onFlightPhaseUpdated(phase) {

            flightPhaseValue = phase + 1

            console.log("MainScreen - Fase de vuelo actualizada: " + phase)
        }

        function onMicrocontrollerConnectionStatus(status) {
            console.log("Estado de conexión microcontrolador: " + status)
        }
    }

    function addAltitudeData(timeVal, altVal) {
        timeData.push(timeVal)
        altitudeData.push(altVal)
        dataPointsCount++

        if (altVal > maxAltitude) {
            maxAltitude = altVal
        }

        if (dataPointsCount % 5 === 0) {
            updateAltitudeChart()
        }
    }

    function updateAltitudeChart() {
        try {
            if (loader && loader.item) {
                let chart = loader.item.spline
                if (chart) {
                    console.log("MainScreen - Actualizando gráfico con " + timeData.length + " puntos")
                    
                    while (chart.count > 0) {
                        chart.removeSeries(chart.series(0))
                    }

                    let series = chart.createSeries(ChartView.SeriesTypeSpline, "Altitude (m)", 
                                                     chart.axisX, chart.axisY)
                    
                    for (let i = 0; i < timeData.length; i++) {
                        series.append(timeData[i], altitudeData[i])
                    }

                    let maxTime = timeData.length > 0 ? timeData[timeData.length - 1] : 100
                    chart.axisX.max = Math.max(100, maxTime * 1.1)
                    chart.axisY.max = Math.max(1000, maxAltitude * 1.2)
                    
                    console.log("MainScreen - Gráfico actualizado. Máx Altitud: " + maxAltitude)
                }
            }
        } catch (error) {
            console.error("Error al actualizar gráfico: " + error)
        }
    }

    // Timer para enviar datos de prueba en modo simulación
    Timer {
        id: testDataTimer
        interval: 1000
        running: false // Cambiar a true para modo de prueba
        repeat: true

        onTriggered: {
            let testTime = testDataTimer.triggeredOnStart ? 0 : (testTime + 1)
            let testAlt = 500 * Math.sin((testTime * Math.PI) / 30) + 500
            
            if (typeof serialManager !== "undefined" && serialManager) {
                // Simulación de eventos
                serialManager.altitudeUpdated(testAlt)
                serialManager.speedUpdated(Math.random() * 50)
                serialManager.temperatureUpdated(20 + Math.random() * 10)
            }
        }
    }

    // Función para exportar datos actuales a CSV
    function exportCurrentData() {
        if (typeof serialManager !== "undefined" && serialManager) {
            console.log("Exportando datos actuales...")

            let exportData = "Type,Timestamp,Value\n"
            exportData += "ALTITUDE," + time + "," + altitude + "\n"
            exportData += "SPEED," + time + "," + speed + "\n"
            exportData += "ACCELERATION," + time + "," + acceleration + "\n"
            exportData += "VOLTAGE," + time + "," + voltage + "\n"
            exportData += "TEMPERATURE," + time + "," + temperature + "\n"
            
            console.log("Datos exportados:\n" + exportData)
        }
    }

    function getFlightStatistics() {
        let stats = {
            maxAltitude: maxAltitude,
            currentAltitude: altitude,
            currentSpeed: speed,
            currentAcceleration: acceleration,
            flightTime: time,
            dataPoints: dataPointsCount
        }
        console.log("Estadísticas de vuelo:", JSON.stringify(stats))
        return stats
    }

    function checkConnectionStatus() {
        if (typeof serialManager !== "undefined" && serialManager) {
            return serialManager.getMicroConfirmation()
        }
        return false
    }

    function requestControlPanel() {
        console.log("MainScreen solicitando ControlPanel")
        showControlPanelRequested()
    }

    MouseArea {
        id: flowerClickArea
        anchors.left: parent.left
        anchors.top: parent.top
        width: 150
        height: parent.height
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        z: 999
        onClicked: requestControlPanel()
    }
}
