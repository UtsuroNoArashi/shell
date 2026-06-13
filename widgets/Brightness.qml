import QtQuick
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Io

Rectangle {
    id: brightnessRoot
    property int rawBrightnessOutput
    property int brightness
    property int asPercentage: 100 * brightness / rawBrightnessOutput

    function getIcon() {
        let icons = ["", "", "", "", "", "", "", "", ""];
        let index = parseInt(asPercentage / 10);
        index = index < 9 ? index : 8;
        return icons[index];
    }

    Text {
        text: brightnessRoot.asPercentage + "% " + brightnessRoot.getIcon()
        color: "#f6c177"

        font {
            family: "Lilex Nerd Font"
            bold: true
            pointSize: 12
        }
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onDoubleClicked: Quickshell.execDetached(["brightnessctl", "set", "25%"])
            onClicked: {
                brightnessSliderRoot.visible = !brightnessSliderRoot.visible;
                brightnessSliderBg.opacity = brightnessSliderRoot.visible ? 1 : 0;
            }
        }
    }

    PopupWindow {
        id: brightnessSliderRoot

        anchor {
            window: barTrueRoot
            rect.x: parentWindow.width - implicitWidth
            rect.y: parentWindow.height + 15
        }
        implicitWidth: 200
        implicitHeight: 40

        color: "transparent"

        Rectangle {
            id: brightnessSliderBg

            anchors.fill: parent
            color: activePalette.alternateBase
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
                to: brightnessRoot.rawBrightnessOutput
                stepSize: (to / 100) * 5
                snapMode: Slider.SnapAlways
                anchors.centerIn: parent
                value: brightnessRoot.brightness
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
                    brightnessRoot.brightness = position * to;
                    Quickshell.execDetached(["brightnessctl", "set", position * to]);
                }
            }

            HoverHandler {
                onHoveredChanged: {
                    if (!hovered) {
                        brightnessSliderRoot.visible = false;
                        brightnessSliderBg.opacity = 0;
                    }
                }
            }
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 300
        onTriggered: {
            brightnessGetter.running = !brightnessGetter.running;
        }
    }

    Process {
        running: true
        command: ["brightnessctl", "max"]
        stdout: StdioCollector {
            onStreamFinished: {
                brightnessRoot.rawBrightnessOutput = Number(this.text);
            }
        }
    }

    Process {
        id: brightnessGetter
        command: ["brightnessctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                brightnessRoot.brightness = Number(this.text);
            }
        }
    }
}
