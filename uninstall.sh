#!/bin/bash
# Universal NPM Upgrade System - Uninstall Script
# Cleanly removes the upgrade functions from your shell configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🗑️  Universal NPM Upgrade System Uninstaller${NC}"
echo "=================================================="

# Detect shell and config file
detect_shell() {
    local shell_name=$(basename "$SHELL")
    local config_file=""

    case "$shell_name" in
        "zsh")
            config_file="$HOME/.zshrc"
            ;;
        "bash")
            if [ -f "$HOME/.bash_profile" ]; then
                config_file="$HOME/.bash_profile"
            else
                config_file="$HOME/.bashrc"
            fi
            ;;
        *)
            echo -e "${YELLOW}⚠️  Unknown shell: $shell_name${NC}"
            echo -e "${BLUE}💡 Defaulting to ~/.bashrc${NC}"
            config_file="$HOME/.bashrc"
            ;;
    esac

    echo "$config_file"
}

# Main uninstallation
main() {
    local config_file=$(detect_shell)
    local shell_name=$(basename "$SHELL")

    echo -e "${BLUE}📋 Detected shell: $shell_name${NC}"
    echo -e "${BLUE}📁 Config file: $config_file${NC}"

    # Check if installed
    if ! grep -q "Universal NPM Upgrade System" "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Universal NPM Upgrade System doesn't appear to be installed.${NC}"
        echo -e "${BLUE}💡 Nothing to uninstall.${NC}"
        exit 0
    fi

    # Confirm uninstallation
    echo -e "${YELLOW}⚠️  This will remove the Universal NPM Upgrade System from your shell.${NC}"
    read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}💡 Uninstallation cancelled.${NC}"
        exit 0
    fi

    # Create backup before removal
    echo -e "${BLUE}💾 Creating backup: ${config_file}.backup.$(date +%s)${NC}"
    cp "$config_file" "$config_file.backup.$(date +%s)"

    # Remove the installation
    echo -e "${BLUE}🧹 Removing upgrade functions from $config_file...${NC}"
    sed -i '' '/# === Universal NPM Upgrade System - START ===/,/# === Universal NPM Upgrade System - END ===/d' "$config_file"

    echo -e "${GREEN}✅ Uninstallation complete!${NC}"
    echo ""
    echo -e "${BLUE}💡 The 'upgrade' command will no longer be available after restarting your terminal.${NC}"
    echo -e "${BLUE}📁 Backup of your config file was created for safety.${NC}"
    echo ""
    echo -e "${YELLOW}🔄 Restart your terminal or run: source $config_file${NC}"
}

# Run main uninstallation
main

echo -e "${GREEN}👋 Thanks for using Universal NPM Upgrade System!${NC}"