import QtQuick // for Text

// CLOCK WIDGET
Text {
	id: clock

	property bool isFull: false
	property string currentTime: ""
	property string currentDate: ""

	// --- Background ---
	// Rectangle {
	// 	id: bg
	// 	radius: parent.height / 2
	// 	color: "#313244"
	// 	border.color: "transparent"
	// 	border.width: 0
	// 	anchors.fill: parent
	// 	implicitHeight: timeText.implicitHeight + 10
	// 	implicitWidth: timeText.implicitWidth + 12
	// }

	text: isFull ? currentDate : currentTime
	color: Theme.colorBlue

	font {
		family: Theme.fontFamily
		pixelSize: Theme.fontSize
		bold: true
	}

	function updateDateTime() {
		const tt = new Date()
		currentTime = Qt.formatDateTime(tt, "HH:mm:ss")
		currentDate = Qt.formatDateTime(tt, "ddd, dd MMM | yyyy")
	}


	Timer {
		interval: 10
		running: true
		repeat: true
		onTriggered: updateDateTime()
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: clock.isFull = !clock.isFull
		onEntered: {
			console.log("Hi Cami!")
		}
		onExited: {
			console.log("Bye Cami!")
		}
	}

	Component.onCompleted: updateDateTime()
}
