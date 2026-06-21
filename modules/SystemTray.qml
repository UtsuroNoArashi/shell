import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: trayRoot

    property real minimalWidth: parent.width * 0.01875
    property real maximalWidth: parent.width * 0.06125

    Layout.preferredWidth: minimalWidth
    Layout.preferredHeight: parent.height
    

    Rectangle {
        width: parent.width
        height: parent.height * 0.7
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 10
        }
        radius: 12
        color: colorPalette.base

        Behavior on width {
            NumberAnimation {
                duration: 600
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    Row {
        id: tray

        property bool expanded
        function handleChildren() {
            for (let childId = 0; childId < children.length; childId++) {
                children[childId].opacity = (childId === 0) ? 1 : (expanded ? 1 : 0)
            }
        }

        width: parent.width
        height: parent.height * 0.5

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 18
        }

        spacing: 12

        onExpandedChanged: { tray.handleChildren() }

        Repeater {
            model: [
                {
                    icon: "",
                    action: ["hyprctl", "eval", "require('hyprland.utils').handle_shutdown()"]
                },
                {
                    icon: "↺",
                    action: ["reboot"]
                },
                {
                    icon: "󰍁",
                    action: ["hyprlock"]
                },
                {
                    icon: "󰈆",
                    action: ["hyprshutdown"]
                }
            ]
            delegate: Text {
                required property string icon
                required property list<string> action

                text: icon
                color: icon === "" ? "#eb6f92" : colorPalette.text
                opacity: icon === "" ? 1 : 0

                font {
                    family: "Lilex Nerd Font"
                    pointSize: 12
                    bold: true
                }

                horizontalAlignment: Text.AlignBottom

                Behavior on opacity {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.InSine
                    }
                }

                TapHandler {
                    onPressedChanged: {
                        if (pressed) {
                            Quickshell.execDetached(action)
                        }
                    }
                }
            }
        }
    }

    HoverHandler {
        onHoveredChanged: {
            tray.expanded = hovered
            trayRoot.width = hovered ? trayRoot.maximalWidth : trayRoot.minimalWidth
        }
    }
}
