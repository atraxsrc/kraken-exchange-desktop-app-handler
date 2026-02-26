# Troubleshooting Kraken Desktop URL Handler

This guide covers common issues with `kraken://` URL handling across different Linux distributions.

## Distribution-Specific Solutions

### Ubuntu/Debian
```bash
# Check if xdg-utils is installed
dpkg -l | grep xdg-utils

# Install if missing
sudo apt update
sudo apt install xdg-utils

# Verify MIME type handler
xdg-mime query default x-scheme-handler/kraken

# Reset MIME association if needed
xdg-mime default kraken.desktop x-scheme-handler/kraken

# Verify desktop file location and permissions
ls -l ~/.local/share/applications/kraken.desktop
# or
ls -l /usr/share/applications/kraken.desktop
```

### Fedora/RHEL
```bash
# Check if xdg-utils is installed
rpm -qa | grep xdg-utils

# Install if missing
sudo dnf install xdg-utils

# Additional step: might need to install mime-support
sudo dnf install shared-mime-info
```

### Arch Linux
```bash
# Check if xdg-utils is installed
pacman -Qs xdg-utils

# Install if missing
sudo pacman -S xdg-utils

# If using KDE, might need
sudo pacman -S perl-file-mimeinfo
```

## Common Issues and Solutions

### 1. URLs Not Opening in Kraken Desktop

#### Check URL Handler Registration
```bash
# Should return "kraken.desktop"
xdg-mime query default x-scheme-handler/kraken
```

If incorrect or empty, re-register:
```bash
xdg-mime default kraken.desktop x-scheme-handler/kraken
```

#### Verify Desktop File Content
The .desktop file should contain:
```ini
MimeType=x-scheme-handler/kraken;
```

### 2. Permission Issues

#### Fix Desktop File Permissions
```bash
# For user installation
chmod 644 ~/.local/share/applications/kraken.desktop

# For system installation
sudo chmod 644 /usr/share/applications/kraken.desktop
```

#### Fix Directory Permissions
```bash
# For user installation
chmod 755 ~/.local/share/applications

# For system installation
sudo chmod 755 /usr/share/applications
```

### 3. Browser-Specific Issues

#### Firefox
1. Open `about:config`
2. Search for `network.protocol-handler.expose.kraken`
3. Set to `false` to make Firefox ask what to do with kraken:// URLs
4. Click a kraken:// link and choose Kraken Desktop

#### Chrome/Chromium
1. Click a kraken:// link
2. Click 'Open' in the protocol handler dialog
3. If no dialog appears:
   - Settings → Privacy and security → Site Settings
   - Additional permissions → Protocol handlers
   - Remove any incorrect kraken:// handlers

#### Brave
Similar to Chrome, but might need to:
1. Settings → Additional Settings → Privacy and security
2. Site and Shields Settings → Additional permissions
3. Protocol handlers → Allow sites to ask to become protocol handlers

### 4. Desktop Environment Issues

#### GNOME
```bash
# Reset MIME cache
update-desktop-database ~/.local/share/applications
killall -q nautilus
```

#### KDE
```bash
# Rebuild KDE's cache
kbuildsycoca5 --noincremental
```

#### XFCE
```bash
# Update MIME database
update-mime-database ~/.local/share/mime
```

## Advanced Debugging

### Check System Logs
```bash
# Check journal for related errors
journalctl -f | grep kraken

# Check .xsession-errors
tail -f ~/.xsession-errors
```

### Test URL Handler
```bash
# Test with xdg-open
xdg-open "kraken://test"

# Verbose mode for more info
XDG_UTILS_DEBUG_LEVEL=2 xdg-open "kraken://test"
```

### Check Desktop File Installation
```bash
# List all desktop files
ls -la /usr/share/applications/kraken* ~/.local/share/applications/kraken*

# Check desktop file validation
desktop-file-validate ~/.local/share/applications/kraken.desktop
```
### 5. App Not Appearing in Application Launcher

After installation, the app may not immediately appear in GNOME/KDE/XFCE launchers.
```bash
# Force refresh the launcher (GNOME)
update-desktop-database ~/.local/share/applications
killall -q gnome-shell || true

# KDE
kbuildsycoca5 --noincremental

# Or simply log out and back in
```

Also verify the desktop file has no validation errors:
```bash
desktop-file-validate ~/.local/share/applications/kraken.desktop
```
### 6. `kraken_desktop` Command Not Found After User Install

On some distributions `~/.local/bin` is not in `$PATH` by default. Add it:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
## Still Having Issues?

1. Verify Kraken Desktop is properly installed
2. Try uninstalling and reinstalling Kraken Desktop
3. Check the [official Kraken support](https://support.kraken.com)
4. File an issue on this repository with:
   - Your Linux distribution and version
   - Desktop environment
   - Browser
   - Exact steps to reproduce the issue
   - Any error messages
