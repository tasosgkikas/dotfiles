#!/bin/bash

echo "🚀 Bootstrapping Emacs Environment..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# ==========================================
# PATH DEFINITIONS
# ==========================================
# Get the absolute path of the dotfiles directory relative to this script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$DOTFILES_DIR/emacs/.emacs"
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

echo "📦 Installing Emacs packages..."
# Ensure packages are installed without opening the UI
emacs --batch --eval "(package-initialize)" --eval "(package-install-selected-packages)"

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

# Check for clojure-lsp (Clojure language server) and install if missing
if command -v clojure-lsp &> /dev/null; then
    echo "✅ clojure-lsp is already installed."
else
    echo "🔍 clojure-lsp not found. Installing the Clojure language server..."
    TEMP_INSTALLER=$(mktemp /tmp/clojure-lsp-install.XXXXXX)
    if curl -sLo "$TEMP_INSTALLER" https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install; then
        chmod +x "$TEMP_INSTALLER"
        if sudo "$TEMP_INSTALLER"; then
            if command -v clojure-lsp &> /dev/null; then
                echo "✅ clojure-lsp installed successfully."
            else
                echo "❌ clojure-lsp installation finished but binary not found in PATH."
            fi
        else
            echo "❌ sudo installation of clojure-lsp failed."
        fi
    else
        echo "❌ Failed to download clojure-lsp installer."
    fi
    rm -f "$TEMP_INSTALLER"
fi

# Check for Flutter (SDK) and suggest installation if missing
if command -v flutter &> /dev/null; then
    echo "✅ flutter is already installed."
else
    echo "🔍 flutter not found."
    echo "💡 To install the Flutter SDK, run: $DOTFILES_DIR/install-flutter.sh"
fi

echo "✅ Emacs setup complete!"
