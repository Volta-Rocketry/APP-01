import QtQuick
import Interface

Rectangle {
    id: mapPlaceholder
    anchors.fill: parent
    anchors.margins: 10
    anchors.leftMargin: -25
    
    color: "#2a2a2a"
    border.color: "#444444"
    border.width: 2
    radius: 4
    
    Text {
        anchors.centerIn: parent
        text: "MAP VIEW\nInitializing..."
        font.pointSize: 14
        font.bold: true
        color: "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
}
