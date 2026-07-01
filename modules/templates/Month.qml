pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts 

GridLayout {
    id: month
    required property int index
    required property var modelData
    required property var weekdays
    required property var monthDays 
    required property int today
    required property bool hasToday

    readonly property font h1: ({
        family: "Lilex Nerd Font",
        pointSize: 13,
        bold: true 
    })

    readonly property font h2: ({
        family: "Lilex Nerd Font",
        pointSize: 11,
        bold: true
    })

    readonly property font h3: ({
        family: "Lilex Nerd Font",
        pointSize: 9,
        bold: true
    })

    columns: 7
    rowSpacing: 5
    columnSpacing: 5

    Text {
        text: month.modelData
        color: colorscheme.iris                                                 // qmllint disable unqualified
        font: month.h1
        Layout.alignment: Qt.AlignHCenter
        Layout.columnSpan: 7
    }

    Repeater {
        model: month.weekdays
        delegate: Text {
            required property var modelData 

            text: modelData
            color: colorscheme.gold                                             // qmllint disable unqualified
            font: month.h2
        }
    }

    Repeater {
        model: month.monthDays 
        delegate: Text {
            required property var modelData 
            required property var index

            text: modelData === 0 ? "" : (modelData <= 9 ? "0" + modelData : modelData)
            color: {
                let isToday = modelData === month.today
                if (isToday && month.hasToday) {
                    return colorscheme.text // qmllint disable unqualified 
                }

                return (index % 7 === 0) ? colorscheme.love : colorscheme.subtle // qmllint disable unqualified
            }
            font: month.h3
        }
    }
}
