pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

Item {
    id: powerMenuRoot

    readonly property var model: [
        // qmlformat off
        { action: "shutdown", iconPath: "../assets/shutdown.svg" },
        { action: "reboot", iconPath: "../assets/reboot.svg" },
        { action: "hyprlock", iconPath: "../assets/lock.svg" },
        { action: "hyprshutdown", iconPath: "../assets/logout.svg" }
    ]
    // qmlformat on

    Rectangle {
        id: powerMenuBG
        color: "transparent"
        anchors.fill: parent
        radius: 20

        ColumnLayout {
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 20

            Repeater {
                model: powerMenuRoot.model
                delegate: RoundButton {
                    id: button
                    required property int index
                    required property var modelData

                    width: 64
                    height: 64
                    radius: 18

                    background: Rectangle {
                        id: buttonBG
                        anchors.fill: parent
                        color: "transparent"
                        radius: 18
                    }

                    icon {
                        width: 32
                        height: 32
                        color: index > 0 ? colorscheme.subtle : colorscheme.love // qmllint disable unqualified
                        source: Qt.resolvedUrl(modelData.iconPath)
                    }
                    // Layout.alignment: Qt.AlignHCenter

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: buttonBG.color = containsMouse ? colorscheme.overlay : "transparent" // qmllint disable unqualified
                        onPressedChanged: {
                            if (pressed) {
                                Quickshell.execDetached(button.modelData.action);
                            }
                        }
                    }
                }
            }
        }
    }
}
