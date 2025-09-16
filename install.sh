#!/bin/bash
# Universal NPM Upgrade System - Installation Script
# Automatically installs the upgrade functions to your shell configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FUNCTIONS_FILE="$SCRIPT_DIR/upgrade-functions.sh"

echo -e "${BLUE}🚀 Universal NPM Upgrade System Installer${NC}"
echo "=================================================="

# Check if functions file exists
if [ ! -f "$FUNCTIONS_FILE" ]; then
    echo -e "${RED}❌ Error: upgrade-functions.sh not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Detect shell and config file
detect_shell() {
    local shell_name=$(basename "$SHELL")
    local config_file=""

    case "$shell_name" in
        "zsh")
            config_file="$HOME/.zshrc"
            ;;
        "bash")
            # Check for .bash_profile first, then .bashrc
            if [ -f "$HOME/.bash_profile" ]; then
                config_file="$HOME/.bash_profile"
            else
                config_file="$HOME/.bashrc"
            fi
            ;;
        "fish")
            echo -e "${YELLOW}⚠️  Fish shell detected. This installer supports bash/zsh only.${NC}"
            echo -e "${BLUE}💡 For fish shell, manually add the functions or create a fish-compatible version.${NC}"
            exit 1
            ;;
        *)
            echo -e "${YELLOW}⚠️  Unknown shell: $shell_name${NC}"
            echo -e "${BLUE}💡 Defaulting to ~/.bashrc${NC}"
            config_file="$HOME/.bashrc"
            ;;
    esac

    echo "$config_file"
}

# Main installation
main() {
    local config_file=$(detect_shell)
    local shell_name=$(basename "$SHELL")

    echo -e "${BLUE}📋 Detected shell: $shell_name${NC}"
    echo -e "${BLUE}📁 Config file: $config_file${NC}"

    # Check if already installed
    if grep -q "Universal NPM Upgrade System" "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Universal NPM Upgrade System appears to already be installed.${NC}"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}💡 Installation cancelled.${NC}"
            exit 0
        fi

        # Remove old installation
        echo -e "${BLUE}🧹 Removing old installation...${NC}"
        # Create a backup
        cp "$config_file" "$config_file.backup.$(date +%s)"
        # Remove lines between our markers
        sed -i '' '/# === Universal NPM Upgrade System - START ===/,/# === Universal NPM Upgrade System - END ===/d' "$config_file"
    fi

    # Create backup
    echo -e "${BLUE}💾 Creating backup: ${config_file}.backup.$(date +%s)${NC}"
    cp "$config_file" "$config_file.backup.$(date +%s)"

    # Add installation marker and source command
    echo -e "${BLUE}📝 Adding upgrade functions to $config_file...${NC}"

    cat >> "$config_file" << EOF

# === Universal NPM Upgrade System - START ===
# Installed on $(date)
# Source: $FUNCTIONS_FILE
source "$FUNCTIONS_FILE"
# === Universal NPM Upgrade System - END ===
EOF

    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo -e "${BLUE}🎯 Available commands:${NC}"
    echo "  upgrade check [tool]       # Check version status"
    echo "  upgrade [tool]             # Install latest"
    echo "  upgrade [tool] [version]   # Install specific version"
    echo "  upgrade                    # Update everything"
    echo ""
    echo -e "${YELLOW}💡 Restart your terminal or run: source $config_file${NC}"
    echo ""
    echo -e "${BLUE}📖 For examples and documentation, see: README.md${NC}"
}

# Check for npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ Error: npm is not installed or not in PATH${NC}"
    echo -e "${BLUE}💡 Please install Node.js and npm first: https://nodejs.org/${NC}"
    exit 1
fi

# Run main installation
main

echo -e "${GREEN}🎉 Happy upgrading!${NC}"