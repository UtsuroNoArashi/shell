import QtQuick
import "./templates/" as Templates

Rectangle {
    id: wsListRoot

    readonly property int wsCount: 10

    color: colorscheme.surface // qmllint disable unqualified
    width: wsList.implicitWidth * 1.125
    height: wsList.implicitHeight
    radius: 12

    Row {
        id: wsList
        spacing: 5
        anchors.centerIn: parent 

        Repeater {
            model: wsListRoot.wsCount 
            delegate: Templates.Workspace {}
        }
    }
}
