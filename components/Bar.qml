import Quickshell
import QtQuick

// qmllint disable uncreatable-type
PanelWindow {
    id: barRoot
    // qmllint enable uncreatable-type

    signal toggle

    implicitWidth: Screen.width * 0.85
    implicitHeight: 40

    anchors.top: true
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    onToggle: {
        if (exclusionMode === ExclusionMode.Ignore) {
            exclusionMode = ExclusionMode.Auto;
            return;
        }
        exclusionMode = ExclusionMode.Ignore;
    }

    Rectangle {
        anchors.fill: parent
        color: colorPalette.window

        ModuleContainer {}
        radius: 15
    }
}
