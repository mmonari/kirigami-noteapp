#!/bin/bash

# Test script to verify MIME type detection
# This tests various text file formats that should be supported

echo "🧪 Testing MIME Type Detection for NoteApp"
echo "==========================================="
echo ""

# Create test directory
TEST_DIR="/tmp/noteapp-mime-test"
mkdir -p "$TEST_DIR"

# Create test files for different MIME types
echo "Creating test files..."

# text/plain variants
echo "Plain text file" > "$TEST_DIR/test.txt"
echo "# README" > "$TEST_DIR/README"
echo "Log entry" > "$TEST_DIR/test.log"

# text/markdown
echo "# Markdown Test" > "$TEST_DIR/test.md"

# text/x-cmake
echo "cmake_minimum_required(VERSION 3.0)" > "$TEST_DIR/CMakeLists.txt"

# application/json
echo '{"test": "value"}' > "$TEST_DIR/test.json"

# application/x-yaml
cat > "$TEST_DIR/test.yaml" << 'EOF'
name: test
value: 123
EOF

cat > "$TEST_DIR/test.yml" << 'EOF'
name: test
value: 456
EOF

# application/x-docbook+xml
cat > "$TEST_DIR/test.docbook" << 'EOF'
<?xml version="1.0"?>
<book>
  <title>Test</title>
</book>
EOF

# application/xml
cat > "$TEST_DIR/test.xml" << 'EOF'
<?xml version="1.0"?>
<root>
  <element>Test</element>
</root>
EOF

# text/x-python
cat > "$TEST_DIR/test.py" << 'EOF'
#!/usr/bin/env python3
print("Hello World")
EOF

# text/x-shellscript
cat > "$TEST_DIR/test.sh" << 'EOF'
#!/bin/bash
echo "Hello World"
EOF

# text/x-c++src
cat > "$TEST_DIR/test.cpp" << 'EOF'
#include <iostream>
int main() { return 0; }
EOF

# text/x-qml
cat > "$TEST_DIR/test.qml" << 'EOF'
import QtQuick
Item {}
EOF

echo ""
echo "Test files created in: $TEST_DIR"
echo ""
echo "Testing with 'file' command (shows MIME types):"
echo "------------------------------------------------"

for f in "$TEST_DIR"/*; do
    basename=$(basename "$f")
    mimetype=$(file --mime-type -b "$f")
    printf "%-25s -> %s\n" "$basename" "$mimetype"
done

echo ""
echo "You can now test these files with NoteApp:"
echo "1. Open any file from: $TEST_DIR"
echo "2. Or drag and drop them into the application"
echo "3. Check the console output for MIME type detection"
echo ""
echo "To open a specific test file:"
echo "  ./build/kirigami-noteapp $TEST_DIR/test.json"
echo ""
