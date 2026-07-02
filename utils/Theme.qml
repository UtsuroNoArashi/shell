import QtQuick

QtObject {
    readonly property Component _themeFactory: Component {
        QtObject {
            property color base
            property color surface
            property color overlay

            property color muted
            property color subtle
            property color text

            property color love
            property color gold
            property color rose
            property color pine
            property color foam
            property color iris

            property color highlightLow
            property color highlightMed
            property color highlightHigh
        }
    }

    readonly property var dawn: buildTheme("#faf4ed", "#fffaf3", "#f2e9e1", "#9893a5", "#797593", "#464261", "#b4637a", "#ea9d34", "#d7827e", "#286983", "#56949f", "#907aa9", "#f4ede8", "#dfdad9", "#cecacd")
    readonly property var main: buildTheme("#191724", "#1f1d2e", "#26233a", "#6e6a86", "#908caa", "#e0def4", "#eb6f92", "#f6c177", "#ebbcba", "#31748f", "#9ccfd8", "#c4a7e7", "#21202e", "#403d52", "#524f67")
    readonly property var moon: buildTheme("#232136", "#2a273f", "#393552", "#6e6a86", "#908caa", "#e0def4", "#eb6f92", "#f6c177", "#ea9a97", "#3e8fb0", "#9ccfd8", "#c4a7e7", "#2a283e", "#44415a", "#56526e")

    property var currentVariant: main
    readonly property color base: currentVariant.base
    readonly property color surface: currentVariant.surface
    readonly property color overlay: currentVariant.overlay
    readonly property color muted: currentVariant.muted
    readonly property color subtle: currentVariant.subtle
    readonly property color text: currentVariant.text
    readonly property color love: currentVariant.love
    readonly property color gold: currentVariant.gold
    readonly property color rose: currentVariant.rose
    readonly property color pine: currentVariant.pine
    readonly property color foam: currentVariant.foam
    readonly property color iris: currentVariant.iris
    readonly property color highlightLow: currentVariant.highlightLow
    readonly property color highlightMed: currentVariant.highlightMed
    readonly property color highlightHigh: currentVariant.highlightHigh

    function buildTheme(tBase: color, tSurface: color, tOverlay: color, tMuted: color, tSubtle: color, tText: color, tLove: color, tGold: color, tRose: color, tPine: color, tFoam: color, tIris: color, tHlL: color, tHlM: color, tHlH: color): QtObject {
        return _themeFactory.createObject(this, {
            base: tBase,
            surface: tSurface,
            overlay: tOverlay,
            muted: tMuted,
            subtle: tSubtle,
            text: tText,
            love: tLove,
            gold: tGold,
            rose: tRose,
            pine: tPine,
            foam: tFoam,
            iris: tIris,
            highlightLow: tHlL,
            highlightMed: tHlM,
            highlightHigh: tHlH
        });
    }

    function toAlpha(tColor: color, alpha: real): color {
        if (alpha < 0 || alpha > 1) {
            return tColor;
        }

        return Qt.rgba(tColor.r, tColor.g, tColor.b, alpha);
    }
}
