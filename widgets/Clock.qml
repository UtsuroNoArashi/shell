import QtQuick
import Quickshell 

Rectangle {
    property string time: Qt.formatDateTime(sysClock.date, "hh:mm AP")
    property string date: Qt.formatDateTime(sysClock.date, "ddd d, MMM yyyy")

    Text {
        id: timeDateLabel
        anchors.centerIn: parent
        color: activePalette.text
        font { family: 'Lilex Nerd Font'; pointSize: 12; bold: true }
    }

    MouseArea {
        id: clockWidgetEventHandler 
        anchors.fill: timeDateLabel
        hoverEnabled: true
        onClicked: widgetsRoot.showCalendar()
        onEntered: timeDateLabel.text = date 
        onExited: { timeDateLabel.text = time; widgetsRoot.showCalendar() }
        onWheel: widgetsRoot.useAlternativeFormat()
    }

    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }

    Component.onCompleted: {
        timeDateLabel.text = time
    }
}
