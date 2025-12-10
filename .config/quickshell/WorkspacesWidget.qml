import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland // Hyprland IPC access
import QtQuick

// WORKSPACES
// Repeater creates 10 copies, each gets an index (0-8)
Repeater {
	model: 10

	Text {
		property int workspaceId: index + 1

		// Live data from Hyprland IPC
		property var workspace: Hyprland.workspaces.values.find(w => w.id === workspaceId) ?? null
		property bool isActive: Hyprland.focusedWorkspace?.id === (workspaceId)
		property bool hasWindows: workspace !== null

		text: workspaceId === 10 ? "0" : workspaceId.toString()

		// Color logic: cyan = active, blue = has windows, gray = empty
		color: isActive ? Theme.colorCyan : (hasWindows ? Theme.colorBlue : Theme.colorMuted)

		font {
			family: Theme.fontFamily
			pixelSize: Theme.fontSize
			bold: true
		}

		Rectangle {
			width: parent.width
			height: parent.height * 0.12
			color: isActive ? Theme.colorPurple : Theme.colorBackground
			opacity: 0.89
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom
		}

		// Click to switch workspaces
		MouseArea {
			anchors.fill: parent
			onClicked: Hyprland.dispatch("workspace " + (workspaceId))
		}
	}
}

