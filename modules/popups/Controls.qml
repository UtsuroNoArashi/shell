import Quickshell
import QtQuick 
import QtQuick.Layouts
import "../../modules/" as Modules

PopupWindow {
    id: controllsRoot
    signal toggle 

    function hide() {
        controllsBG.opacity = 0
        delay.restart()
    }

    function show() {
        visible = true 
        controllsBG.opacity = 1
        visibilityDelay.restart()
    }

    anchor {
        window: barRoot         // qmllint disable unqualified
        rect.x: parentWindow.width - implicitWidth - 10 // qmllint disable
        rect.y: parentWindow.height + 15 // qmllint disable
    }

    color: "transparent"
    implicitWidth: 350
    implicitHeight: 300

    onToggle: visible ? hide() : show()

    Rectangle {
        id: controllsBG
        anchors.fill: parent 
        color: colorscheme.surface  // qmllint disable unqualified
        radius: 15
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.InOutQuad 
                duration: 700
            }
        }

        GridLayout {
            rows: 4 
            columns: 4 
            rowSpacing: 15
            columnSpacing: 15
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.9

            Modules.Brightness {
                Layout.columnSpan: 3
                Layout.preferredWidth: parent.width * 0.75 * 0.9
                Layout.preferredHeight: parent.height * 0.25 * 0.8
            }

            Modules.PowerMenu {
                Layout.rowSpan: 4
                Layout.preferredWidth: parent.width * 0.25 * 0.9
                Layout.preferredHeight: parent.height 
            }

            Modules.Audio {
                Layout.columnSpan: 3
                Layout.preferredWidth: parent.width * 0.75 * 0.9
                Layout.preferredHeight: parent.height * 0.25 * 0.8
            }


            // Modules.Network {
            //     Layout.columnSpan: 2
            // }
            //
            // Modules.Bluetooth {
            //     Layout.columnSpan: 2
            // }

            Modules.PowerProfiles {
                Layout.preferredWidth: parent.width * 0.25 * 0.8
                Layout.preferredHeight: parent.height * 0.25 * 0.8
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (!hovered) {
                visibilityDelay.restart()
            }
        }
    }

    Timer {
        id: visibilityDelay
        interval: 1500
        onTriggered: {
            if (!hoverHandler.hovered) {
                controllsRoot.hide()
            }
        }
    }


    Timer {
        id: delay
        interval: 700
        onTriggered: controllsRoot.visible = false
    }
} 
