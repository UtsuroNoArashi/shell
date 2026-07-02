import Quickshell
import Quickshell.Io
import QtQuick
import "./popups/" as Popups

Item {
    id: sysControllRoot

    width: settingsLabel.implicitWidth
    height: settingsLabel.implicitHeight

    Text {
        id: settingsLabel
        text: ""
        color: colorscheme.text // qmllint disable unqualified
        font {
            family: "Lilex Nerd Font"
            pointSize: 12
            bold: true
        }
    }

    TapHandler {
        onPressedChanged: {
            if (pressed) {
                controls.toggle();
            }
        }
    }

    Popups.Controls {
        id: controls
    }
}
