#!/bin/bash

echo "🔤 Bootstrapping Tmux Font Dependencies..."

# Set the correct font directory based on the OS
if [ "$(uname)" == "Darwin" ]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi

# Create the directory if it doesn't exist
mkdir -p "$FONT_DIR"

# Check if the font is already installed
if ls "$FONT_DIR"/HackNerdFont* 1> /dev/null 2>&1; then
    echo "✅ Hack Nerd Font is already securely installed."
else
    echo "📥 Downloading Hack Nerd Font..."
    ZIP_FILE="/tmp/Hack.zip"

    # Download the latest release from the official Nerd Fonts repo
    curl -fLo "$ZIP_FILE" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"

    echo "📦 Extracting to $FONT_DIR..."
    unzip -q -o "$ZIP_FILE" -d "$FONT_DIR"
    rm "$ZIP_FILE"

    # Rebuild the font cache on Linux so the system sees it immediately
    if command -v fc-cache &> /dev/null; then
        echo "🔄 Updating system font cache..."
        fc-cache -f "$FONT_DIR"
    fi

    echo "🎉 Hack Nerd Font installed!"
    echo "========================================================="
    echo "⚠️  IMPORTANT POST-INSTALL STEPS:"
    echo "1. If you are using GNOME Terminal, you may need to restart the terminal server"
    echo "   to see the font. Run this command (Warning: closes all terminal windows!):"
    echo "   `killall gnome-terminal-server`"
    echo "2. Open your Terminal Preferences and set the font to 'Hack Nerd Font Mono'."
    echo "========================================================="
fi
