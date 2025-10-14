# MIME Type Support in Kirigami NoteApp

This document describes the comprehensive MIME type support implemented in NoteApp for handling text-based files on KDE Linux systems.

## Overview

NoteApp uses Qt's `QMimeDatabase` API for intelligent file type detection, supporting all standard text-based MIME types available in a KDE Linux environment. This ensures proper handling of various text file formats beyond simple `.txt` files.

## Detection Method

The application uses a multi-layered approach for detecting text files:

1. **Primary Check**: Files with MIME types starting with `text/` (e.g., `text/plain`, `text/markdown`, `text/x-cmake`)
2. **Application MIME Types**: Specific application MIME types that are text-based (e.g., `application/json`, `application/x-yaml`)
3. **Inheritance Check**: Files whose MIME type inherits from `text/plain`
4. **Fallback**: Files with MIME type names containing "text"

## Supported MIME Types

### Standard Text Types
- `text/plain` - Plain text files
- `text/x-readme` - README files
- `text/x-log` - Log files
- `text/x-changelog` - Changelog files
- `text/x-authors` - Authors files
- `text/x-install` - Installation instructions
- `text/x-copying` - License files
- `text/x-credits` - Credits files

### Markdown & Documentation
- `text/markdown` - Markdown files
- `text/x-markdown` - Alternative markdown MIME type

### Programming Languages
- `text/x-c` - C source files
- `text/x-c++` - C++ source files
- `text/x-c++hdr` - C++ header files
- `text/x-c++src` - C++ source files
- `text/x-chdr` - C header files
- `text/x-csrc` - C source files
- `text/x-java` - Java source files
- `text/x-python` - Python files
- `text/x-python3` - Python 3 files
- `text/x-perl` - Perl scripts
- `text/x-ruby` - Ruby scripts
- `text/javascript` - JavaScript files
- `text/x-qml` - QML files

### Shell Scripts
- `text/x-shellscript` - Shell scripts
- `text/x-sh` - Shell scripts
- `text/x-bash` - Bash scripts
- `text/x-zsh` - Zsh scripts
- `application/x-shellscript` - Shell scripts (application type)

### Web Technologies
- `text/html` - HTML files
- `text/css` - CSS stylesheets
- `application/xhtml+xml` - XHTML files
- `application/javascript` - JavaScript files

### Data Formats
- `application/json` - JSON files
- `application/x-yaml` - YAML files
- `application/yaml` - YAML files (alternative)
- `application/xml` - XML files
- `text/xml` - XML files (text type)
- `application/x-docbook+xml` - DocBook XML
- `application/toml` - TOML configuration files

### Build Systems & Configuration
- `text/x-cmake` - CMake files
- `text/x-makefile` - Makefiles
- `text/x-tex` - LaTeX files
- `application/x-desktop` - Desktop entry files
- `application/x-config` - Configuration files

### Patches & Diffs
- `text/x-patch` - Patch files
- `text/x-diff` - Diff files

## Implementation Details

### C++ Backend (main.cpp)

The `FileIO` class provides three MIME-related methods:

```cpp
Q_INVOKABLE bool isTextFile(const QString &filePath)
```
Determines if a file is text-based and can be opened by NoteApp.

```cpp
Q_INVOKABLE QString getMimeType(const QString &filePath)
```
Returns the MIME type string for a file (e.g., "application/json").

```cpp
Q_INVOKABLE QString getMimeTypeComment(const QString &filePath)
```
Returns a human-readable description of the file type.

### Desktop Integration

The `NoteApp.desktop` file declares all supported MIME types in the `MimeType=` field, allowing the application to:
- Appear in "Open With" dialogs for supported file types
- Be set as the default application for text files
- Handle files opened from the file manager
- Accept drag-and-drop of supported files

## File Association

After installation, the application will:
1. Register with the desktop environment via the `.desktop` file
2. Update the desktop database to recognize file associations
3. Update the MIME database for proper type detection
4. Allow opening files via:
   - Command line: `kirigami-noteapp filename.txt`
   - Desktop parameter: `%f` in Exec field
   - Drag and drop into the application window
   - "Open With" context menu in file managers

## Testing MIME Detection

Use the included test script to verify MIME type detection:

```bash
./test-mime-detection.sh
```

This creates sample files for various MIME types in `/tmp/noteapp-mime-test/` and shows how they are detected by the system.

To test with the application:
```bash
./build/kirigami-noteapp /tmp/noteapp-mime-test/test.json
```

## Debugging

When opening files, the application logs MIME type information to the console:
```
MIME type for /path/to/file.json : application/json
```

This helps verify that files are being detected correctly by Qt's MIME database.

## Adding New MIME Types

To support additional MIME types:

1. Add the MIME type to the list in `main.cpp` (if it's an application/* type):
   ```cpp
   QStringList textBasedMimeTypes = {
       // ... existing types ...
       "application/your-new-type",
   };
   ```

2. Add the MIME type to `NoteApp.desktop`:
   ```
   MimeType=text/plain;...;application/your-new-type;
   ```

3. Rebuild and reinstall the application.

## References

- Qt QMimeDatabase documentation: `.doc/qt6.md`
- Desktop Entry Specification: https://specifications.freedesktop.org/desktop-entry-spec/
- Shared MIME Info Specification: https://specifications.freedesktop.org/shared-mime-info-spec/

## Compatibility

- Requires Qt 6.5 or later (for QMimeDatabase API)
- Tested on KDE Plasma with standard MIME database
- Works with any freedesktop.org-compliant desktop environment
