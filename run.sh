#!/bin/bash

# Kirigami NoteApp - Quick Run Script
# Runs without rebuilding

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PROJECT_DIR/build"

if [ ! -f "$BUILD_DIR/kirigami-notepad" ]; then
    echo "❌ Binary not found. Run 'make build' first."
    exit 1
fi

echo "🚀 Running Kirigami NoteApp..."
cd "$BUILD_DIR" && ./kirigami-notepad
