#!/bin/bash

echo "🚀 Bootstrapping Tmux Environment..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# ==========================================
# PATH DEFINITIONS
# ==========================================
DOTFILES_TMUX="$HOME/dotfiles/tmux"
TMUX_DIR="$HOME/.tmux"

TMUX_CONF_SOURCE="$DOTFILES_TMUX/.conf"
TMUX_CONF_TARGET="$HOME/.tmux.conf"

THEMES_SOURCE="$DOTFILES_TMUX/themes"
THEMES_TARGET="$TMUX_DIR/themes"
# ==========================================

# Create the base hidden directory just in case
mkdir -p "$TMUX_DIR"

# Safely backup and symlink the main config
echo "⚙️  Checking .tmux.conf..."
if [ -L "$TMUX_CONF_TARGET" ]; then
    echo "   ♻️  Removing old symlink..."
    rm "$TMUX_CONF_TARGET"
elif [ -f "$TMUX_CONF_TARGET" ]; then
    mv "$TMUX_CONF_TARGET" "$TMUX_CONF_TARGET.backup_$TIMESTAMP"
    echo "   📦 Backed up existing .tmux.conf to .tmux.conf.backup_$TIMESTAMP"
fi
echo "   🔗 Symlinking: $TMUX_CONF_SOURCE -> $TMUX_CONF_TARGET"
ln -s "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET"

# Safely backup and symlink the themes folder
echo "🎨 Checking themes folder..."
if [ -L "$THEMES_TARGET" ]; then
    echo "   ♻️  Removing old themes symlink..."
    rm "$THEMES_TARGET"
elif [ -d "$THEMES_TARGET" ]; then
    mv "$THEMES_TARGET" "$THEMES_TARGET.backup_$TIMESTAMP"
    echo "   📦 Backed up existing themes folder to themes.backup_$TIMESTAMP"
fi
echo "   🔗 Symlinking: $THEMES_SOURCE -> $THEMES_TARGET"
ln -s "$THEMES_SOURCE" "$THEMES_TARGET"

# Safely clones a repo, prompting the user if it finds a corrupted directory
safe_clone() {
    local repo_url="$1"
    local target_dir="$2"
    local check_file="$3"
    local name="$4"

    # 1. If the directory doesn't exist at all, just install it cleanly
    if [ ! -d "$target_dir" ]; then
        echo "📦 Downloading $name..."
        git clone "$repo_url" "$target_dir"

    # 2. If the directory exists but the core file is missing, prompt the user!
    elif [ ! -f "$target_dir/$check_file" ]; then
        echo "⚠️  WARNING: The directory for $name exists, but it seems corrupted or empty."
        echo "   (Missing required file: $check_file)"
        read -p "   Do you want to nuke it and reinstall? [y/N]: " confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "🗑️  Nuking corrupted directory..."
            rm -rf "$target_dir"
            echo "📦 Reinstalling $name..."
            git clone "$repo_url" "$target_dir"
        else
            echo "⏭️  Skipping $name. (Warning: Tmux might fail to load this!)"
        fi

    # 3. Everything is healthy
    else
        echo "✅ $name is securely installed."
    fi
}

# Download TPM and Themes
safe_clone "https://github.com/tmux-plugins/tpm" "$TMUX_DIR/plugins/tpm" "tpm" "Tmux Plugin Manager"
safe_clone "https://github.com/dracula/tmux" "$THEMES_TARGET/dracula" "dracula.tmux" "Dracula Theme"
safe_clone "https://github.com/catppuccin/tmux" "$THEMES_TARGET/catppuccin" "catppuccin.tmux" "Catppuccin Theme"

# Install font dependencies
# Required for powerline's angled widget dividers of dracula status bar theme
"$DOTFILES_TMUX/install-hack-nerd-font.sh"

echo "🎉 Tmux setup complete! Start tmux and load your plugins with [Prefix + Shift-i]."
