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

echo "✅ Emacs setup complete!"
