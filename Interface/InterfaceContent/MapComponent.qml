import QtQuick
import QtLocation
import QtPositioning
import Interface

Map {
    id: telemetryMap
    
    property real currentLatitude: 0.0
    property real currentLongitude: 0.0
    property bool hasValidGps: false
    
    anchors.fill: parent
    
    zoomLevel: 16
    center: QtPositioning.coordinate(currentLatitude, currentLongitude)
    
    activeMapType: supportedMapTypes.length > 0 ? supportedMapTypes[0] : null
    
    // Actualizar centro del mapa
    function updateCenter(lat, lon) {
        if (lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
            currentLatitude = lat
            currentLongitude = lon
            center = QtPositioning.coordinate(lat, lon)
            hasValidGps = true
        }
    }
    
    // Marcador visible de la posición del cohete
    MapQuickItem {
        id: rocketMarker
        visible: hasValidGps
        coordinate: QtPositioning.coordinate(telemetryMap.currentLatitude, telemetryMap.currentLongitude)
        anchorPoint.x: 10
        anchorPoint.y: 10
        zoomLevel: telemetryMap.zoomLevel
        
        sourceItem: Rectangle {
            width: 20
            height: 20
            radius: 10
            color: "#FF5722"
            border.width: 2
            border.color: "#FFFFFF"
            
            Rectangle {
                width: 12
                height: 12
                radius: 6
                color: "#FFF"
                anchors.centerIn: parent
            }
        }
    }
    
    Component.onCompleted: {
        console.log("MapComponent inicializado correctamente")
        console.log("Map types disponibles: " + supportedMapTypes.length)
        for (var i = 0; i < supportedMapTypes.length; i++) {
            console.log("  - " + supportedMapTypes[i].name + " (style: " + supportedMapTypes[i].style + ")")
        }
    }
}

