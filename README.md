# Universal NPM Upgrade System

A simple, powerful shell-based tool that makes upgrading npm CLI packages as easy as using Homebrew.

## Why This Tool?

**Problem:** NPM package names are often complex and hard to remember:
- To upgrade `codex`, you need `npm install -g @openai/codex@latest`
- To upgrade `claude`, you need `npm install -g @anthropic-ai/claude-code@latest`

**Solution:** Use the simple command name you actually type:
- `upgrade codex` - automatically finds and upgrades `@openai/codex`
- `upgrade claude` - automatically finds and upgrades `@anthropic-ai/claude-code`

## Features

- 🔍 **Version checking** without installing
- 🚀 **Simple syntax** like Homebrew
- 🎯 **Specific version support** for pinning/downgrading
- 📦 **Dynamic package discovery** - works with any npm CLI
- ✅ **Version validation** and error handling
- 🔄 **Automatic rollback instructions**
- 📈 **Clean update summaries** showing old → new versions

## Quick Start

### Installation

```bash
# Clone this repo
git clone https://github.com/DonMecca/universal-npm-upgrade.git
cd universal-npm-upgrade

# Run the installer
chmod +x install.sh
./install.sh

# Restart your terminal or:
source ~/.zshrc  # (or ~/.bashrc)
```

### Basic Usage

```bash
# Check what version you have vs latest
upgrade check codex

# Upgrade to latest version
upgrade codex

# Install specific version
upgrade codex 0.35.0

# Check all packages for updates
upgrade check

# Update everything
upgrade
```

## Commands

| Command | Description | Example |
|---------|-------------|---------|
| `upgrade check [tool]` | Check current vs latest version | `upgrade check eslint` |
| `upgrade check` | Check all global packages | `upgrade check` |
| `upgrade [tool]` | Install latest version | `upgrade typescript` |
| `upgrade [tool] [version]` | Install specific version | `upgrade claude 1.0.88` |
| `upgrade` | Update all global packages | `upgrade` |

## Example Output

### Version Check
```bash
$ upgrade check codex
📦 Package: @openai/codex
📌 Current version: 0.35.0
🚀 Latest version: 0.36.0
📈 Update available: 0.35.0 → 0.36.0
💡 To upgrade: upgrade codex
```

### Successful Upgrade
```bash
$ upgrade eslint
📦 Found package: eslint
📌 Current version: 9.34.0
🚀 Installing latest version...
⏳ Installing eslint@latest...
✅ Successfully installed eslint@9.35.0
📈 Updated: 9.34.0 → 9.35.0
💡 To rollback: upgrade eslint 9.34.0
```

## How It Works

1. **Package Discovery**: Uses `which` to find the command location
2. **Path Analysis**: Traces symlinks to find the actual npm package
3. **Name Extraction**: Parses the `node_modules` path to get package name
4. **Version Management**: Uses npm commands for installation and validation

## Supported Tools

Works with **any** npm-installed CLI tool, including:
- `@openai/codex` → `codex`
- `@anthropic-ai/claude-code` → `claude`
- `eslint`, `typescript`, `prettier`, etc.
- Any scoped (`@org/package`) or regular packages

## Requirements

- **Shell**: bash or zsh
- **NPM**: Node.js and npm installed
- **OS**: macOS or Linux (Windows via WSL)

## Safety Features

- ✅ **Backup creation** before any changes
- ✅ **Version validation** before installation
- ✅ **Current version display** before upgrades
- ✅ **Rollback instructions** if something breaks
- ✅ **Interactive confirmation** for questionable versions

## Uninstall

```bash
# Clean removal
./uninstall.sh
```

This removes all traces from your shell configuration and creates a backup.

## File Structure

```
universal-npm-upgrade/
├── README.md              # This file
├── install.sh            # Installation script
├── uninstall.sh          # Clean removal
├── upgrade-functions.sh   # Core shell functions
└── examples.md           # More usage examples
```

## Version History

- **v1.0**: Initial version with basic upgrade functionality
- **v1.1**: Added version checking (`upgrade check`)
- **v1.2**: Added specific version support and validation
- **v1.3**: Added clean version parsing (removed npm "deduped" output)

## Contributing

This is a personal backup repo, but feel free to fork and adapt for your own use!

## License

MIT License - Use freely for personal or commercial projects.

---

**Made with ❤️ for developers who forget npm package names**