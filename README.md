# Kraken Desktop Linux Integration Helper

A guide for properly setting up Kraken Desktop's URL handler (`kraken://`) on Linux systems.

## Quick Start

1. Download Kraken Desktop from [Official Website](https://www.kraken.com/desktop)
2. Run installation commands for your distribution:

## Automated Setup (Recommended)
Clone this repo and run the setup script:
```bash
# User install (no sudo needed)
chmod +x setup-kraken.sh
./setup-kraken.sh

# System-wide install
sudo ./setup-kraken.sh --system
```
Place `kraken_desktop` (downloaded from [kraken.com/desktop](https://www.kraken.com/desktop))
and optionally a `kraken.png` icon in the same directory before running.

### Ubuntu/Debian
```bash
# Install required package
sudo apt update && sudo apt install xdg-utils

# User installation
mkdir -p ~/.local/share/applications
cp /path/to/downloaded/kraken.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
xdg-mime default kraken.desktop x-scheme-handler/kraken
```

### Fedora/RHEL
```bash
# Install required packages
sudo dnf install xdg-utils shared-mime-info

# User installation
mkdir -p ~/.local/share/applications
cp /path/to/downloaded/kraken.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
xdg-mime default kraken.desktop x-scheme-handler/kraken
```

### Arch Linux
```bash
# Install required packages
sudo pacman -S xdg-utils

# User installation
mkdir -p ~/.local/share/applications
cp /path/to/downloaded/kraken.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
xdg-mime default kraken.desktop x-scheme-handler/kraken
```

## System-wide Installation
For system-wide installation on any distribution:
```bash
sudo cp /path/to/downloaded/kraken.desktop /usr/share/applications/
sudo update-desktop-database
xdg-mime default kraken.desktop x-scheme-handler/kraken
```

## Verification
Test the installation:
```bash
xdg-open "kraken://test"
```
The Kraken Desktop application should launch.

## Troubleshooting
See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for:
- Distribution-specific solutions
- Common issues and fixes
- Browser-specific settings
- Desktop environment tweaks
- Advanced debugging steps

## Uninstallation
Remove URL handler registration:
```bash
# User installation
rm ~/.local/share/applications/kraken.desktop
update-desktop-database ~/.local/share/applications

# System-wide installation
sudo rm /usr/share/applications/kraken.desktop
sudo update-desktop-database
```

## Disclaimer
This is a community-maintained helper guide and is not officially affiliated with Kraken. For official downloads and support, visit [Kraken's website](https://www.kraken.com/desktop).

## License
This documentation is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
