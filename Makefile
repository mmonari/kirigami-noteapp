# Convenience Makefile for Kirigami NoteApp
# This is a wrapper around the CMake build system

.PHONY: all build run clean rebuild install help

BUILD_DIR = build

all: build

help:
	@echo "Kirigami NoteApp - Build Commands"
	@echo ""
	@echo "  make build    - Build the application"
	@echo "  make run      - Build and run the application"
	@echo "  make clean    - Remove build directory"
	@echo "  make rebuild  - Clean and build from scratch"
	@echo "  make install  - Install to system (requires sudo)"
	@echo "  make help     - Show this help message"
	@echo ""

build:
	@mkdir -p $(BUILD_DIR)
	@cd $(BUILD_DIR) && cmake .. && make -j$$(nproc)
	@echo "✅ Build complete! Binary: $(BUILD_DIR)/kirigami-noteapp"

run: build
	@echo "🚀 Running Kirigami NoteApp..."
	@cd $(BUILD_DIR) && ./kirigami-noteapp

clean:
	@echo "🧹 Cleaning build directory..."
	@rm -rf $(BUILD_DIR)
	@echo "✅ Clean complete!"

rebuild: clean build

install: build
	@echo "📦 Installing to system..."
	@cd $(BUILD_DIR) && sudo make install
	@echo "✅ Installation complete!"
