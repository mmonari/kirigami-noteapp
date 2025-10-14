# Unsaved Changes Protection Feature

**Added:** 2025-10-14  
**Version:** 1.1

## Overview

The application now prevents accidental loss of unsaved changes by prompting the user before performing destructive actions.

## Feature Description

When the user attempts to perform an action that would lose unsaved changes, a confirmation dialog appears with three options:

1. **Save** - Save the changes and proceed with the action
2. **Discard** - Discard changes and proceed with the action
3. **Cancel** - Cancel the action and return to editing

## Protected Actions

The following actions now check for unsaved changes:

### 1. Quit (Ctrl+Q)
- When quitting via menu or keyboard shortcut
- When closing the window with the X button
- When closing via Alt+F4 or other system shortcuts

### 2. New File (Ctrl+N)
- When creating a new document via menu or keyboard shortcut
- Prevents losing current work when starting fresh

### 3. Open File (Ctrl+O)
- When opening another file via menu or keyboard shortcut
- Ensures current work is saved before loading a new file

## User Experience Flow

### Example: Quitting with Unsaved Changes

1. User modifies a document (asterisk `*` appears in title)
2. User attempts to quit (Ctrl+Q or File → Quit)
3. Dialog appears: "The document has been modified. Do you want to save your changes?"
4. User chooses:
   - **Save**: 
     - If file has a name: Saves immediately and quits
     - If file is untitled: Opens "Save As" dialog, then quits after saving
   - **Discard**: Quits without saving
   - **Cancel**: Returns to editing

### Example: Opening New File with Unsaved Changes

1. User has unsaved changes in current document
2. User selects File → Open (Ctrl+O)
3. Dialog appears: "The document has been modified. Do you want to save your changes before opening another file?"
4. User chooses:
   - **Save**: Saves current file, then shows file picker
   - **Discard**: Discards changes and shows file picker
   - **Cancel**: Returns to editing

## Implementation Details

### QML Components

#### 1. Window Close Handler
```qml
onClosing: (close) => {
    if (textArea.modified) {
        close.accepted = false
        quitConfirmDialog.open()
    }
}
```
Intercepts window close events and prevents closing if there are unsaved changes.

#### 2. Confirmation Dialogs
Three separate dialogs for different scenarios:
- `quitConfirmDialog` - For quit operations
- `newFileConfirmDialog` - For creating new documents
- `openFileConfirmDialog` - For opening files

Each uses Qt Quick Controls `Dialog` with standard buttons:
- `Controls.Dialog.Save`
- `Controls.Dialog.Discard`
- `Controls.Dialog.Cancel`

#### 3. Save-Before-Action Dialogs
Three file save dialogs for when the user chooses "Save" but the file is untitled:
- `saveDialogBeforeQuit`
- `saveDialogBeforeNew`
- `saveDialogBeforeOpen`

These ensure the action completes after saving.

### Dialog Responses

**onAccepted** - User clicked "Save"
- Check if file has a name
- If yes: Save and proceed
- If no: Open "Save As" dialog

**onDiscarded** - User clicked "Discard"
- Clear modified flag
- Proceed with the action

**onRejected** - User clicked "Cancel"
- Do nothing (returns to editing)

## Modified Status Tracking

The application tracks modifications using:
```qml
property bool modified: false
```

This flag is:
- Set to `true` when text content changes
- Set to `false` after successful save
- Displayed in window title with asterisk `*`
- Shown in status bar ("Modified" vs "Saved")

## Visual Indicators

### Window Title
```
filename.txt * - Kirigami NoteApp  // Modified
filename.txt - Kirigami NoteApp    // Saved
```

### Status Bar
- Right side shows: "Modified" (neutral color) or "Saved" (positive color)

## Testing Scenarios

### Test 1: Quit with Unsaved Changes
1. Open the application
2. Type some text
3. Press Ctrl+Q
4. Verify dialog appears
5. Test all three button options

### Test 2: Window Close Button
1. Open the application
2. Type some text
3. Click the window's X button
4. Verify dialog appears
5. Click "Cancel" - window should stay open

### Test 3: New File with Unsaved Changes
1. Type some text
2. Press Ctrl+N
3. Verify dialog appears
4. Click "Discard" - text should clear

### Test 4: Open File with Unsaved Changes
1. Type some text
2. Press Ctrl+O
3. Verify dialog appears
4. Click "Save" (for untitled document)
5. Verify "Save As" dialog appears

### Test 5: Save and Quit
1. Type some text
2. Press Ctrl+Q
3. Click "Save"
4. If new file: Enter filename and save
5. Verify application quits after save

### Test 6: Cancel Protection
1. Type some text
2. Try to quit
3. Click "Cancel"
4. Verify text is still there and editable

## Code Changes Summary

### main.qml Modifications

1. **Added `onClosing` handler** to `Kirigami.ApplicationWindow`
   - Intercepts window close events
   - Checks for modifications

2. **Added 3 confirmation dialogs**
   - For quit, new file, and open file operations
   - Each with Save/Discard/Cancel options

3. **Added 3 save-before-action dialogs**
   - For scenarios where user chooses "Save" on untitled documents
   - Each completes the original action after saving

4. **Updated menu actions**
   - Quit action checks for modifications before closing
   - New action checks for modifications before clearing
   - Open action checks for modifications before opening file picker

## User Benefits

1. **Prevents Data Loss** - No accidental loss of work
2. **Clear Choices** - Three explicit options for every scenario
3. **Consistent Behavior** - Same protection for all destructive actions
4. **Standards Compliance** - Follows common text editor patterns
5. **Keyboard-Friendly** - Works with all keyboard shortcuts
6. **Non-Intrusive** - Only appears when needed (when modified)

## Future Enhancements

Potential improvements:
1. Auto-save to temporary files
2. Remember user's choice per session
3. Configurable behavior in preferences
4. Backup/recovery system
5. Multiple document tabs with per-tab tracking

## Compatibility

- Works with Qt 6.5+
- Uses Qt Quick Controls 2
- Compatible with all desktop environments
- Follows Qt/KDE design patterns

## References

- Qt Quick Controls Dialog: Qt Documentation
- Window closing events: Qt QML ApplicationWindow
- Standard dialog buttons: Qt Dialog StandardButton

---

**Feature successfully implemented and tested on 2025-10-14**
