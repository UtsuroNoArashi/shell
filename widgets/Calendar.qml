import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PopupWindow {
    id: calendarTrueRoot
    readonly property int today: new Date().getDate()
    property string rawCalOutput: ""
    property int year: 0
    property var months: null
    readonly property var weakdays: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    property var days: []

    property bool showCalendar: false
    property bool useAlternativeFormat: false

    function show() {
        calendarTrueRoot.visible = true;
        calendarRoot.opacity = 1;
    }

    function hide() {
        calendarTrueRoot.visible = false;
        calendarRoot.opacity = 0;
    }

    function parse_cal() {
        if (!calendarTrueRoot.useAlternativeFormat) {
            const lines = calendarTrueRoot.rawCalOutput.trim().split("\n");
            if (lines <= 2) {
                return;
            }

            const monthYear = lines[0].trim().split(/\s+/);
            calendarTrueRoot.months = monthYear[0]
            calendarTrueRoot.year = monthYear[1]

            let days = [];
            for (let i = 2; i < lines.length; i++) {
                let week = lines[i];

                for (let j = 0; j < 7; j++) {
                    let day = week.slice(j * 3, j * 3 + 2);
                    let formatted = day == "" ? 0 : Number(day);
                    days.push(formatted);
                }
            }
            calendarTrueRoot.days = days;
            return
        }

        // const lines = calendarTrueRoot.rawCalOutput.trim().split("\n")
        // calendarTrueRoot.year = Number(lines[0].trim())
        //
        // let months = []
        // for (let i = 2; i < lines.length; i += 8) {
        //     let months3 = lines[i].trim().split(/\s+/)
        //     for (let month of months3) {
        //         months.push(month)
        //     }
        // }


        // TODO: Handle per month days

    }
    anchor {
        window: barTrueRoot
        rect.x: parentWindow.width / 2 - width / 2
        rect.y: parentWindow.height
    }

    implicitWidth: 50 + (calendarTrueRoot.useAlternativeFormat ? 600 : 200)
    implicitHeight: 15 + (calendarTrueRoot.useAlternativeFormat ? 600 : 200)
    color: "transparent"
    visible: false

    onShowCalendarChanged: {
        if (calendarTrueRoot.visible) {
            calendarTrueRoot.hide();
            return;
        }

        calendarTrueRoot.show();
    }

    Process {
        command: {
            if (calendarTrueRoot.useAlternativeFormat) {
                ["cal", "-my"];
            } else {
                ["cal", "-m"];
            }
        }
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                calendarTrueRoot.rawCalOutput = this.text;
                calendarTrueRoot.parse_cal();
            }
        }
    }

    Rectangle {
        id: calendarRoot
        anchors {
            fill: parent
            topMargin: -15
        }
        radius: 15
        color: activePalette.window
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                duration: 350
                easing.type: Easing.InOutQuad
            }
        }

        ColumnLayout {
            anchors {
                centerIn: parent
                margins: 20
            }

            GridLayout {
                columns: 7
                rowSpacing: 5
                columnSpacing: 5

                // Month-Yeas
                Text {
                    Layout.columnSpan: 7
                    Layout.alignment: Qt.AlignHCenter

                    text: calendarTrueRoot.months + " " + calendarTrueRoot.year
                    font {
                        family: 'Lilex Nerd Font'
                        bold: true
                        pointSize: 12
                    }
                    color: activePalette.accent
                }

                Repeater {
                    model: calendarTrueRoot.weakdays

                    Text {
                        text: modelData

                        font {
                            family: 'Lilex Nerd Font'
                            bold: true
                            pointSize: 12
                        }
                        color: activePalette.highlight
                    }
                }

                Repeater {
                    model: calendarTrueRoot.days

                    Text {
                        text: modelData === 0 ? "" : modelData <= 9 ? "0" + modelData : modelData

                        font {
                            family: 'Lilex Nerd Font'
                            bold: true
                            pointSize: 12
                        }
                        color: modelData == calendarWidget.today ? activePalette.text : activePalette.placeholderText
                    }
                }
            }
        }
    }
}
