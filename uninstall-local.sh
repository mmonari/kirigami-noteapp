#!/bin/bash

# Kirigami Notepad - Uninstall Script
# Removes local installation

set -e

echo "🗑️  Uninstalling Kirigami Notepad..."

INSTALL_DIR="$HOME/.local/share/kirigami-notepad"
DESKTOP_FILE="$HOME/.local/share/applications/NoteApp.desktop"

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    echo "📁 Removing $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
else
    echo "⚠️  Installation directory not found: $INSTALL_DIR"
fi

# Remove desktop entry
if [ -f "$DESKTOP_FILE" ]; then
    echo "🖥️  Removing desktop entry..."
    rm "$DESKTOP_FILE"
else
    echo "⚠️  Desktop entry not found: $DESKTOP_FILE"
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    echo "🔄 Updating desktop database..."
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo ""
echo "✅ Uninstall complete!"
echo ""
