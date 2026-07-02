import QtQuick

Rectangle {
    id: settingsRoot

    width: settings.implicitWidth * 1.5
    height: settings.implicitHeight
    color: colorscheme.surface // qmllint disable unqualified
    radius: 12

    Row {
        id: settings
        spacing: 5
        anchors.centerIn: parent

        SystemControls {}
    }
}

