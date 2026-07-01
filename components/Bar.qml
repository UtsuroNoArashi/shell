import Quickshell 
import QtQuick

PanelWindow { // qmllint disable
    id: barRoot

    readonly property font h1: ({
        family: "Lilex Nerd Font",
        pointSize: 12,
        bold: true
    })

    implicitWidth: Screen.width
    implicitHeight: 30

    anchors.top: true
    color: colorscheme.base // qmllint disable unqualified

    WidgetsDrawer { }
}
