import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PopupWindow {
    id: calendarPopup
    property bool toggleCalendar: false
    property bool toggleFullCalendar: false

    property string rawOutputs: ""
    property var dayNames: []
    property var monthNames: []
    property var daysByMonth: []
    property int year: 0

    readonly property int todaysMonth: new Date().getMonth()
    readonly property int today: new Date().getDate()

    function set_calendars() {
        let lines = rawOutputs.trim().split("\n");
        lines[lines.length] = "\n";

        year = Number(lines[0].trim());

        let dayNamesList = lines[3].trim().split(/\s+/);
        dayNames = dayNamesList;

        let monthNamesList = [];
        let daysByMonthList = [];
        for (let row = 2; row < lines.length; row += 8) {
            let monthName = lines[row].trim();
            monthNamesList.push(monthName);

            let days = [];
            for (let i = row + 2; i < row + 8; i++) {
                let week = lines[i];

                for (let j = 0; j < 7; j++) {
                    let day = lines[i].slice(j * 3, j * 3 + 2);
                    let dday = day === "" ? 0 : Number(day);
                    days.push(dday);
                }
            }
            daysByMonthList.push(days);
        }
        monthNames = monthNamesList;
        daysByMonth = daysByMonthList;
    }

    anchor {
        window: barTrueRoot
        rect.x: parentWindow.width / 2 - implicitWidth / 2
        rect.y: parentWindow.height + 20
    }

    implicitWidth: 850
    implicitHeight: 750

    color: "transparent"

    onToggleCalendarChanged: {
        visible = !visible;
    }

    Rectangle {
        id: popupBackground

        width: calendarPopup.toggleFullCalendar ? 850 : 250
        height: calendarPopup.toggleFullCalendar ? 750 : 250

        anchors.horizontalCenter: parent.horizontalCenter
        color: activePalette.mid
        radius: 20
        opacity: calendarPopup.visible ? 1.0 : 0.0

        Behavior on width {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutCubic
            }
        }

        Item {
            anchors.fill: parent
            opacity: calendarPopup.toggleFullCalendar ? 0 : 1
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            GridLayout {
                columns: 7
                rowSpacing: 5
                columnSpacing: 5
                anchors.centerIn: parent

                Text {
                    text: calendarPopup.monthNames[calendarPopup.todaysMonth] + " " + calendarPopup.year

                    color: activePalette.accent
                    font {
                        family: "Lilex Nerd Font"
                        pointSize: 15
                        bold: true
                    }
                    Layout.columnSpan: 7
                    Layout.alignment: Qt.AlignHCenter
                }

                Repeater {
                    model: calendarPopup.dayNames

                    Text {
                        text: modelData
                        color: activePalette.accent

                        font {
                            family: "Lilex Nerd Font"
                            pointSize: 13
                            bold: true
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                Repeater {
                    model: calendarPopup.daysByMonth[calendarPopup.todaysMonth]

                    Text {
                        text: modelData === 0 ? "" : modelData <= 9 ? "0" + modelData : modelData
                        color: calendarPopup.today === modelData ? activePalette.text : activePalette.placeholderText

                        font {
                            family: "Lilex Nerd Font"
                            pointSize: 11
                            bold: true
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        Item {
            anchors.fill: parent
            opacity: calendarPopup.toggleFullCalendar ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            GridLayout {
                columns: 4
                rows: 3
                columnSpacing: 15
                rowSpacing: 15
                anchors.centerIn: parent

                Text {
                    text: calendarPopup.year
                    color: activePalette.accent

                    font {
                        family: "Lilex Nerd Font"
                        pointSize: 15
                        bold: true
                    }
                    Layout.alignment: Qt.AlignHCenter
                    Layout.columnSpan: 4
                }

                Repeater {
                    model: Array.from({
                        length: 12
                    }, (_, i) => i)

                    GridLayout {
                        columns: 7
                        rowSpacing: 5
                        columnSpacing: 5
                        readonly property int currIndex: index

                        Text {
                            text: calendarPopup.monthNames[index]
                            color: activePalette.accent

                            font {
                                family: "Lilex Nerd Font"
                                pointSize: 13
                                bold: true
                            }
                            Layout.alignment: Qt.AlignHCenter
                            Layout.columnSpan: 7
                        }

                        Repeater {
                            model: calendarPopup.dayNames

                            Text {
                                text: modelData
                                color: activePalette.accent

                                font {
                                    family: "Lilex Nerd Font"
                                    pointSize: 13
                                    bold: true
                                }
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        Repeater {
                            model: calendarPopup.daysByMonth[index]

                            Text {
                                text: modelData === 0 ? "" : modelData <= 9 ? "0" + modelData : modelData
                                color: {
                                    if (currIndex !== calendarPopup.todaysMonth) {
                                        return activePalette.placeholderText;
                                    }

                                    if (modelData === calendarPopup.today) {
                                        return activePalette.text;
                                    }

                                    return activePalette.placeholderText;
                                }

                                font {
                                    family: "Lilex Nerd Font"
                                    pointSize: 11
                                    bold: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        running: true
        command: ["cal", "-c 1", "-my"]
        stdout: StdioCollector {
            onStreamFinished: {
                calendarPopup.rawOutputs = this.text;
                calendarPopup.set_calendars();
            }
        }
    }
}
