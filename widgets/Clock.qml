import QtQuick
import Quickshell

Rectangle {
    id: clockRoot

    property string time: Qt.formatDateTime(sysClock.date, "hh:mm AP")
    property string date: Qt.formatDateTime(sysClock.date, "ddd d, MMM yyyy")
    property bool canScroll: true

    Text {
        id: timeDateLabel
        anchors.centerIn: parent
        color: activePalette.text
        font {
            family: 'Lilex Nerd Font'
            pointSize: 12
            bold: true
        }
    }

    MouseArea {
        id: clockWidgetEventHandler
        anchors.fill: timeDateLabel
        hoverEnabled: true

        onWheel: {
            if (clockRoot.canScroll) {
                timeDateLabel.text = 
                timeDateLabel.text == clockRoot.time ? clockRoot.date : clockRoot.time
                clockRoot.canScroll = false
            }
            resetScroll.restart()
        }

        onClicked: widgetsRoot.toggleFullCalendar()
        onEntered: widgetsRoot.toggleCalendar()
        onExited: widgetsRoot.toggleCalendar()
    }

    Timer {
        id: resetScroll
        repeat: false
        running: true
        interval: 300
        onTriggered: {
            clockRoot.canScroll = true;
        }
    }

    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }

    Component.onCompleted: {
        timeDateLabel.text = time;
    }
}
