import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PopupWindow {
    id: calendarTrueRoot
    property string rawCalOutput: ""
    readonly property var weekdays: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    property var formattedCal: null
    property bool showCalendar: false
    property bool useAlternativeFormat: false

    function handle_visibility() {
        if (calendarTrueRoot.visible) {
            calendarTrueRoot.visible = false 
            calendarRoot.opacity = 0
            return 
        }

        calendarTrueRoot.visible = true
        calendarRoot.opacity =  1
    }

    function start_cal_process() {
        if (calendarTrueRoot.useAlternativeFormat) {
            getCalendar.exec(["cal", "-c 1", "-my"]);
        } else {
            getCalendar.exec(["cal", "-m"]);
        }
    }

    function parse_cal() {
        let cal = {
            "year": 0,
            "months": []
        };

        let lines = calendarTrueRoot.rawCalOutput.trim().split("\n");
        if (calendarTrueRoot.useAlternativeFormat) {
            lines[lines.length] = "\n";

            let year = Number(lines[0].trim());
            cal["year"] = year;

            for (let i = 2; i < lines.length; i += 8) {
                let monthName = lines[i].trim();

                let days = [];
                for (let j = i + 2; j < i + 8; j++) {
                    let week = lines[j];

                    for (let k = 0; k < 7; k++) {
                        let day = week.slice(3 * k, 3 * k + 2);
                        let dayFormatted = day === "" ? 0 : Number(day);
                        days.push(dayFormatted);
                    }
                }

                cal["months"].push({
                    "month": monthName,
                    "daylist": days
                });
            }
        } else {
            let monthYear = lines[0].split(" ");
            let year = Number(monthYear[1].trim());
            let month = monthYear[0].trim();
            cal["year"] = year;

            let days = [];
            for (let i = 2; i < lines.length; i++) {
                let week = lines[i];

                for (let j = 0; j < 7; j++) {
                    let day = week.slice(3 * j, 3 * j + 2);
                    let dayFormatted = day === "" ? 0 : Number(day);
                    days.push(dayFormatted);
                }
            }
            cal["months"].push({
                "month": month,
                "daylist": days
            });
        }

        calendarTrueRoot.formattedCal = cal;
    }

    anchor {
        window: barTrueRoot
        rect.x: parentWindow.width / 2 - width / 2
        rect.y: parentWindow.height
    }

    implicitWidth: calendarTrueRoot.useAlternativeFormat ? 850 : 250 
    implicitHeight: calendarTrueRoot.useAlternativeFormat ? 750 : 250
    color: "transparent"
    visible: false

    onShowCalendarChanged: {
        calendarTrueRoot.handle_visibility()
    }

    onUseAlternativeFormatChanged: {
        layout.currentIndex = calendarTrueRoot.useAlternativeFormat ? 1 : 0
        calendarTrueRoot.start_cal_process()
    }

    Behavior on visible {
        NumberAnimation {
            duration: 600
            easing.type: Easing.Linear
        }
    }

    Process {
        id: getCalendar
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
        opacity: 1

        Behavior on opacity {
            NumberAnimation {
                duration: 450
                easing.type: Easing.InOutQuad
            }
        }

        StackLayout {
            id: layout
            currentIndex: 0
            anchors.centerIn: parent 

            Item {
            GridLayout {
                id: singleMonthLayout
                columns: 7
                rowSpacing: 5
                columnSpacing: 5
                anchors.centerIn: parent
                

                Text {
                    text: calendarTrueRoot.formattedCal["months"][0]["month"] + " " + calendarTrueRoot.formattedCal["year"]
                    color: activePalette.accent

                    font {
                        pointSize: 15
                        bold: true
                    }
                    Layout.columnSpan: 7
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Repeater {
                    model: calendarTrueRoot.weekdays

                    Text {
                        text: modelData
                        color: activePalette.accent

                        font {
                            pointSize: 13
                            bold: true
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                Repeater {
                    model: calendarTrueRoot.formattedCal["months"][0]["daylist"]

                    Text {
                        text: {
                            if (modelData === 0) {
                                return "";
                            }

                            return modelData <= 9 ? "0" + modelData : modelData;
                        }
                        color: {
                            let today = new Date().getDate();
                            if (modelData === today) {
                                return activePalette.text;
                            }
                            return activePalette.placeholderText;
                        }

                        font {
                            pointSize: 11
                            bold: true
                        }

                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        Item {
            GridLayout {
                id: fullCalendar
                rows: 3
                columns: 4
                rowSpacing: 15
                columnSpacing: 15
                anchors.centerIn: parent

                readonly property int today: new Date().getDate()
                readonly property int month: new Date().getMonth()

                Text {
                    text: calendarTrueRoot.formattedCal["year"]
                    color: activePalette.accent

                    font {
                        pointSize: 15
                        bold: true
                    }
                    Layout.alignment: Qt.AlignHCenter
                    Layout.columnSpan: 4
                    Layout.bottomMargin: -15
                }

                Repeater {
                    model: calendarTrueRoot.formattedCal["months"]

                    GridLayout {
                        columns: 7
                        columnSpacing: 5
                        rowSpacing: 5

                        readonly property int monthIndex: index

                        Text {
                            text: modelData.month
                            color: activePalette.accent

                            font {
                                pointSize: 13
                                bold: true
                            }
                            Layout.alignment: Qt.AlignHCenter
                            Layout.columnSpan: 7
                        }

                        Repeater {
                            model: calendarTrueRoot.weekdays

                            Text {
                                text: modelData
                                color: activePalette.accent

                                font {
                                    pointSize: 13
                                    bold: true
                                }
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        Repeater {
                            model: modelData.daylist

                            Text {
                                text: {
                                    if (modelData === 0) {
                                        return "";
                                    }

                                    return modelData <= 9 ? "0" + modelData : modelData;
                                }
                                color: {
                                    if (fullCalendar.today === modelData && monthIndex === fullCalendar.month) {
                                        return activePalette.text;
                                    }
                                    return activePalette.placeholderText;
                                }

                                font {
                                    pointSize: 11
                                    bold: true
                                }
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
        }
    }

    Component.onCompleted: {
        calendarTrueRoot.start_cal_process()
    }
}
