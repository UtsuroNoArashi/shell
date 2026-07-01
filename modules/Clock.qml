import Quickshell
import QtQuick
import "./popups/" as Popups

Item {
    id: clockRoot
    property string date: Qt.formatDateTime(sysClock.date, "ddd dd, MMM yyyy")
    property string time: Qt.formatDateTime(sysClock.date, "hh:mm AP")
    property string labelText: time

    function hourToIcon() {
        let hour = Number(time.slice(0, 2)) - 1;
        let icons = ["󱐿", "󱑀", "󱑁", "󱑂", "󱑃", "󱑄", "󱑅", "󱑆", "󱑇", "󱑈", "󱑉", "󱑊"];
        return icons[hour];
    }

    Text {
        text: clockRoot.hourToIcon() + " " + clockRoot.time + " —  " + clockRoot.date
        color: colorscheme.text // qmllint disable unqualified
        anchors.centerIn: parent
        font {
            pointSize: 12
            bold: true
            family: "Lilex Nerd Font"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPressedChanged: {
                if (pressed) {
                    cal.toggle()
                }
            }
        }
    }

    Popups.Calendar {
        id: cal
    }



    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }
}
