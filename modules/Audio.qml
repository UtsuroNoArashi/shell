import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: volumeRoot

    property var rawVolume
    property bool isMuted
    property int volume

    function parse() {
        let parts = rawVolume.trim().split(" ");
        isMuted = parts.length > 2;

        let parsedValume = parts[1].split(".");
        volume = parsedValume[1];
    }

    Rectangle {
        id: volumeBG
        color: "transparent"
        anchors.fill: parent
        radius: 10

        ColumnLayout {
            anchors.centerIn: parent
            Text {
                text: "Volume"
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
                    to: 1
                    stepSize: 0.05
                    snapMode: Slider.SnapAlways
                    value: volumeRoot.volume / 100

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
                            color: colorscheme.rose // qmllint disable unqualified
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
                        volumeGetter.running = false;
                        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", value]);
                    }
                }

                Text {
                    text: volumeRoot.isMuted ? " " : (volumeRoot.volume < 10 ? "0": "" ) + volumeRoot.volume + " %"
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
            onDoubleTapped: Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
        }

        HoverHandler {
            onHoveredChanged: volumeBG.color = hovered ? colorscheme.overlay : "transparent"
        }
    }

    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: volumeGetter.running = true
    }

    Process {
        id: volumeGetter
        running: true
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                volumeRoot.rawVolume = this.text;
                volumeRoot.parse();
            }
        }
    }
}
