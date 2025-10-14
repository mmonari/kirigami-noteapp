import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Kirigami.ApplicationWindow {
    id: root
    
    title: (currentFile ? currentFile.split('/').pop() : i18n("Untitled")) + (textArea.modified ? " *" : "") + " - " + i18n("Kirigami NoteApp")
    
    width: 800
    height: 600
    
    property string currentFile: ""
    property bool hasFile: currentFile !== ""
    
    Component.onCompleted: {
        textArea.forceActiveFocus()
    }
    
    // File dialogs
    FileDialog {
        id: openDialog
        title: i18n("Open File")
        fileMode: FileDialog.OpenFile
        nameFilters: [i18n("Text files (*.txt)"), i18n("All files (*)")]
        onAccepted: {
            const path = selectedFile.toString().replace("file://", "")
            currentFile = path
            textArea.text = fileIO.read(path)
            textArea.modified = false
        }
    }
    
    FileDialog {
        id: saveDialog
        title: i18n("Save As")
        fileMode: FileDialog.SaveFile
        nameFilters: [i18n("Text files (*.txt)"), i18n("All files (*)")]
        defaultSuffix: "txt"
        onAccepted: {
            const path = selectedFile.toString().replace("file://", "")
            currentFile = path
            fileIO.write(path, textArea.text)
            textArea.modified = false
            showPassiveNotification(i18n("File saved"))
        }
    }
    
    // File I/O is now handled by C++ backend (exposed as fileIO)
    
    // Menu bar
    menuBar: Controls.MenuBar {
        Controls.Menu {
            title: i18n("File")
            
            Controls.Action {
                text: i18n("New")
                icon.name: "document-new"
                shortcut: StandardKey.New
                onTriggered: {
                    if (textArea.modified) {
                        showPassiveNotification(i18n("Unsaved changes!"))
                    }
                    currentFile = ""
                    textArea.text = ""
                    textArea.modified = false
                }
            }
            
            Controls.Action {
                text: i18n("Open...")
                icon.name: "document-open"
                shortcut: StandardKey.Open
                onTriggered: openDialog.open()
            }
            
            Controls.MenuSeparator {}
            
            Controls.Action {
                text: i18n("Save")
                icon.name: "document-save"
                shortcut: StandardKey.Save
                enabled: textArea.modified
                onTriggered: {
                    if (hasFile) {
                        fileIO.write(currentFile, textArea.text)
                        textArea.modified = false
                        showPassiveNotification(i18n("File saved"))
                    } else {
                        saveDialog.open()
                    }
                }
            }
            
            Controls.Action {
                text: i18n("Save As...")
                icon.name: "document-save-as"
                shortcut: StandardKey.SaveAs
                onTriggered: saveDialog.open()
            }
            
            Controls.MenuSeparator {}
            
            Controls.Action {
                text: i18n("Quit")
                icon.name: "application-exit"
                shortcut: StandardKey.Quit
                onTriggered: Qt.quit()
            }
        }
        
        Controls.Menu {
            title: i18n("Help")
            
            Controls.Action {
                text: i18n("About")
                icon.name: "help-about"
                onTriggered: showPassiveNotification(i18n("Kirigami NoteApp v1.0 - A minimal text editor"))
            }
        }
    }
    
    // Main page
    pageStack.initialPage: Kirigami.Page {
        padding: 0
        globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None
        
        // Text editor
        Controls.ScrollView {
            anchors.fill: parent
            
            Controls.TextArea {
                id: textArea
                
                property bool modified: false
                
                focus: true
                font.family: "Monospace"
                font.pointSize: 11
                wrapMode: TextEdit.Wrap
                selectByMouse: true
                persistentSelection: true
                
                background: Rectangle {
                    color: Kirigami.Theme.backgroundColor
                }
                
                onTextChanged: {
                    if (text !== "" && !modified) {
                        modified = true
                    }
                }
            }
        }
        
        // Footer with status
        footer: Controls.ToolBar {
            height: Kirigami.Units.gridUnit * 1.5
            
            Controls.Label {
                anchors.left: parent.left
                anchors.leftMargin: Kirigami.Units.smallSpacing
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    const lines = textArea.text.split('\n').length
                    const chars = textArea.text.length
                    return i18n("Lines: %1 | Characters: %2", lines, chars)
                }
                font: Kirigami.Theme.smallFont
            }
            
            Controls.Label {
                anchors.right: parent.right
                anchors.rightMargin: Kirigami.Units.smallSpacing
                anchors.verticalCenter: parent.verticalCenter
                text: textArea.modified ? i18n("Modified") : i18n("Saved")
                font: Kirigami.Theme.smallFont
                color: textArea.modified ? Kirigami.Theme.neutralTextColor : Kirigami.Theme.positiveTextColor
            }
        }
    }
}
