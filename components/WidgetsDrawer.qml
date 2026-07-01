import QtQuick
import "../modules/" as Modules

Item {
    anchors {
        fill: parent
        rightMargin: 10
        leftMargin: 10
    }

    Modules.Workspaces {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Modules.Clock {
        anchors.centerIn: parent
    }

    Row {
        anchors.right: parent.right
        spacing: 10

        Text {
            text: "Wifi + Settings"
            color: colorscheme.text
        }
    }

    // Modules.Settings {
    //     anchors.right: parent.right
    //     anchors.verticalCenter: parent.verticalCenter
    // }
}
