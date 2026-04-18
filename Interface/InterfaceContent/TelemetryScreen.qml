import QtQuick
import QtQuick.Controls
import QtCharts
import Interface

TelemetryScreenForm {
    property var timeData: []
    property var altitudeData: []
    property var speedData: []
    property var accelerationData: []
    property var voltageData: []
    property var temperatureData: []
    
    property real maxAltitude: 0.0
    property real maxSpeed: 0.0
    property real maxAcceleration: 0.0
    property int dataPointsCount: 0
    
    Connections {
        target: typeof serialManager !== "undefined" ? serialManager : null

        function onAltitudeUpdated(altitudeValue) {
            addDataPoint("altitude", altitudeValue)
        }

        function onSpeedUpdated(speedValue) {
            addDataPoint("speed", speedValue)
        }

        function onAccelerationUpdated(accelValue) {
            addDataPoint("acceleration", accelValue)
        }

        function onVoltageUpdated(voltageValue) {
            addDataPoint("voltage", voltageValue)
        }

        function onTemperatureUpdated(temperatureValue) {
            addDataPoint("temperature", temperatureValue)
        }

        function onTimeUpdated(timeValue) {
            // se actualizan las graficas cada 10 datos para no frenar
            if (dataPointsCount % 10 === 0) {
                updateAllCharts()
            }
        }
    }

    function addDataPoint(dataType, value) {
        let currentTime = timeData.length > 0 ? timeData[timeData.length - 1] + 1 : 0
        
        switch(dataType) {
            case "altitude":
                timeData.push(currentTime)
                altitudeData.push(value)
                if (value > maxAltitude) maxAltitude = value
                break
            case "speed":
                speedData.push(value)
                if (value > maxSpeed) maxSpeed = value
                break
            case "acceleration":
                accelerationData.push(value)
                if (value > maxAcceleration) maxAcceleration = value
                break
            case "voltage":
                voltageData.push(value)
                break
            case "temperature":
                temperatureData.push(value)
                break
        }
        
        dataPointsCount++
    }
    // para actualizar todas las graficas
    function updateAllCharts() {
        updateAltitudeChart()
        updateSpeedChart()
        updateAccelerationChart()
        updateVoltageChart()
        updateTemperatureChart()
    }

    //grafica de altitud
    function updateAltitudeChart() {
        try {
            if (spline) {

                while (spline.count > 0) {
                    spline.removeSeries(spline.series(0))
                }

                let altitudeSeries = spline.createSeries(ChartView.SeriesTypeSpline, "Altitude (m)", 
                                                       axisX, axisY)
                
                for (let i = 0; i < timeData.length; i++) {
                    altitudeSeries.append(timeData[i], altitudeData[i])
                }

                // Actualizar rangos de ejes
                let maxTime = timeData.length > 0 ? timeData[timeData.length - 1] : 100
                axisX.max = Math.max(100, maxTime * 1.1)
                axisY.max = Math.max(1000, maxAltitude * 1.2)
                
                console.log("TelemetryScreen - Gráfico de altitud actualizado. Máx Altitud: " + maxAltitude)
            }
        } catch (error) {
            console.error("Error al actualizar gráfico de altitud: " + error)
        }
    }

    // Funciones para otros gráficos
    function updateSpeedChart() {
        //gráfico de velocidad
        console.log("Actualizando gráfico de velocidad - " + speedData.length + " puntos")
    }

    function updateAccelerationChart() {
        //gráfico de aceleración
        console.log("Actualizando gráfico de aceleración - " + accelerationData.length + " puntos")
    }

    function updateVoltageChart() {
        //gráfico de voltaje
        console.log("Actualizando gráfico de voltaje - " + voltageData.length + " puntos")
    }

    function updateTemperatureChart() {
        //gráfico de temperatura
        console.log("Actualizando gráfico de temperatura - " + temperatureData.length + " puntos")
    }

    function exportDataToCSV() {
        if (typeof serialManager !== "undefined" && serialManager) {
            console.log("Exportando datos a CSV...")
        }
    }

    function clearData() {
        timeData = []
        altitudeData = []
        speedData = []
        accelerationData = []
        voltageData = []
        temperatureData = []
        maxAltitude = 0.0
        maxSpeed = 0.0
        maxAcceleration = 0.0
        dataPointsCount = 0
        
        updateAllCharts()
        console.log("Datos limpiados")
    }

    Component.onCompleted: {
        console.log("TelemetryScreen cargado correctamente")
        if (typeof serialManager !== "undefined" && serialManager) {
            console.log("serialManager disponible en TelemetryScreen")
        } else {
            console.warn("serialManager NO disponible en TelemetryScreen")
        }
    }

    Component.onDestruction: {
        console.log("TelemetryScreen destruido")
    }
}
