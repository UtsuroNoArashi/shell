pragma ComponentBehavior: Bound
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Row {
    id: ws

    required property int index
    readonly property var hlWS: Hyprland.workspaces.values.find(w => w.id === (index + 1))
    readonly property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
    readonly property bool isEmpty: (wsWindows.children.length - 1) <= 0

    function toWsIcon() {
        let icons = ["", "󰖟", "", "", "󰊖", "", "⚞"];
        return icons[index <= 5 ? index : 6];
    }

    visible: (index + 1) <= 6 || isActive       // Always show ws 1-6; show ws 7-10 if active
    spacing: 5

    Text {
        text: ws.toWsIcon()
        color: ws.isActive ? colorscheme.iris : Qt.darker(colorscheme.iris, 1.75) // qmllint disable unqualified
        font.pointSize: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        width: layouts.toggle ? wsWindowsCount.implicitWidth + 15 : Math.min(60, wsWindows.implicitWidth + 20)
        height: 15
        color: colorscheme.overlay // qmllint disable unqualified
        anchors.verticalCenter: parent.verticalCenter
        radius: 15
        visible: ws.isActive && !ws.isEmpty

        StackLayout {
            id: layouts

            readonly property bool toggle: (wsWindows.children.length - 1) > 4
            currentIndex: 0
            onToggleChanged: currentIndex = toggle ? 1 : 0
            anchors.centerIn: parent

            Row {
                id: wsWindows
                spacing: 5

                Repeater {
                    model: ws.hlWS ? ws.hlWS.toplevels : []
                    delegate: Text {
                        required property var modelData

                        text: modelData.activated ? "●" : "◯"
                        color: modelData.activated ? colorscheme.text : colorscheme.subtle // qmllint disable unqualified
                        font {
                            family: "Lilex Nerd Font"
                            pointSize: 10
                            bold: true
                        }
                    }
                }
            }

            Item {
                Text {
                    id: wsWindowsCount
                    text: (wsWindows.children.length - 1) + "+"
                    color: colorscheme.text // qmllint disable unqualified
                    font {
                        family: "Lilex Nerd Font"
                        pointSize: 10
                        bold: true
                    }
                    anchors.centerIn: parent
                }
            }
        }
    }

    TapHandler {
        onPressedChanged: pressed ? Hyprland.dispatch("hl.dsp.focus({ workspace = " + (ws.index + 1) + " })") : null
    }
}
