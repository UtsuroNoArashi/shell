import Quickshell
import QtQuick
import "./utils" as Utils
import "./components/" as Components

ShellRoot {
    Utils.Theme {
        id: colorscheme
        currentVariant: moon
    }

    Components.Bar {}
}
