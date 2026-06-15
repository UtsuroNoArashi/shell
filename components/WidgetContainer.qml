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

    Item {
        Layout.preferredWidth: parent.width * 0.3
    }


    Clock {
        id: clockWidget
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: parent.width * 0.4
    }

    Calendar {
        id: calendarWidget
    }

    Wpctl {
        id: audioWidget
        Layout.preferredWidth: parent.width * 0.0375
    }

    Brightness {
        id: brightnessWidget
        Layout.preferredWidth: parent.width * 0.0375
    }

    Item {
        Layout.preferredWidth: parent.width * 2.925
    }

}
