import QtQuick
import QtQuick.Layouts

Text {
	text: "\ue266 " + SystemTimer.cpuUsage + "%"
	color: Theme.colorYellow
	font {
		family: Theme.fontFamily
		pixelSize: Theme.fontSize
		bold: true
	}
	Layout.rightMargin: 4
}
