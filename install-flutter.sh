#!/bin/bash
# install-flutter.sh - Robust Flutter SDK installation for Ubuntu/Debian

set -e

TARGET_DIR="$HOME/flutter"
EXPECTED_BIN="$TARGET_DIR/bin/flutter"

echo "🚀 Checking environment for Flutter..."

# 1. Check if Flutter is already functional in the system
EXISTING_FLUTTER=$(command -v flutter || true)

if [ -n "$EXISTING_FLUTTER" ]; then
    REAL_PATH=$(realpath "$EXISTING_FLUTTER")
    
    # Case A: It's already where we expect it
    if [[ "$REAL_PATH" == "$TARGET_DIR/"* ]]; then
        echo "✅ Flutter is already installed and functional in the expected location ($TARGET_DIR)."
        echo "💡 To update, simply run: flutter upgrade"
        exit 0
    fi

    # Case B: It's installed elsewhere (Snap or manual)
    echo "⚠️  Flutter is already installed at: $REAL_PATH"
    echo "💡 However, your dotfiles are specifically configured to use $TARGET_DIR."
    echo ""
    echo "To avoid conflicts, this script will not install a second copy."
    echo "Choose one of these paths to align your system with your dotfiles:"
    echo "  1. Symlink your existing installation: ln -s $(dirname $(dirname "$REAL_PATH")) $TARGET_DIR"
    echo "  2. Uninstall your current version and re-run this script."
    exit 0
fi

# Case C: Folder exists but is 'garbage' or broken
if [ -d "$TARGET_DIR" ] && [ ! -x "$EXPECTED_BIN" ]; then
    echo "❌ Directory $TARGET_DIR exists, but $EXPECTED_BIN is missing or not executable."
    echo "💡 This looks like a broken installation. Please run: rm -rf $TARGET_DIR"
    echo "   Then re-run this script for a clean installation."
    exit 1
fi

# 2. Proceed with Clean Installation
echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y \
    curl file git unzip xz-utils zip libglu1-mesa \
    clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev g++

echo "📥 Cloning Flutter SDK (stable branch) to $TARGET_DIR..."
git clone https://github.com/flutter/flutter.git -b stable "$TARGET_DIR"

echo "⚙️  Pre-downloading development binaries..."
"$EXPECTED_BIN" precache

echo "🩺 Running flutter doctor..."
"$EXPECTED_BIN" doctor

echo ""
echo "✅ Flutter installation complete!"
echo "💡 IMPORTANT: Run 'source ~/.bashrc' or restart your terminal to use 'flutter' globally."
