# Kirigami NoteApp

A minimal text editor for KDE built with Kirigami and Qt 6, inspired by Windows 7 Notepad.

![A simple text editor](assets/hello-world.png)

## Features

- **Simple Text Editing** - Clean, distraction-free text editing interface
- **File Operations** - New, Open, Save, Save As functionality
- **Status Bar** - Shows line count, character count, and file status
- **Keyboard Shortcuts** - Standard shortcuts (Ctrl+N, Ctrl+O, Ctrl+S, etc.)
- **Auto-save Indicator** - Visual feedback for unsaved changes
- **Modern KDE Design** - Uses Kirigami components for a native KDE look

## Requirements

- Qt 6.5 or later
- KDE Frameworks 6 (KF6CoreAddons, KF6I18n)
- Kirigami 6
- CMake 3.20 or later
- C++17 compatible compiler

## Building

### Quick Start

```bash
# Build and run
make run

# Or use the build script
./build.sh
```

### Manual Build

```bash
# Create build directory
mkdir build
cd build

# Configure and build
cmake ..
make -j$(nproc)

# Run
./kirigami-notepad
```

## Installation

### Local Installation (Recommended)

Install for the current user only (no sudo required):

```bash
./install-local.sh
```

This will:
- Build the application
- Install to `~/.local/share/kirigami-notepad/`
- Create a desktop entry as "NoteApp"
- Make it available in your application launcher

### Uninstall

```bash
./uninstall-local.sh
```

### System-Wide Installation

```bash
make install
```

Requires sudo. Installs for all users.

## Usage

### Keyboard Shortcuts

- **Ctrl+N** - New file
- **Ctrl+O** - Open file
- **Ctrl+S** - Save file
- **Ctrl+Shift+S** - Save as
- **Ctrl+Q** - Quit

### Menu Bar

Standard menu bar at the top with:

**File Menu:**
- New - Create a new blank document
- Open - Open an existing text file
- Save - Save the current file
- Save As - Save with a new name
- Quit - Exit the application

**Help Menu:**
- About - Application information

### Status Bar

- **Left side** - Line and character count
- **Right side** - File modification status (Modified/Saved)

## Project Structure

```
kirigami-noteapp/
├── main.cpp              - C++ application entry point (with FileIO backend)
├── main.qml              - QML UI definition
├── CMakeLists.txt        - Build configuration
├── Makefile              - Convenience build commands
├── build.sh              - Build and run script
├── run.sh                - Quick run script
├── install-local.sh      - Local installation script
├── uninstall-local.sh    - Uninstall script
└── README.md             - This file
```

## Development

Based on the Kirigami Hello World template. The application uses:

- **Qt Quick** for the UI framework
- **Kirigami** for KDE-style components
- **Qt Quick Controls** for standard UI elements
- **Qt Quick Dialogs** for file dialogs

## Notes

- Text files are saved with UTF-8 encoding
- File I/O is handled by a C++ backend (FileIO class)
- Proper error handling and file permissions

## License

This is a sample application for educational purposes.

---

**Created**: 2025-10-13 | **Platform**: KDE 6
