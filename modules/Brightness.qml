import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: brightnessRoot

    property real maxBrightness
    property real rawBrightness
    readonly property real brightness: rawBrightness * 100 / maxBrightness

    Rectangle {
        id: brightnessBG
        color: "transparent"
        anchors.fill: parent
        radius: 10

        ColumnLayout {
            anchors.centerIn: parent
            Text {
                text: "Brightness"
                color: colorscheme.text // qmllint disable unqualified
                font {
                    family: "Lilex Nerd Font"
                    pointSize: 10
                    bold: true
                }
            }

            RowLayout {
                spacing: 10

                Slider {
                    id: slider
                    from: 0
                    to: 100
                    stepSize: 5
                    snapMode: Slider.SnapAlways
                    value: brightnessRoot.brightness

                    background: Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 150
                        implicitHeight: 8
                        width: slider.availableWidth
                        height: implicitHeight
                        color: colorscheme.muted // qmllint disable unqualified
                        radius: 5

                        Rectangle {
                            width: slider.visualPosition * parent.width
                            height: parent.height
                            color: colorscheme.gold // qmllint disable unqualified
                            radius: 5
                        }
                    }

                    handle: Rectangle {
                        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 24
                        implicitHeight: 16
                        radius: 10
                        color: colorscheme.text // qmllint disable unqualified
                    }

                    onMoved: {
                        brightnessGetter.running = false;
                        Quickshell.execDetached(["brightnessctl", "set", (value * brightnessRoot.maxBrightness / 100)]);
                    }
                }

                Text {
                    text: brightnessRoot.brightness + " %"
                    color: colorscheme.text // qmllint disable unqualified
                    font {
                        family: "Lilex Nerd Font"
                        pointSize: 12
                        bold: true
                    }
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }


        TapHandler {
            onDoubleTapped: Quickshell.execDetached(["brightnessctl", "-s", "set", "25%"])
        }

        HoverHandler {
            onHoveredChanged: brightnessBG.color = hovered ? colorscheme.overlay : "transparent"
        }
    }

    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: brightnessGetter.running = true
    }

    Process {
        running: true
        command: ["brightnessctl", "max"]
        stdout: StdioCollector {
            onStreamFinished: brightnessRoot.maxBrightness = Number(this.text)
        }
    }

    Process {
        id: brightnessGetter
        running: true
        command: ["brightnessctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: brightnessRoot.rawBrightness = Number(this.text)
        }
    }
}
