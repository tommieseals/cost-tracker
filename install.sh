#!/bin/bash
# Cost Tracker Installer

set -e

INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cost-tracker"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/cost-tracker"

echo "Installing Cost Tracker..."

# Create directories
mkdir -p "$CONFIG_DIR" "$DATA_DIR"

# Install script
if [ -w "$INSTALL_DIR" ]; then
    cp cost-tracker "$INSTALL_DIR/cost-tracker"
    chmod +x "$INSTALL_DIR/cost-tracker"
else
    sudo cp cost-tracker "$INSTALL_DIR/cost-tracker"
    sudo chmod +x "$INSTALL_DIR/cost-tracker"
fi

# Initialize data file
[ ! -f "$DATA_DIR/costs.json" ] && echo "[]" > "$DATA_DIR/costs.json"

echo "Installed! Run: cost-tracker --track"
echo ""
echo "Add to crontab for automatic tracking:"
echo "  0 * * * * /usr/local/bin/cost-tracker --track"

