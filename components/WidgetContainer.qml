import "../widgets/"
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: widgetsRoot
    signal toggleCalendar
    signal toggleFullCalendar
    anchors.fill: parent
    spacing: 10

    onToggleCalendar: {
        calendarWidget.toggleCalendar = !calendarWidget.toggleCalendar;
    }

    onToggleFullCalendar: {
        calendarWidget.toggleFullCalendar = !calendarWidget.toggleFullCalendar;
    }

    Clock {
        id: clockWidget
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: parent.width * 0.2
    }

    Calendar {
        id: calendarWidget
    }

    Brightness {
        id: brightnessWidget
        Layout.preferredWidth: parent.width * 0.00625
    }
}
