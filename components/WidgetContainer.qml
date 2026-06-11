import "../widgets/"
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: widgetsRoot
    signal toggleCalendar
    signal toggleFullCalendar
    anchors.centerIn: parent

    onToggleCalendar: {
        calendarWidget.toggleCalendar = !calendarWidget.toggleCalendar;
    }

    onToggleFullCalendar: {
        calendarWidget.toggleFullCalendar = !calendarWidget.toggleFullCalendar;
    }

    Clock {
        id: clockWidget
    }

    Calendar {
        id: calendarWidget
    }
}
