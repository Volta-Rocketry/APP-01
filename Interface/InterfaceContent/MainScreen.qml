import QtQuick
import QtQuick.Controls
import QtCharts

MainScreenForm {
    id: mainScreenRoot
    signal showControlPanelRequested()

    //se guardan todos los datos que llegan del micro
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
            latitude = lat
            longitude = lon

            if (latitudeValue) {
                latitudeValue.text = lat.toFixed(7) + " N"
            }
            if (longitudeValue) {
                longitudeValue.text = lon.toFixed(7) + " W"
            }

            console.log("MainScreen - Telemetría IMU: Lat=" + lat + ", Lon=" + lon)
        }

        function onAltitudeUpdated(altitudeValue) {
            altitude = altitudeValue
            
            if (content && content.down) {
                let altRect = content.down.rectangleAltitude
                if (altRect && altRect.altitudeValue1) {
                    altRect.altitudeValue1.text = (altitudeValue * 3.28084).toFixed(0) + " ft"
                    altRect.altitudeValue2.text = altitudeValue.toFixed(0) + " m"
                }
            }

            addAltitudeData(time, altitudeValue)
            
            console.log("Altitud actualizada: " + altitudeValue + " m")
        }

        function onSpeedUpdated(speedValue) {
            speed = speedValue

            if (content && content.down) {
                let speedRect = content.down.rectangleSpeed
                if (speedRect && speedRect.speedValue1) {
                    speedRect.speedValue1.text = (speedValue * 3.28084).toFixed(1) + " ft/s"
                    speedRect.speedValue2.text = speedValue.toFixed(1) + " m/s"
                }
            }

            console.log("Velocidad actualizada: " + speedValue + " m/s")
        }

        function onAccelerationUpdated(accelValue) {
            acceleration = accelValue

            if (content && content.down) {
                let accelRect = content.down.rectangleAcceleration
                if (accelRect && accelRect.accelerationValue1) {
                    accelRect.accelerationValue1.text = (accelValue * 3.28084).toFixed(1) + " ft/s²"
                    accelRect.accelerationValue2.text = accelValue.toFixed(1) + " m/s²"
                }
            }

            console.log("Aceleración actualizada: " + accelValue + " m/s²")
        }

        function onVoltageUpdated(voltageValue) {
            voltage = voltageValue
            
            if (content && content.up && content.up.part1) {
                let voltLabel = content.up.part1.voltageValue
                if (voltLabel) {
                    voltLabel.text = voltageValue.toFixed(2) + " v"
                }
            }

            console.log("Voltaje actualizado: " + voltageValue + " v")
        }

        function onTemperatureUpdated(temperatureValue) {
            temperature = temperatureValue
            
            if (content && content.up && content.up.part1) {
                let tempLabel = content.up.part1.temperatureValue
                if (tempLabel) {
                    tempLabel.text = temperatureValue.toFixed(0) + "° I"
                }
            }

            console.log("Temperatura actualizada: " + temperatureValue + " °")
        }

        function onTimeUpdated(timeValue) {
            time = timeValue

            // para convertir los segundos a minutos, segundos y milisegundos
            let minutes = Math.floor(timeValue / 60)
            let seconds = Math.floor(timeValue % 60)
            let milliseconds = Math.floor((timeValue % 1) * 100)

            let timeStr = "T: " + String(minutes).padStart(2, '0') + 
                        ":" + String(seconds).padStart(2, '0') + 
                        "." + String(milliseconds).padStart(2, '0')
            
            if (content && content.up && content.up.part1) {
                let timeLabel = content.up.part1.timeValue
                if (timeLabel) {
                    timeLabel.text = timeStr
                }
            }

            console.log("Tiempo actualizado: " + timeStr)
        }

        function onFlightPhaseUpdated(phase) {
            // para actualizar la barra de progreso segun la fase del vuelo
            if (content && content.up && content.up.flightPhases) {
                let pb = content.up.flightPhases.progressBar
                if (pb) {
                    pb.value = phase + 1
                }
            }

            console.log("Fase de vuelo actualizada: " + phase)
        }

        function onMicrocontrollerConnectionStatus(status) {
            console.log("Estado de conexión microcontrolador: " + status)
        }
    }

    //para agregar los datos nuevos a los arreglos
    function addAltitudeData(timeVal, altVal) {
        timeData.push(timeVal)
        altitudeData.push(altVal)
        dataPointsCount++

        if (altVal > maxAltitude) {
            maxAltitude = altVal
        }

        //se actualiza la grafica cada 5 datos para no frenar la app
        if (dataPointsCount % 5 === 0) {
            updateAltitudeChart()
        }
    }

    //se actualiza la grafica con los nuevos datos
    function updateAltitudeChart() {
        try {
            if (loader && loader.item) {
                let chart = loader.item.spline
                if (chart) {
                    console.log("Actualizando gráfico con " + timeData.length + " puntos")
                    
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
                    
                    console.log("Gráfico actualizado. Máx Altitud: " + maxAltitude)
                }
            }
        } catch (error) {
            console.error("Error al actualizar gráfico: " + error)
        }
    }

    Timer {
        id: testDataTimer
        interval: 1000
        running: false // Cambiar a true para modo de prueba
        repeat: true

        onTriggered: {
            // Enviar datos de prueba
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
            // Crear un archivo temporal con los datos actuales
            let exportData = "Type,Timestamp,Value\n"
            exportData += "ALTITUDE," + time + "," + altitude + "\n"
            exportData += "SPEED," + time + "," + speed + "\n"
            exportData += "ACCELERATION," + time + "," + acceleration + "\n"
            exportData += "VOLTAGE," + time + "," + voltage + "\n"
            exportData += "TEMPERATURE," + time + "," + temperature + "\n"
            
            console.log("Datos exportados:\n" + exportData)
        }
    }

    //obtener estadísticas de vuelo
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

    //verificar estado de conexión
    function checkConnectionStatus() {
        if (typeof serialManager !== "undefined" && serialManager) {
            return serialManager.getMicroConfirmation()
        }
        return false
    }

    function requestControlPanel() {
        console.log("Ssolicitando ControlPanel")
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
