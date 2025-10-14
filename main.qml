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
    
    // Handle window close events
    onClosing: (close) => {
        if (textArea.modified) {
            close.accepted = false
            quitConfirmDialog.open()
        }
    }
    
    Component.onCompleted: {
        textArea.forceActiveFocus()
        
        // Load file from command line argument if provided
        if (typeof initialFile !== 'undefined' && initialFile !== null && initialFile !== "") {
            currentFile = initialFile
            const content = fileIO.read(initialFile)
            if (content !== null && content !== undefined) {
                textArea.text = content
                textArea.modified = false
            }
        }
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
    
    // Confirmation dialog for opening file with unsaved changes
    Controls.Dialog {
        id: openFileConfirmDialog
        title: i18n("Unsaved Changes")
        modal: true
        anchors.centerIn: parent
        
        standardButtons: Controls.Dialog.Save | Controls.Dialog.Discard | Controls.Dialog.Cancel
        
        Controls.Label {
            text: i18n("The document has been modified.\nDo you want to save your changes before opening another file?")
        }
        
        onAccepted: {
            // Save button clicked
            if (hasFile) {
                fileIO.write(currentFile, textArea.text)
                textArea.modified = false
                openDialog.open()
            } else {
                saveDialogBeforeOpen.open()
            }
        }
        
        onDiscarded: {
            // Discard button clicked
            textArea.modified = false
            openDialog.open()
        }
        
        onRejected: {
            // Cancel button clicked - do nothing
        }
    }
    
    // Save dialog for open file scenario
    FileDialog {
        id: saveDialogBeforeOpen
        title: i18n("Save As")
        fileMode: FileDialog.SaveFile
        nameFilters: [i18n("Text files (*.txt)"), i18n("All files (*)")]
        defaultSuffix: "txt"
        onAccepted: {
            const path = selectedFile.toString().replace("file://", "")
            currentFile = path
            fileIO.write(path, textArea.text)
            textArea.modified = false
            openDialog.open()
        }
        onRejected: {
            // User cancelled save dialog, don't open
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
    
    // Confirmation dialog for unsaved changes
    Controls.Dialog {
        id: quitConfirmDialog
        title: i18n("Unsaved Changes")
        modal: true
        anchors.centerIn: parent
        
        standardButtons: Controls.Dialog.Save | Controls.Dialog.Discard | Controls.Dialog.Cancel
        
        Controls.Label {
            text: i18n("The document has been modified.\nDo you want to save your changes?")
        }
        
        onAccepted: {
            // Save button clicked
            if (hasFile) {
                fileIO.write(currentFile, textArea.text)
                textArea.modified = false
                Qt.quit()
            } else {
                saveDialogBeforeQuit.open()
            }
        }
        
        onDiscarded: {
            // Discard button clicked
            textArea.modified = false
            Qt.quit()
        }
        
        onRejected: {
            // Cancel button clicked - do nothing
        }
    }
    
    // Save dialog specifically for quit scenario
    FileDialog {
        id: saveDialogBeforeQuit
        title: i18n("Save As")
        fileMode: FileDialog.SaveFile
        nameFilters: [i18n("Text files (*.txt)"), i18n("All files (*)")]
        defaultSuffix: "txt"
        onAccepted: {
            const path = selectedFile.toString().replace("file://", "")
            currentFile = path
            fileIO.write(path, textArea.text)
            textArea.modified = false
            Qt.quit()
        }
        onRejected: {
            // User cancelled save dialog, don't quit
        }
    }
    
    // Confirmation dialog for new document with unsaved changes
    Controls.Dialog {
        id: newFileConfirmDialog
        title: i18n("Unsaved Changes")
        modal: true
        anchors.centerIn: parent
        
        standardButtons: Controls.Dialog.Save | Controls.Dialog.Discard | Controls.Dialog.Cancel
        
        Controls.Label {
            text: i18n("The document has been modified.\nDo you want to save your changes before creating a new document?")
        }
        
        onAccepted: {
            // Save button clicked
            if (hasFile) {
                fileIO.write(currentFile, textArea.text)
                textArea.modified = false
                currentFile = ""
                textArea.text = ""
            } else {
                saveDialogBeforeNew.open()
            }
        }
        
        onDiscarded: {
            // Discard button clicked
            currentFile = ""
            textArea.text = ""
            textArea.modified = false
        }
        
        onRejected: {
            // Cancel button clicked - do nothing
        }
    }
    
    // Save dialog for new document scenario
    FileDialog {
        id: saveDialogBeforeNew
        title: i18n("Save As")
        fileMode: FileDialog.SaveFile
        nameFilters: [i18n("Text files (*.txt)"), i18n("All files (*)")]
        defaultSuffix: "txt"
        onAccepted: {
            const path = selectedFile.toString().replace("file://", "")
            currentFile = path
            fileIO.write(path, textArea.text)
            textArea.modified = false
            currentFile = ""
            textArea.text = ""
        }
        onRejected: {
            // User cancelled save dialog, don't create new
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
                        newFileConfirmDialog.open()
                    } else {
                        currentFile = ""
                        textArea.text = ""
                        textArea.modified = false
                    }
                }
            }
            
            Controls.Action {
                text: i18n("Open...")
                icon.name: "document-open"
                shortcut: StandardKey.Open
                onTriggered: {
                    if (textArea.modified) {
                        openFileConfirmDialog.open()
                    } else {
                        openDialog.open()
                    }
                }
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
                onTriggered: {
                    if (textArea.modified) {
                        quitConfirmDialog.open()
                    } else {
                        Qt.quit()
                    }
                }
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
        
        // Text editor with drag and drop support
        DropArea {
            id: dropArea
            anchors.fill: parent
            
            onDropped: (drop) => {
                if (drop.hasUrls && drop.urls.length > 0) {
                    // Properly convert URL to local file path
                    let fileUrl = drop.urls[0]
                    let filePath = fileUrl.toString().replace(/^file:\/\//, "")
                    // Decode URL encoding (e.g., %20 -> space)
                    filePath = decodeURIComponent(filePath)
                    
                    // Check if it's a text file
                    if (!fileIO.isTextFile(filePath)) {
                        showPassiveNotification(i18n("Only text files are supported"))
                        return
                    }
                    
                    // If current text is empty/null, load in current instance
                    if (!textArea.text || textArea.text.trim() === "") {
                        currentFile = filePath
                        textArea.text = fileIO.read(filePath)
                        textArea.modified = false
                        showPassiveNotification(i18n("File opened: %1", filePath.split('/').pop()))
                    } else {
                        // Otherwise, open in new instance
                        fileIO.openInNewInstance(filePath)
                        showPassiveNotification(i18n("Opening in new window..."))
                    }
                }
            }
            
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
                        border.color: dropArea.containsDrag ? Kirigami.Theme.highlightColor : "transparent"
                        border.width: dropArea.containsDrag ? 2 : 0
                        
                        // Visual feedback for drag over
                        Rectangle {
                            anchors.fill: parent
                            color: Kirigami.Theme.highlightColor
                            opacity: dropArea.containsDrag ? 0.1 : 0
                            
                            Behavior on opacity {
                                NumberAnimation { duration: 150 }
                            }
                        }
                    }
                    
                    onTextChanged: {
                        if (text !== "" && !modified) {
                            modified = true
                        }
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
