# Kirigami NoteApp - Quick Start Guide

## 🚀 Running the App (30 seconds)

```bash
cd /home/m0u/Projects/Research/kirigami-noteapp
make run
```

That's it! The app will build and launch.

## ⚡ Basic Usage

### Creating a New Note
1. Click **New** (or press `Ctrl+N`)
2. Start typing in the text area

### Opening a File
1. Click **Open** (or press `Ctrl+O`)
2. Select a text file from the file dialog

### Saving Your Work
1. Click **Save** (or press `Ctrl+S`)
   - If the file hasn't been saved before, you'll be prompted for a filename
   - If the file exists, it will save immediately

### Save As
1. Click the menu (hamburger icon, top left)
2. Select **Save As...** (or press `Ctrl+Shift+S`)
3. Choose a new filename and location

## 📝 Features

- **Word Wrap** - Text automatically wraps to fit the window
- **Status Bar** - Shows line count, character count, and save status
- **Modified Indicator** - Asterisk (*) in title bar when file has unsaved changes
- **Keyboard Shortcuts** - Standard shortcuts work (Ctrl+N, Ctrl+O, Ctrl+S, Ctrl+Q)
- **Text Selection** - Click and drag to select text, supports copy/paste

## 🛠️ Build Commands

```bash
make build   # Build only
make run     # Build and run
make clean   # Clean build files
make rebuild # Clean and rebuild
```

Or use the scripts:
```bash
./build.sh   # Build and run
./run.sh     # Run without rebuilding
```

## 💡 Tips

- The app uses monospace font by default (good for code)
- Files are opened/saved with UTF-8 encoding
- The status bar updates in real-time as you type
- Unsaved changes are clearly marked in the status bar

## 🎯 Next Steps

- Try opening and editing text files
- Experiment with keyboard shortcuts
- Check the hamburger menu for additional options
- Customize the QML file to change appearance

Enjoy your minimal notepad! ✨
