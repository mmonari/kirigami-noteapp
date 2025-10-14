#!/bin/bash

# Kirigami NoteApp - Local Installation Script
# Installs to ~/.local/share/kirigami-notepad/

set -e

echo "📦 Installing Kirigami NoteApp locally..."

# Build first
echo "🔨 Building..."
make build

# Create installation directory
INSTALL_DIR="$HOME/.local/share/kirigami-notepad"
mkdir -p "$INSTALL_DIR"
mkdir -p "$HOME/.local/share/applications"

# Copy files
echo "📋 Copying files to $INSTALL_DIR..."
cp build/kirigami-notepad "$INSTALL_DIR/"
cp build/main.qml "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/kirigami-notepad"

# Create desktop entry
echo "🖥️  Creating desktop entry..."
cat > "$HOME/.local/share/applications/NoteApp.desktop" << EOF
[Desktop Entry]
Exec=$HOME/.local/share/kirigami-notepad/kirigami-notepad
Name=NoteApp
Path=$HOME/.local/share/kirigami-notepad/
Icon=text-editor
Terminal=false
Type=Application
Categories=Qt;KDE;Utility;TextEditor;
Keywords=text;editor;notepad;
EOF

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    echo "🔄 Updating desktop database..."
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📍 Installed to: $INSTALL_DIR"
echo "🚀 Launch from application menu: Search for 'NoteApp'"
echo "💻 Or run directly: $INSTALL_DIR/kirigami-notepad"
echo ""
