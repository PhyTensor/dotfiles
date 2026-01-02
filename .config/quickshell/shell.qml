//@ pragma UseQApplication

import Quickshell // for PanelWindow
import Quickshell.Io // for Process
import QtQuick // for Text


// import "./modules/bar/"
// import modules.bar

// ShellRoot {
// 	id: root
//
// 	// Direct Loader without container - matches the repository patter
// 	Loader {
// 		active: true
// 		sourceComponent: Bar {}
// 	}
// }

Scope {
	Bar {}
}

