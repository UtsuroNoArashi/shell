import "../widgets/"
import QtQuick
import QtQuick.Layouts

RowLayout {
    signal showCalendar
    signal useAlternativeFormat

    id: widgetsRoot
    anchors.centerIn: parent

    onShowCalendar: {
        calendarWidget.showCalendar = !calendarWidget.showCalendar
    }

    onUseAlternativeFormat: {
        calendarWidget.useAlternativeFormat = !calendarWidget.useAlternativeFormat
    }

    Clock {
        id: clockWidget
        // Layout.preferredWidth: parent.width * 0.2 
        // Layout.preferredHeight: parent.height
        // Layout.alignment: Qt.AlignCenter
    }

    Calendar { id: calendarWidget }
}
