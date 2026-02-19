// using this line makes it a Singletone
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// clock update logic

// Singletons should always have Singletone as the type
Singleton {
	id: systemTimer

	// Time Tracking
	property string time

	// CPU Tracking
	property int cpuUsage: 0
	property int lastCpuIdle: 0
	property int lastCpuTotal: 0

	// Memory Tracking
	property int memUsage: 0

	// Volume Tracking
	property string volumeOut: ""
	property string volumeIn: ""
	property bool isVolumeOutMuted: false
	property bool isVolumeInMuted: false

	// Network Tracking
	property string networkStatus: "" // Example: 'Up: 5.2M | Down: 1.8M'
	property string netSpeed: "" // Example: '5.2M'

	// Battery Tracking
	property string batteryPercent: "" // Example: '100%'


	// CPU
	Process {
		id: cpuProc
		command: ["sh", "-c", "head -1 /proc/stat"]

		// SplitParser calls onRead for each line of output
		stdout: SplitParser {
			onRead: data => {
				// parse /proc/stat
				var p = data.trim().split(/\s+/)

				// p[4] is idle, p[5] is iowait (treat both as idle time for simplicity)
				var idle = parseInt(p[4]) + parseInt(p[5])

				// Sum all non-idle times (user, nice, system, irq, softirq, steal, guest)
				var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)

				if (lastCpuTotal > 0) {
					// Calculate percentage: (total_diff - idle_diff) / total_diff
					systemTimer.cpuUsage = Math.round(100 * (1 - (idle - systemTimer.lastCpuIdle) / (total - systemTimer.lastCpuTotal)))
				}

				systemTimer.lastCpuTotal = total
				systemTimer.lastCpuIdle = idle
			}
		}
		Component.onCompleted: running = true // start the process immediately
	}

	// MEMORY
	Process {
		id: memProc
		command: ["sh", "-c", "free | grep Mem"]

		stdout: SplitParser {
			onRead: data => {
				var parts = data.trim().split(/\s+/)
				var total = parseInt(parts[1]) || 1
				var used = parseInt(parts[2]) || 0
				systemTimer.memUsage = Math.round(100 * used / total)
			}
		}
		Component.onCompleted: running = true
	}

	// VOLUME
	Process {
		id: procVolOut
		command: ["sh", "-c", "pamixer --get-volume-human"]
		stdout: StdioCollector {
			onStreamFinished: {
				systemTimer.volumeOut = this.text.trim()
			}
		}
		Component.onCompleted: running = true
	}
	Process {
		id: procVolOutMute
		command: ["sh", "-c", "pamixer --get-mute"]
		stdout: StdioCollector {
			onStreamFinished: {
				systemTimer.isVolumeOutMuted = this.text.trim() === "true"
			}
		}
		Component.onCompleted: running = true
	}
	Process {
		id: procVolIn
		command: ["sh", "-c", "pamixer --default-source --get-volume-human"]
		stdout: StdioCollector {
			onStreamFinished: {
				systemTimer.volumeIn = this.text.trim()
			}
		}
		Component.onCompleted: running = true
	}
	Process {
		id: procVolInMute
		command: ["sh", "-c", "pamixer --default-source --get-mute"]
		stdout: StdioCollector {
			onStreamFinished: {
				systemTimer.isVolumeInMuted = this.text.trim() === "true"
			}
		}
		Component.onCompleted: running = true
	}

	// NETWORK
	// Process {
	// 	id: procNet
	// 	command: ["sh","-c","cat /sys/class/net/*/statistics/rx_bytes | awk '{sum+=$1} END{print sum}'"]
	// 	property int last: 0
	// 	stdout: SplitParser {
	// 		onRead: d => {
	// 			var now = parseInt(d)
	// 			var diff = now-last
	// 			systemTimer.netSpeed = Math.round(diff/1024) + "KB"
	// 			last = now
	// 		}
	// 	}
	// }

	// Battery */
	Process {
		id: procBat
		command: ["sh","-c","cat /sys/class/power_supply/*/capacity 2>/dev/null"]
		stdout: SplitParser { onRead: d => systemTimer.batteryPercent = d.trim()+"%" }
		Component.onCompleted: running = true
	}

	// create a process management object
	Process {
		id: dateProc
		// the command it will run, every argument is its own string
		command: ["date"]
		// run the command immediately
		running: true
		// process the stdout stream using a StdioCollector
		// Use StdioCollector to retrienve the text the process sends to stdout
		stdout: StdioCollector {
			// Listen for the streamFinished signal, which is sent when the process closes stdout
			// or exits
			onStreamFinished: {
				systemTimer.time = this.text
			}
		}
	}

	// --- SYSTEM REFRESH TIMER ---
	Timer {
		interval: 2200
		running: true // start the timer immediately
		repeat: true // run the timer again when it ends
		// when the timer is triggered, set the running property of the process
		// to true, which reruns it if stopped
		onTriggered: {
			cpuProc.running = true
			memProc.running = true
			procBat.running = true
			dateProc.running = true
		}
	}

	// -- Quick Clock Timer
	Timer {
		interval: 10
		running: true
		repeat: true
		onTriggered: {
			procVolIn.running = true
			procVolInMute.running = true
			procVolOut.running = true
			procVolOutMute.running = true
		}
	}
}
