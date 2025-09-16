#!/bin/bash
# Universal NPM CLI Upgrade System
# Easily upgrade any npm-installed CLI tool with simple commands
#
# Usage:
#   upgrade check [tool]       # Check version status
#   upgrade [tool]             # Install latest
#   upgrade [tool] [version]   # Install specific version
#   upgrade                    # Update everything

# Universal npm CLI updater with version support
npm-upgrade() {
    # Handle check command
    if [[ "$1" == "check" ]]; then
        if [ $# -eq 1 ]; then
            echo "🔍 Checking all global packages for updates..."
            npm outdated -g
            return
        fi

        local cmd="$2"
        local pkg_path=$(which "$cmd" 2>/dev/null)

        if [ -z "$pkg_path" ]; then
            echo "❌ Command '$cmd' not found"
            return 1
        fi

        # Get package name (same logic as below)
        local real_path=$(readlink -f "$pkg_path")
        local pkg_name

        if [[ "$real_path" == *"/@"* ]]; then
            pkg_name=$(echo "$real_path" | sed -n 's|.*node_modules/\(@[^/]*/[^/]*\).*|\1|p')
        else
            pkg_name=$(echo "$real_path" | sed -n 's|.*node_modules/\([^/]*\).*|\1|p')
        fi

        if [ -z "$pkg_name" ]; then
            echo "❌ Could not determine package name for '$cmd'"
            return 1
        fi

        echo "📦 Package: $pkg_name"

        # Get current version
        local current_version=$(npm list -g "$pkg_name" 2>/dev/null | grep "$pkg_name@" | sed 's/.*@//' | sed 's/ .*//')
        echo "📌 Current version: ${current_version:-'unknown'}"

        # Get latest version
        local latest_version=$(npm view "$pkg_name" version 2>/dev/null)
        echo "🚀 Latest version: ${latest_version:-'unknown'}"

        # Compare versions
        if [ "$current_version" = "$latest_version" ]; then
            echo "✅ You have the latest version!"
        elif [ -n "$current_version" ] && [ -n "$latest_version" ]; then
            echo "📈 Update available: $current_version → $latest_version"
            echo "💡 To upgrade: upgrade $cmd"
        fi

        return
    fi

    # Original upgrade logic
    if [ $# -eq 0 ]; then
        echo "Updating all global npm packages..."
        npm update -g
        return
    fi

    local cmd="$1"
    local version="$2"
    local pkg_path=$(which "$cmd" 2>/dev/null)

    if [ -z "$pkg_path" ]; then
        echo "❌ Command '$cmd' not found"
        return 1
    fi

    # Get the real path and extract package name
    local real_path=$(readlink -f "$pkg_path")
    local pkg_name

    # Handle scoped packages (@org/package) and regular packages
    if [[ "$real_path" == *"/@"* ]]; then
        pkg_name=$(echo "$real_path" | sed -n 's|.*node_modules/\(@[^/]*/[^/]*\).*|\1|p')
    else
        pkg_name=$(echo "$real_path" | sed -n 's|.*node_modules/\([^/]*\).*|\1|p')
    fi

    if [ -z "$pkg_name" ]; then
        echo "❌ Could not determine package name for '$cmd'"
        return 1
    fi

    echo "📦 Found package: $pkg_name"

    # Get current version for backup info
    local current_version=$(npm list -g "$pkg_name" 2>/dev/null | grep "$pkg_name@" | sed 's/.*@//' | sed 's/ .*//')
    if [ -n "$current_version" ]; then
        echo "📌 Current version: $current_version"
    fi

    # Determine target version
    local target_version
    if [ -z "$version" ]; then
        target_version="latest"
        echo "🚀 Installing latest version..."
    else
        target_version="$version"
        echo "🎯 Installing specific version: $version"

        # Validate version exists (optional check)
        echo "🔍 Checking if version exists..."
        if ! npm view "$pkg_name@$version" version >/dev/null 2>&1; then
            echo "⚠️  Warning: Version $version might not exist"
            echo "📋 Available versions:"
            npm view "$pkg_name" versions --json 2>/dev/null | tail -10
            read -q "REPLY?Continue anyway? (y/n): "
            echo
            if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
                echo "❌ Installation cancelled"
                return 1
            fi
        fi
    fi

    # Perform installation with error handling
    echo "⏳ Installing $pkg_name@$target_version..."
    if npm install -g "$pkg_name@$target_version"; then
        # Get the actual installed version
        local final_version=$(npm list -g "$pkg_name" 2>/dev/null | grep "$pkg_name@" | sed 's/.*@//' | sed 's/ .*//')

        if [ -n "$final_version" ]; then
            echo "✅ Successfully installed $pkg_name@$final_version"
            if [ "$target_version" = "latest" ] && [ "$final_version" != "$current_version" ]; then
                echo "📈 Updated: $current_version → $final_version"
            fi
        else
            echo "✅ Successfully installed $pkg_name@$target_version"
        fi

        echo "💡 To rollback: upgrade $cmd $current_version"
    else
        local exit_code=$?
        echo "❌ Installation failed!"
        echo "🔄 To rollback: upgrade $cmd $current_version"
        echo "📋 Try: npm view $pkg_name versions --json | tail -10"
        return $exit_code
    fi
}

# Alias for clean upgrade command
alias upgrade="npm-upgrade"