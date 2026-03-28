# 🚀 Tasos' Dotfiles

A modular, idempotent, and self-healing dotfiles architecture for Bash, Tmux, and Emacs. 

This repository is designed to be instantly deployable on any new machine (macOS, Linux, or Docker containers) without destroying existing configurations. It uses a "Data-Driven" local override system, meaning you can customize settings per-machine without ever tracking secrets or machine-specific tweaks in Git.

## 🏗️ Architecture Philosophy
* **Non-Destructive:** Installers will explicitly detect existing files/symlinks and create timestamped backups (e.g., `.emacs.backup_20260328_105201`) before applying new symlinks.
* **Idempotent:** You can run the install scripts 100 times safely. They self-correct and heal broken symlinks automatically.
* **Local Overrides:** Every tool supports a `.local` file (e.g., `~/.tmux.conf.local`) loaded at the very end of the execution chain. This allows for machine-specific font sizes, API keys, and paths that are ignored by Git.

---

## 📦 Installation

**1. Clone the repository:**
\`\`\`bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
\`\`\`

**2. Run the modular installers:**
You can install everything, or just the tools you need for a specific environment.
\`\`\`bash
./bash/install.sh
./tmux/install.sh
./emacs/install.sh
\`\`\`

---

## ⚠️ Post-Installation Steps

### 1. Terminal Font (Required for Tmux Dracula Theme)
The Tmux installer includes a script that downloads the **Hack Nerd Font** to your system. You must manually tell your terminal emulator to use it so the powerline separators (angled widgets) render correctly.

* Open your Terminal Preferences.
* Navigate to the Font selection screen.
* Uncheck "Show only monospace fonts" (if applicable).
* Select `Hack Nerd Font`.

> **Troubleshooting (Linux):** If the font does not appear in your dropdown menu after running the script, your terminal server is likely caching the old font list. Close your work, open a single terminal, and run:
> \`killall gnome-terminal-server\`

### 2. Tmux Plugins
After starting Tmux for the first time, press \`Prefix + Shift + I\` (capital i) to fetch and load the TPM plugins and themes.

---

## 🛠️ How to use Local Overrides

Do not edit the tracked dotfiles to make machine-specific changes (like adjusting font size for a 4K monitor or setting a work email). Instead, create a local override file in your home directory. These files are git-ignored by default.

### Emacs (\`~/.emacs.local\`)
Created locally to override themes, fonts, or store API keys. 
\`\`\`elisp
;; Example ~/.emacs.local
(set-face-attribute 'default nil :height 160) ;; Larger font for 4K display
(load-theme 'dracula t)                       ;; Override the default zerodark theme
\`\`\`

### Tmux (\`~/.tmux.conf.local\`)
Created locally to override keybindings or add machine-specific TPM plugins before TPM initializes.
\`\`\`tmux
# Example ~/.tmux.conf.local
set -g status-position top   # Move status bar to the top on this specific laptop
\`\`\`
