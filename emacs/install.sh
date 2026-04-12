#!/bin/bash

echo "🚀 Bootstrapping Emacs Environment..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# ==========================================
# PATH DEFINITIONS
# ==========================================
SOURCE="$HOME/dotfiles/emacs/.emacs"
TARGET="$HOME/.emacs"
# ==========================================

# Safely backup and symlink the main config
echo "⚙️  Checking .emacs configuration..."

if [ -L "$TARGET" ]; then
    echo "   ♻️  Removing old symlink..."
    rm "$TARGET"
elif [ -f "$TARGET" ]; then
    mv "$TARGET" "$TARGET.backup_$TIMESTAMP"
    echo "   📦 Backed up existing .emacs to .emacs.backup_$TIMESTAMP"
fi

echo "   🔗 Symlinking: $SOURCE -> $TARGET"
ln -s "$SOURCE" "$TARGET"

# Check for gopls (Go language server) and install if missing
if command -v gopls &> /dev/null; then
    echo "✅ gopls is already installed."
else
    echo "🔍 gopls not found. Installing the Go language server..."
    if command -v go &> /dev/null; then
        go install golang.org/x/tools/gopls@latest
        echo "✅ gopls installed successfully."
    else
        echo "⚠️  Go not found. Please install Go to use gopls."
    fi
fi

echo "✅ Emacs setup complete!"
