#!/bin/bash

echo "🚀 Bootstrapping Tmux Environment..."

# 1. Create the base hidden directory just in case
mkdir -p ~/.tmux

# 2. Safely backup and symlink the main config
echo "🔗 Symlinking .tmux.conf..."
if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.backup
    echo "   (Backed up existing .tmux.conf)"
fi
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

# 3. Safely backup and symlink the themes folder
echo "🎨 Symlinking themes..."
if [ -d ~/.tmux/themes ]; then
    mv ~/.tmux/themes ~/.tmux/themes.backup
    echo "   (Backed up existing themes folder)"
fi
ln -s ~/dotfiles/.tmux/themes ~/.tmux/themes

# 4. Download Tmux Plugin Manager (TPM)
if [ ! -d "/home/tasos/.tmux/plugins/tpm" ]; then
    echo "📦 Downloading Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "✅ TPM is already installed."
fi

echo "🎉 All done! Start tmux and press [Prefix + Shift + I] to load your plugins."
