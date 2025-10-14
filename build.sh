#!/bin/bash

# Kirigami Notepad - Build Script
# This script builds and runs the application

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PROJECT_DIR/build"

echo "🔨 Building Kirigami Notepad..."

# Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure with CMake
echo "⚙️  Configuring..."
cmake ..

# Build
echo "🛠️  Compiling..."
make -j$(nproc)

echo "✅ Build successful!"
echo ""
echo "🚀 Running application..."
./kirigami-notepad
