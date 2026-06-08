import QtQuick
import Quickshell

PanelWindow {
    id: barTrueRoot

    anchors.top: true
    margins.top: 5
    exclusiveZone: ExclusionMode.Ignore

    implicitWidth: Screen.width * 0.85
    implicitHeight: 40

    color: "transparent" // Needed to have rounded borders using Rectangle 

    SystemPalette { id: activePalette; colorGroup: SystemPalette.Active }
    
    Rectangle {
        id: barRoot 

        anchors.fill: parent

        color: activePalette.window
        radius: 15
    }

    WidgetContainer { } 

}
