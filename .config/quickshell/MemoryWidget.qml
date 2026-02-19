import QtQuick
import QtQuick.Layouts

Text {
	text: "\uf2dc " + SystemTimer.memUsage + "%"
	color: SystemTimer.memUsage > 80 ? Theme.colorRed : Theme.colorCyan // Red alert if high
	font {
		family: Theme.fontFamily
		pixelSize: Theme.fontSize
		bold: true
	}
}
