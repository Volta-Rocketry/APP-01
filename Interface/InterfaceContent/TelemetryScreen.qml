import QtQuick
import QtQuick.Controls
import QtCharts
import QtLocation
import QtPositioning
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
    property real currentLatitude: 0.0
    property real currentLongitude: 0.0
    property bool hasValidGps: false

    Plugin {
        id: mapPlugin
        name: "osm"
    }
    
    Connections {
        target: typeof serialManager !== "undefined" ? serialManager : null

        function onAltitudeUpdated(altitudeValue) {
            addDataPoint("altitude", altitudeValue)
        }

        function onTelemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon) {
            if (lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
                currentLatitude = lat
                currentLongitude = lon
                hasValidGps = true
                
                // Actualizar propiedades del mapa en el formulario
                mapCenterLat = lat
                mapCenterLon = lon
                mapHasGps = true
                mapZoomLevel = 17.5
                appendMapPoint(lat, lon)
                
                console.log("TelemetryScreen - GPS actualizado: " + lat.toFixed(6) + ", " + lon.toFixed(6))
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
        }
        
        dataPointsCount++
    }

    function appendMapPoint(lat, lon) {
        if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            return
        }

        const nextPoint = QtPositioning.coordinate(lat, lon)

        if (mapPath.length > 0) {
            const lastPoint = mapPath[mapPath.length - 1]
            if (Math.abs(lastPoint.latitude - lat) < 0.000001 && Math.abs(lastPoint.longitude - lon) < 0.000001) {
                return
            }
        }

        mapPath = mapPath.concat([nextPoint])

        if (mapPath.length > 120) {
            mapPath = mapPath.slice(mapPath.length - 120)
        }
    }

    function updateAllCharts() {
        updateAltitudeChart()
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
        
        // Inicializar el mapa con coordenadas por defecto
        mapCenterLat = 4.7110
        mapCenterLon = -74.0055
        mapHasGps = false
        mapZoomLevel = 15.0
        mapPath = []
        
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
