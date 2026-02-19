import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts


Scope {
	Variants {
		model: Quickshell.screens;

		PanelWindow {
			// the screen from the screens list will be injected into this property
			required property var modelData

			// we can then set the window's screen to the injected property
			screen: modelData

			anchors {
				top: true
				left: true
				right: true
			}

			implicitHeight: 30
			color: Theme.colorBackground

			RowLayout {
				anchors {
					fill: parent
					margins: 8 // padding inside the bar
				}

				spacing: 8 // spacing between modules

				ClockWidget {}

				RectangleWidget {}

				WorkspacesWidget {}

				// Add an item to act as a spacer that pushes everything to the right
				Item { Layout.fillWidth: true }

				Text {
					text: SystemTimer.isVolumeOutMuted ? " \udb81\udfce " : "\udb80\udecb " + SystemTimer.volumeOut
					color: SystemTimer.isVolumeOutMuted ? Theme.colorRed : Theme.colorPurple
					font {
						family: Theme.fontFamily
						pixelSize: Theme.fontSize
						bold: true
					}
					Process {
						id: procVolOutToggleMute
						command: ["sh", "-c", "pamixer --get-default-sink -t"]
					}
					Process {
						id: procVolOutUp
						command: ["sh", "-c", "pamixer --get-default-sink -i 5"]
					}
					Process {
						id: procVolOutDown
						command: ["sh", "-c", "pamixer --get-default-sink -d 5"]
					}
					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						onClicked: {
							procVolOutToggleMute.running = true
						}
						function wheelControl(wheel) {
							if (wheel.angleDelta.y > 0) {
								procVolOutUp.running = true
							} else {
								procVolOutDown.running = true
							}
							wheel.accepted = true
						}
						onWheel: {
							wheelControl(wheel)
						}
					}
				}

				RectangleWidget {}

				Text {
					text: SystemTimer.isVolumeInMuted ? " \udb80\udf6d " : "\udb80\udf6c " + SystemTimer.volumeIn
					color: SystemTimer.isVolumeInMuted ? Theme.colorRed : Theme.colorPurple
					font {
						family: Theme.fontFamily
						pixelSize: Theme.fontSize
						bold: true
					}
					Process {
						id: procVolInToggleMute
						command: ["sh", "-c", "pamixer --default-source -t"]
					}
					Process {
						id: procVolInUp
						command: ["sh", "-c", "pamixer --default-source -i 5"]
					}
					Process {
						id: procVolInDown
						command: ["sh", "-c", "pamixer --default-source -d 5"]
					}
					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
						onClicked: {
							procVolInToggleMute.running = true
						}
						onWheel: {
							if (wheel.angleDelta.y > 0) {
								procVolInUp.running = true
							} else {
								procVolInDown.running = true
							}
							wheel.accepted = true
						}
					}
				}

				RectangleWidget {}


				CPUWidget {}

				RectangleWidget {}

				MemoryWidget {}

				RectangleWidget {}

				// Text {
				// 	text: "\udb81\udcc5" + SystemTimer.netSpeed
				// 	color: Theme.colorYellow
				// 	font {
				// 		family: Theme.fontFamily
				// 		pixelSize: Theme.fontSize
				// 		bold: true
				// 	}
				// 	Layout.rightMargin: 4
				// }

				// RectangleWidget {}

				Text {
					text: "\udb80\udc79 " + SystemTimer.batteryPercent
					color: Theme.colorYellow
					font {
						family: Theme.fontFamily
						pixelSize: Theme.fontSize
						bold: true
					}
					Layout.rightMargin: 4
				}
			}
		}
	}
}
