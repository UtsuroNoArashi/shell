import QtQuick
import QtQuick.Controls
import Quickshell 
import Quickshell.Io

Rectangle {
    id: wpctlRoot
    property real volume
    property int asPercentage: volume * 100

    function getIcon() {
        let icons = ["󰝟", "", "", ""] 
        if (wpctlRoot.asPercentage === 0) {
            return icons[0]
        }

        if (asPercentage <= 33) {
            return icons[1]
        }

        if (asPercentage) {
            return icons[2]
        }

        return icons[3]
    }

    Text {
        text: wpctlRoot.asPercentage + "% " + wpctlRoot.getIcon()
        color: activePalette.accent 

        font {
            family: "Lilex Nerd Font"
            bold: true
            pointSize: 12 
        }
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent 
            hoverEnabled: true 
            onDoubleClicked: Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "0%"])
            onClicked: {
                wpctlSliderRoot.visible = !wpctlSliderRoot.visible
                wpctlSliderBg.opacity = wpctlSliderRoot.visible ? 1 : 0;
            }
        }
    }

    PopupWindow {
        id: wpctlSliderRoot

        anchor {
            window: barTrueRoot 
            rect.x: parentWindow.width * 0.7 - implicitWidth / 4
            rect.y: parentWindow.height + 15
        }
        implicitWidth: 200
        implicitHeight: 40

        color: "transparent"

        Rectangle {
            id: wpctlSliderBg

            anchors.fill: parent
            color: activePalette.window
            radius: 20

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            Slider {
                id: control
                from: 0
                to: 1
                stepSize: 0.05
                snapMode: Slider.SnapAlways
                anchors.centerIn: parent
                value: wpctlRoot.volume
                live: true

                background: Rectangle {
                    x: control.leftPadding
                    y: control.topPadding + control.availableHeight / 2 - height / 2
                    implicitWidth: 150
                    implicitHeight: 5
                    width: control.availableWidth
                    height: implicitHeight
                    radius: 5
                    color: activePalette.light

                    Rectangle {
                        width: control.visualPosition * parent.width
                        height: parent.height
                        color: activePalette.accent
                        radius: 5
                    }
                }

                handle: Rectangle {
                    x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                    y: control.topPadding + control.availableHeight / 2 - height / 2
                    implicitWidth: 16
                    implicitHeight: 16
                    radius: 15
                    color: activePalette.text
                }

                onMoved: {
                    console.log(position * to)
                    wpctlRoot.volume = position * to;
                    Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", position * to]);
                }
            }

            HoverHandler {
                onHoveredChanged: {
                    if (!hovered) {
                        wpctlSliderRoot.visible = false;
                        wpctlSliderBg.opacity = 0;
                    }
                }
            }
        }
    }

    Timer {
        running: true
        repeat: true 
        interval: 500 
        onTriggered: {
            volumeListener.running = !volumeListener.running
        }
    }

    Process {
        id: volumeListener
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                let output = this.text
                wpctlRoot.volume = output.trim().split(" ")[1]
            }
        }
    }
}
