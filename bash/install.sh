#!/bin/bash
echo "🚀 Bootstrapping Bash..."

# Generate a timestamp for a unique backup name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET="$HOME/.bashrc"
SOURCE="$HOME/dotfiles/bash/.bashrc"

# Check if a regular file exists (and is NOT a symlink)
if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "📦 Backing up existing .bashrc to .bashrc.backup_$TIMESTAMP..."
    mv "$TARGET" "$TARGET.backup_$TIMESTAMP"
# Check if it's already a symlink
elif [ -L "$TARGET" ]; then
    echo "♻️  Removing old symlink..."
    rm "$TARGET"
fi

echo "🔗 Symlinking new .bashrc..."
ln -s "$SOURCE" "$TARGET"

echo "✅ Bash setup complete!"
