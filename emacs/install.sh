#!/bin/bash
echo "🚀 Bootstrapping Emacs..."

# 6. Safely backup and symlink Emacs config
echo "🔗 Symlinking .emacs..."
if [ -f ~/.emacs ]; then
    mv ~/.emacs ~/.emacs.backup
    echo "   (Backed up existing .emacs)"
fi
ln -sf ~/dotfiles/emacs/.emacs ~/.emacs

echo "✅ Emacs setup complete!"
