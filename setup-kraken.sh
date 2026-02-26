#!/bin/bash

set -e

# ─── Help ────────────────────────────────────────────────────────────────────
if [[ $1 == "--help" || $1 == "-h" ]]; then
    echo "Usage: $0 [--system]"
    echo ""
    echo "  (no flag)   Install for current user only (default)"
    echo "  --system    Install system-wide (requires sudo)"
    exit 0
fi

# ─── Root check for system install ───────────────────────────────────────────
if [[ $1 == "--system" && $EUID -ne 0 ]]; then
    echo "Error: System-wide installation requires root privileges."
    echo "Please run: sudo $0 --system"
    exit 1
fi

# ─── Dependency checks ───────────────────────────────────────────────────────
for cmd in xdg-mime update-desktop-database; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: '$cmd' is not installed. Please install xdg-utils first."
        echo "  Ubuntu/Debian: sudo apt install xdg-utils"
        echo "  Fedora/RHEL:   sudo dnf install xdg-utils"
        echo "  Arch:          sudo pacman -S xdg-utils"
        exit 1
    fi
done

# ─── Check binary exists ─────────────────────────────────────────────────────
if [[ ! -f "./kraken_desktop" ]]; then
    echo "Error: 'kraken_desktop' binary not found in current directory."
    echo "Please download it from https://www.kraken.com/desktop and place it here."
    exit 1
fi

# ─── Set paths based on install type ─────────────────────────────────────────
if [[ $1 == "--system" ]]; then
    INSTALL_PATH="/usr/bin"
    DESKTOP_FILE_PATH="/usr/share/applications"
    ICON_PATH="/usr/share/icons/hicolor/256x256/apps"
else
    INSTALL_PATH="$HOME/.local/bin"
    DESKTOP_FILE_PATH="$HOME/.local/share/applications"
    ICON_PATH="$HOME/.local/share/icons/hicolor/256x256/apps"
fi

# ─── Create directories ───────────────────────────────────────────────────────
mkdir -p "$INSTALL_PATH" "$DESKTOP_FILE_PATH" "$ICON_PATH"

# ─── Copy binary ─────────────────────────────────────────────────────────────
echo "→ Copying kraken_desktop to $INSTALL_PATH"
cp kraken_desktop "$INSTALL_PATH/"
chmod +x "$INSTALL_PATH/kraken_desktop"

# ─── Copy icon if available ───────────────────────────────────────────────────
if [[ -f "./kraken.png" ]]; then
    echo "→ Copying icon to $ICON_PATH"
    cp kraken.png "$ICON_PATH/kraken.png"
    ICON_VALUE="kraken"
else
    echo "⚠ No icon file (kraken.png) found — launcher icon will be generic."
    ICON_VALUE="application-x-executable"
fi

# ─── Create .desktop file ────────────────────────────────────────────────────
echo "→ Creating desktop entry at $DESKTOP_FILE_PATH/kraken.desktop"
cat > "$DESKTOP_FILE_PATH/kraken.desktop" << EOL
[Desktop Entry]
Version=1.0
Name=Kraken Desktop
GenericName=Crypto Exchange
Comment=Trade cryptocurrencies on Kraken
Exec=$INSTALL_PATH/kraken_desktop %u
Icon=$ICON_VALUE
Type=Application
Terminal=false
Categories=Finance;Network;
MimeType=x-scheme-handler/kraken;
StartupNotify=true
StartupWMClass=kraken_desktop
Keywords=crypto;bitcoin;trading;exchange;kraken;
EOL

# ─── Update database & register handler ──────────────────────────────────────
echo "→ Updating desktop database"
update-desktop-database "$DESKTOP_FILE_PATH"

echo "→ Registering kraken:// URL handler"
xdg-mime default kraken.desktop x-scheme-handler/kraken

# ─── Validate desktop file if tool is available ───────────────────────────────
if command -v desktop-file-validate &>/dev/null; then
    desktop-file-validate "$DESKTOP_FILE_PATH/kraken.desktop" \
        && echo "→ Desktop file validated ✓" \
        || echo "⚠ Desktop file validation warning (non-fatal)"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "✓ Installation complete!"
echo "  Binary:  $INSTALL_PATH/kraken_desktop"
echo "  Desktop: $DESKTOP_FILE_PATH/kraken.desktop"
echo ""
echo "  You may need to log out and back in for the launcher to show the app."
echo "  To test the URL handler: xdg-open \"kraken://test\""
