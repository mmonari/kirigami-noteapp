#!/bin/bash

# Kirigami NoteApp - Local Installation Script
# Installs to ~/.local/share/kirigami-noteapp/

set -e

echo "📦 Installing Kirigami NoteApp locally..."

# Build first
echo "🔨 Building..."
make build

# Create installation directory
INSTALL_DIR="$HOME/.local/share/kirigami-noteapp"
mkdir -p "$INSTALL_DIR"
mkdir -p "$HOME/.local/share/applications"

# Copy files
echo "📋 Copying files to $INSTALL_DIR..."
cp build/kirigami-noteapp "$INSTALL_DIR/"
cp build/main.qml "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/kirigami-noteapp"

# Create desktop entry
echo "🖥️  Creating desktop entry..."
cat > "$HOME/.local/share/applications/NoteApp.desktop" << EOF
[Desktop Entry]
Exec=$HOME/.local/share/kirigami-noteapp/kirigami-noteapp %f
Name=NoteApp
GenericName=Text Editor
Comment=A lightweight text editor for KDE
Path=$HOME/.local/share/kirigami-noteapp/
Icon=text-editor
Terminal=false
Type=Application
Categories=Qt;KDE;Utility;TextEditor;
Keywords=text;editor;notepad;markdown;code;
MimeType=text/plain;text/x-readme;text/x-log;text/x-changelog;text/x-authors;text/x-install;text/x-copying;text/x-credits;text/markdown;text/x-markdown;text/x-cmake;text/x-c;text/x-c++;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-python;text/x-python3;text/x-perl;text/x-ruby;text/x-shellscript;text/x-sh;text/x-bash;text/x-zsh;text/html;text/css;text/javascript;text/x-qml;text/xml;text/x-tex;text/x-makefile;text/x-cmake;text/x-patch;text/x-diff;application/json;application/x-yaml;application/yaml;application/xml;application/x-docbook+xml;application/xhtml+xml;application/javascript;application/x-shellscript;application/x-desktop;application/x-config;application/toml;
EOF

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    echo "🔄 Updating desktop database..."
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

# Update MIME database (so file associations work properly)
if command -v update-mime-database &> /dev/null; then
    echo "🔄 Updating MIME database..."
    update-mime-database "$HOME/.local/share/mime" 2>/dev/null || true
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📍 Installed to: $INSTALL_DIR"
echo "🚀 Launch from application menu: Search for 'NoteApp'"
echo "💻 Or run directly: $INSTALL_DIR/kirigami-noteapp"
echo ""
