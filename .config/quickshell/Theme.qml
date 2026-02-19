pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: theme

	// THEME COLORS
	property color colorBackground: "#1a1b26"
	property color colorForeground: "#a9b1d6"
	property color colorMuted: "#444b6a"
	property color colorCyan: "#0db9d7"
	property color colorPurple: "#ad8ee6"
	property color colorRed: "#f7768e"
	property color colorYellow: "#e0af68"
	property color colorBlue: "#7aa2f7"

	// FONT
	property string fontFamily: "JetBrainsMono Nerd Font Propo"
	property int fontSize: 13

}
