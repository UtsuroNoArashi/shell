pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../templates/" as Templates

PopupWindow {
    id: calRoot
    signal toggle

    property int year
    property list<string> months
    property list<string> weekdays
    property var daysByMonth
    property bool showFull
    property bool hovered

    readonly property int today: new Date().getDate()
    readonly property int month: new Date().getMonth()

    function parseCal(toParse: string): void {
        let lines = toParse.trim().split("\n");
        lines[lines.length] = "";

        let parsedYear = Number(lines[0].trim());
        year = parsedYear;

        let parsedWeekdays = lines[3].trim().split(" ");
        weekdays = parsedWeekdays;

        let parsedMonths = [];
        let parsedByMonth = [];
        for (let row = 2; row < lines.length; row += 8) {
            let parsedMonth = lines[row].trim();
            parsedMonths.push(parsedMonth);

            let parsedDays = [];
            for (let i = row + 2; i < row + 8; i++) {
                let parsedWeek = lines[i];

                for (let j = 0; j < 7; j++) {
                    let parsedDay = parsedWeek.slice(j * 3, j * 3 + 2);
                    let formattedDay = parsedDay === "" ? 0 : Number(parsedDay.trim());
                    parsedDays.push(formattedDay);
                }
            }

            parsedByMonth.push(parsedDays);
        }
        months = parsedMonths;
        daysByMonth = parsedByMonth;
    }

    function hide() {
        calBG.opacity = 0;
        delay.restart();
    }

    function show() {
        calRoot.visible = true;
        calBG.opacity = 1;
        cooldown.restart()
    }

    anchor {
        window: barRoot                                                         // qmllint disable unqualified
        rect.x: parentWindow.width / 2 - implicitWidth / 2                      // qmllint disable
        rect.y: parentWindow.height + 15                                        // qmllint disable
    }

    implicitWidth: 770
    implicitHeight: 660
    color: "transparent"

    onToggle: visible ? hide() : show()
    onShowFullChanged: {
        if (showFull) {
            mono.visible = false;
            delayMulti.restart();
            return;
        }

        multi.visible = false;
        delayMono.restart();
    }

    Rectangle {
        id: calBG
        width: calRoot.showFull ? calRoot.width : (calRoot.width - 101) / 4 + 101
        height: calRoot.showFull ? calRoot.height : (calRoot.height - 101) / 3 + 101
        anchors.horizontalCenter: parent.horizontalCenter
        color: colorscheme.base                                                 // qmllint disable unqualified
        radius: 35
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 700
            }
        }

        Behavior on width {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 700
            }
        }

        Behavior on height {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 700
            }
        }

        GridLayout {
            id: mono
            columns: 7
            rowSpacing: 5
            columnSpacing: 5
            anchors.centerIn: parent
            visible: true

            Templates.Month {
                index: calRoot.month
                modelData: calRoot.months[index] + " " + calRoot.year
                weekdays: calRoot.weekdays
                monthDays: calRoot.daysByMonth[index]
                today: calRoot.today
                hasToday: true
            }

            Timer {
                id: delayMono
                interval: 0
                onTriggered: {
                    mono.visible = true;
                    eventHandler.enabled = true;
                }
            }
        }

        GridLayout {
            id: multi
            columns: 4
            rows: 3
            rowSpacing: 15
            columnSpacing: 15
            visible: false
            anchors.centerIn: parent

            Text {
                text: calRoot.year
                color: colorscheme.iris // qmllint disable unqualified
                font {
                    family: "Lilex Nerd Font"
                    pointSize: 15
                    bold: true
                }
                Layout.columnSpan: 4
                Layout.alignment: Qt.AlignHCenter
            }

            Repeater {
                model: calRoot.months
                delegate: Templates.Month {
                    weekdays: calRoot.weekdays
                    monthDays: calRoot.daysByMonth[index]
                    today: calRoot.today
                    hasToday: index === calRoot.month
                }
            }

            Timer {
                id: delayMulti
                interval: 700
                onTriggered: {
                    multi.visible = true;
                    eventHandler.enabled = true;
                }
            }
        }

        MouseArea {
            id: eventHandler
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                enabled = false;
                calRoot.showFull = !calRoot.showFull;
            }

            onEntered: calRoot.hovered = true 
            onExited: {
                calRoot.hovered = false 
                cooldown.restart()
            }

        }
    }

    Timer {
        id: delay
        interval: 700
        onTriggered: calRoot.visible = false
    }

    Timer {
        id: cooldown
        interval: 1500
        onTriggered: {
            if (!calRoot.hovered) {
                calRoot.hide()
            }
        }
    }

    Process {
        running: true
        command: ["cal", "-c 1", "-y"]
        stdout: StdioCollector {
            onStreamFinished: {
                calRoot.parseCal(this.text);
            }
        }
    }
}
