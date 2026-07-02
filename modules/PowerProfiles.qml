import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: pfdRoot

    readonly property var model: [
        {
            profile: "performance",
            color: colorscheme.rose, // qmllint disable unqualified
            iconPath: "../assets/performance.svg"
        },
        {
            profile: "balanced",
            color: colorscheme.pine, // qmllint disable unqualified
            iconPath: "../assets/balanced.svg"
        }
        ,
        {
            profile: "power-saver",
            color: colorscheme.foam, // qmllint disable unqualified
            iconPath: "../assets/power_saver.svg"
        } 
    ]

    property var rawOutput
    property int activeProfile

    function parse() {
        let lines = rawOutput.trim().split("\n")
        let careOff = [lines[0], lines[4], lines[8]]

        for (let i = 0; i < 3; i ++) {
            if (careOff[i].startsWith("*")) {
                activeProfile = i 
                return
            }
        }
    }

    Rectangle {
        id: pfdBG
        anchors.fill: parent
        color: "transparent"

        StackLayout {
            id: layout
            anchors.centerIn: parent
            currentIndex: pfdRoot.activeProfile ?? 2

            Repeater {
                model: pfdRoot.model
                delegate: RoundButton {
                    id: button
                    required property var modelData
                    required property int index 

                    width: 64
                    height: 64
                    radius: 10

                    background: Rectangle {
                        anchors.fill: parent
                        color: button.modelData.color
                        radius: 10
                    }

                    icon {
                        width: 32
                        height: 32 
                        color: colorscheme.text // qmllint disable unqualified
                        source: Qt.resolvedUrl(modelData.iconPath)
                    }

                    TapHandler {
                        onPressedChanged: {
                            if (pressed) {
                                layout.currentIndex = (button.index + 1) % 3
                            }
                        }
                    }
                }
            }


            onCurrentIndexChanged: {
                Quickshell.execDetached(["powerprofilesctl", "set", pfdRoot.model[currentIndex].profile])
            }
        }
    }


    Process {
        running: true 
        command: ["powerprofilesctl", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                pfdRoot.rawOutput = this.text 
                pfdRoot.parse()
            }
        }
    }
}
