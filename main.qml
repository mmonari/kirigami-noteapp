import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.syntaxhighlighting 1.0

Kirigami.ApplicationWindow {
    id: root
    
    title: (currentFile ? currentFile.split('/').pop() : i18n("Untitled")) + (textArea.modified ? " *" : "") + " - " + i18n("Kirigami NoteApp")
    
    width: 800
    height: 600
    
    property string currentFile: ""
    property bool hasFile: currentFile !== ""
    property string currentSyntax: "None"
    
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
                textArea.isLoadingFile = true
                textArea.text = content
                // Auto-detect syntax
                currentSyntax = fileIO.detectSyntax(initialFile)
                // Reset modified state after syntax highlighting is applied
                Qt.callLater(function() {
                    textArea.modified = false
                    textArea.isLoadingFile = false
                })
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
            textArea.isLoadingFile = true
            textArea.text = fileIO.read(path)
            // Auto-detect syntax
            currentSyntax = fileIO.detectSyntax(path)
            // Reset modified state after syntax highlighting is applied
            Qt.callLater(function() {
                textArea.modified = false
                textArea.isLoadingFile = false
            })
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
                currentSyntax = "None"
            } else {
                saveDialogBeforeNew.open()
            }
        }
        
        onDiscarded: {
            // Discard button clicked
            currentFile = ""
            textArea.text = ""
            textArea.modified = false
            currentSyntax = "None"
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
            currentSyntax = "None"
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
                        currentSyntax = "None"
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
            title: i18n("Syntax")
            
            Controls.Action {
                text: i18n("Auto-detect from File")
                icon.name: "edit-find"
                enabled: hasFile
                onTriggered: {
                    if (hasFile) {
                        currentSyntax = fileIO.detectSyntax(currentFile)
                        showPassiveNotification(i18n("Syntax set to: %1", currentSyntax))
                    }
                }
            }
            
            Controls.Action {
                text: i18n("Plain Text")
                icon.name: "text-plain"
                onTriggered: {
                    currentSyntax = "None"
                    showPassiveNotification(i18n("Syntax highlighting disabled"))
                }
            }
            
            Controls.MenuSeparator {}
            
            Controls.Menu {
                title: i18n("Select Syntax...")
                
                Repeater {
                    model: Repository.definitions
                    
                    Controls.MenuItem {
                        text: modelData.translatedSection + " / " + modelData.translatedName
                        onTriggered: {
                            currentSyntax = modelData.name
                            showPassiveNotification(i18n("Syntax set to: %1", modelData.name))
                        }
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
                        textArea.isLoadingFile = true
                        textArea.text = fileIO.read(filePath)
                        // Auto-detect syntax
                        currentSyntax = fileIO.detectSyntax(filePath)
                        // Reset modified state after syntax highlighting is applied
                        Qt.callLater(function() {
                            textArea.modified = false
                            textArea.isLoadingFile = false
                        })
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
                    property bool isLoadingFile: false
                    
                    focus: true
                    font.family: "Monospace"
                    font.pointSize: 11
                    wrapMode: TextEdit.Wrap
                    selectByMouse: true
                    persistentSelection: true
                    
                    // Syntax highlighting
                    SyntaxHighlighter {
                        id: syntaxHighlighter
                        textEdit: textArea
                        definition: currentSyntax
                        // Use proper theme based on background brightness
                        theme: {
                            // Check if background is dark by comparing luminance
                            var bg = Kirigami.Theme.backgroundColor
                            var luminance = 0.299 * bg.r + 0.587 * bg.g + 0.114 * bg.b
                            
                            if (luminance < 0.5) {
                                // Dark background - try specific dark themes
                                var breezeDark = Repository.theme("Breeze Dark")
                                if (breezeDark.isValid()) {
                                    return breezeDark
                                }
                                return Repository.defaultTheme(Repository.DarkTheme)
                            } else {
                                // Light background
                                var breezeLight = Repository.theme("Breeze Light")
                                if (breezeLight.isValid()) {
                                    return breezeLight
                                }
                                return Repository.defaultTheme(Repository.LightTheme)
                            }
                        }
                    }
                    
                    background: Rectangle {
                        // Keep Kirigami dark background, don't use syntax theme's background
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
                        // Only mark as modified if we're not loading a file and text is not empty
                        if (!isLoadingFile && text !== "" && !modified) {
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
                anchors.centerIn: parent
                anchors.verticalCenter: parent.verticalCenter
                text: i18n("Syntax: %1", currentSyntax === "None" ? i18n("Plain Text") : currentSyntax)
                font: Kirigami.Theme.smallFont
                color: Kirigami.Theme.textColor
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
