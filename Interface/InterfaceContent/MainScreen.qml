import QtQuick
import QtQuick.Controls
import QtCharts

MainScreenForm {
    id: mainScreenRoot
    signal showControlPanelRequested()

    property real latitude: 0.0
    property real longitude: 0.0
    property real altitude: 0.0
    property real speed: 0.0
    property real acceleration: 0.0
    property real voltage: 0.0
    property real temperature: 0.0
    property real time: 0.0
    property int testSimulationSeconds: 0

    property var timeData: []
    property var altitudeData: []
    property real maxAltitude: 0.0
    property int dataPointsCount: 0
    property real previousAltitudeForPhase: 0.0
    property real previousTimeForPhase: -1.0
    property real verticalRateMs: 0.0
    property real peakAltitude: 0.0
    property real progressHoldValue: 0.0
    property bool missionWasAirborne: false
    property int lastDerivedPhase: -1

    Connections {
        target: typeof serialManager !== "undefined" ? serialManager : null

        function onTelemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon) {
            latitude = lat
            longitude = lon

            latitudeText = lat.toFixed(7) + " N"
            longitudeText = lon.toFixed(7) + " W"

            console.log("MainScreen - Telemetría IMU: Lat=" + lat + ", Lon=" + lon)
        }

        function onAltitudeUpdated(altitudeValue) {
            altitude = altitudeValue

            if (altitudeValue > peakAltitude) {
                peakAltitude = altitudeValue
            }

            if (previousTimeForPhase >= 0 && time >= previousTimeForPhase) {
                const dt = Math.max(0.02, time - previousTimeForPhase)
                const instantRate = (altitudeValue - previousAltitudeForPhase) / dt
                verticalRateMs = (verticalRateMs * 0.7) + (instantRate * 0.3)
            } else {
                const instantRateNoTime = altitudeValue - previousAltitudeForPhase
                verticalRateMs = (verticalRateMs * 0.8) + (instantRateNoTime * 0.2)
            }

            previousAltitudeForPhase = altitudeValue
            previousTimeForPhase = time

            altitudeFtText = (altitudeValue * 3.28084).toFixed(0) + " ft"
            altitudeMText = altitudeValue.toFixed(0) + " m"
            altitudeDialValue = Math.max(0, Math.min(11000, altitudeValue * 3.28084))

            addAltitudeData(time, altitudeValue)
            updateFlightProgress()
            
            console.log("MainScreen - Altitud actualizada: " + altitudeValue + " m")
            console.log("MainScreen - Progreso de misión: " + missionProgressValue.toFixed(1) + "%")
        }

        function onSpeedUpdated(speedValue) {
            speed = speedValue

            speedFtText = (speedValue * 3.28084).toFixed(1) + " ft/s"
            speedMText = speedValue.toFixed(1) + " m/s"
            speedDialValue = Math.max(0, Math.min(500, speedValue))

            console.log("MainScreen - Velocidad actualizada: " + speedValue + " m/s")
        }

        function onAccelerationUpdated(accelValue) {
            acceleration = accelValue

            accelerationFtText = (accelValue * 3.28084).toFixed(1) + " ft/s²"
            accelerationMText = accelValue.toFixed(1) + " m/s²"
            accelerationDialValue = Math.max(0, Math.min(200, accelValue))

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

            // Actualizar de progreso continuamente
            updateFlightProgress()
            
            if (timeValue % 5 < 0.1) {
                console.log("MainScreen - Tiempo: " + timeStr + ", Progreso: " + missionProgressValue.toFixed(1) + "%")
            }

            console.log("MainScreen - Tiempo actualizado: " + timeStr)
        }

        function onFlightPhaseUpdated(phase) {
            flightPhaseValue = phase + 1
            updateFlightProgress()

            console.log("MainScreen - Fase de vuelo actualizada: " + phase)
        }

        function onMicrocontrollerConnectionStatus(status) {
            console.log("Estado de conexión microcontrolador: " + status)
            if (!status) {
                resetMissionTracking()
            }
        }
    }

    function resetMissionTracking() {
        previousAltitudeForPhase = 0.0
        previousTimeForPhase = -1.0
        verticalRateMs = 0.0
        peakAltitude = 0.0
        progressHoldValue = 0.0
        missionWasAirborne = false
        lastDerivedPhase = -1
        flightPhaseValue = 0
        missionProgressValue = 0
        console.log("MainScreen - Tracking de misión reiniciado")
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

    function updateFlightProgress() {
        if (typeof serialManager === "undefined") {
            return
        }

        const rocketStatus = serialManager.getTelemetryStatus()
        let estApogeeAlt = serialManager.getEstApogeeAlt()
        let estMainAlt = serialManager.getEstMainAlt()
        const currentAlt = altitude

        // Si no hay altitudes estimadas configuradas, usar máxima registrada o defaults
        if (estApogeeAlt <= 0) {
            estApogeeAlt = Math.max(3500, maxAltitude * 1.2)
        }
        if (estMainAlt <= 0) {
            estMainAlt = Math.max(500, estApogeeAlt * 0.15)
        }

        const ascendThreshold = 0.35
        const descendThreshold = -0.35
        const groundAltitude = 3.0
        const airborneAltitude = 8.0

        let progressPercent = 0
        let derivedPhase = 0

        console.log("DEBUG Progress - Status: " + rocketStatus + ", CurrentAlt: " + currentAlt.toFixed(1) + 
                    ", EstApogee: " + estApogeeAlt + ", EstMain: " + estMainAlt +
                    ", VRate: " + verticalRateMs.toFixed(2))

        const hasFlown = peakAltitude > airborneAltitude
        const isNearGround = currentAlt <= groundAltitude
        const isAscending = verticalRateMs >= ascendThreshold
        const isDescending = verticalRateMs <= descendThreshold
        const apogeeWindow = Math.max(estApogeeAlt * 0.12, 35)
        const isNearApogee = currentAlt >= Math.max(airborneAltitude, peakAltitude - apogeeWindow)

        if (hasFlown) {
            missionWasAirborne = true
        }

        if (missionWasAirborne && rocketStatus <= 1 && isNearGround && !isAscending && time > 3) {
            resetMissionTracking()
            return
        }

        if (!hasFlown && isNearGround && rocketStatus <= 1) {
            derivedPhase = 0
            progressPercent = Math.min(4, (currentAlt / Math.max(1, airborneAltitude)) * 4)
            progressHoldValue = 0
        } else if (hasFlown && isNearGround && !isAscending) {
            derivedPhase = 3
            progressPercent = 100
        } else if (isAscending) {
            derivedPhase = 0
            progressPercent = (currentAlt / estApogeeAlt) * 35
        } else if (isNearApogee && !isDescending) {
            derivedPhase = 1
            const apogeeStart = Math.max(1, estApogeeAlt * 0.7)
            const apogeeSpan = Math.max(1, estApogeeAlt - apogeeStart)
            progressPercent = 35 + ((currentAlt - apogeeStart) / apogeeSpan) * 20
        } else {
            derivedPhase = 2
            const descentTop = Math.max(estMainAlt + 1, peakAltitude)
            const descentRange = Math.max(1, descentTop - groundAltitude)
            progressPercent = 55 + ((descentTop - currentAlt) / descentRange) * 40
        }

        if (derivedPhase === 0) {
            progressPercent = Math.max(0, Math.min(35, progressPercent))
        } else if (derivedPhase === 1) {
            progressPercent = Math.max(35, Math.min(55, progressPercent))
        } else if (derivedPhase === 2) {
            progressPercent = Math.max(55, Math.min(95, progressPercent))
        } else if (derivedPhase === 3) {
            progressPercent = 100
        }

        if (lastDerivedPhase >= 2 && derivedPhase === 0 && currentAlt <= airborneAltitude * 1.5) {
            progressHoldValue = 0
            missionWasAirborne = false
            peakAltitude = currentAlt
        }

        if (derivedPhase !== 3) {
            progressPercent = Math.max(progressPercent, progressHoldValue)
            progressHoldValue = progressPercent
        } else {
            missionWasAirborne = true
        }

        flightPhaseValue = derivedPhase + 1
        missionProgressValue = Math.max(0, Math.min(100, progressPercent))
        lastDerivedPhase = derivedPhase

        console.log("DEBUG Phase Derived - Phase=" + derivedPhase + ", Progress=" + missionProgressValue.toFixed(1) + "%")
    }

    function toggleTestDataTimer() {
        const willRun = !testDataTimer.running
        testDataTimer.running = willRun
        if (willRun) {
            testSimulationSeconds = 0
        }
        console.log("MainScreen - Timer de prueba " + (testDataTimer.running ? "activado" : "detenido"))
        return testDataTimer.running
    }

    function updateAltitudeChart() {
        try {
            if (loader && loader.item) {
                let chart = loader.item.spline
                let axisX = loader.item.axisX
                let axisY = loader.item.axisY
                if (chart) {
                    console.log("MainScreen - Actualizando gráfico con " + timeData.length + " puntos")
                    
                    while (chart.count > 0) {
                        chart.removeSeries(chart.series(0))
                    }

                    let series = chart.createSeries(ChartView.SeriesTypeSpline, "Altitude (m)", 
                                                     axisX, axisY)
                    
                    for (let i = 0; i < timeData.length; i++) {
                        series.append(timeData[i], altitudeData[i])
                    }

                    let maxTime = timeData.length > 0 ? timeData[timeData.length - 1] : 100
                    axisX.max = Math.max(100, maxTime * 1.1)
                    axisY.max = Math.max(1000, maxAltitude * 1.2)
                    
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
            testSimulationSeconds += 1
            let testAlt = 500 * Math.sin((testSimulationSeconds * Math.PI) / 30) + 500
            time = testSimulationSeconds

            let minutes = Math.floor(testSimulationSeconds / 60)
            let seconds = Math.floor(testSimulationSeconds % 60)
            let milliseconds = 0
            timeText = "T: " + String(minutes).padStart(2, '0') +
                       ":" + String(seconds).padStart(2, '0') +
                       "." + String(milliseconds).padStart(2, '0')
            
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
        console.log("MainScreen - solicitando ControlPanel")
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
