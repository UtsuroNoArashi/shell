import Quickshell
import QtQuick
import QtQuick.Layouts
import "../modules"

RowLayout {
    anchors.fill: parent
    spacing: 10

    SystemTray {} // min: parent.width * 0.01875; max: parent.width * 0.06125
    
    // // TODO: hyprland workspaces
    // Item {
    //     Layout.preferredWidth: parent.width * 0.3
    // }
    //
    // Clock {
    //     Layout.preferredWidth: parent.width * 0.2
    //     Layout.alignment: Qt.AlignHCenter
    // }
    //
    // Calendar {id: calendar}
    //
    // // Brightness {
    // //     Layout.preferredWidth: parent.width * 0.1
    // // }
    //
    // Item {
    //     Layout.preferredWidth:parent.width * 0.2
    // }
    //
    // Item {
    //     Layout.preferredWidth:parent.width * 0.1
    // }
}
