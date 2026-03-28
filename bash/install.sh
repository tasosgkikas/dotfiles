#!/bin/bash
echo "🚀 Bootstrapping Bash..."

# Generate a timestamp for a unique backup name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET="$HOME/.bashrc"
SOURCE="$HOME/dotfiles/bash/.bashrc"

# Safely backup and symlink the main config
if [ -L "$TARGET" ]; then
    echo "♻️  Removing old symlink..."
    rm "$TARGET"
elif [ -f "$TARGET" ]; then
    echo "📦 Backing up existing .bashrc to .bashrc.backup_$TIMESTAMP..."
    mv "$TARGET" "$TARGET.backup_$TIMESTAMP"
fi

echo "🔗 Symlinking new .bashrc..."
ln -s "$SOURCE" "$TARGET"

echo "✅ Bash setup complete!"
