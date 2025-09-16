# Changelog

All notable changes to Universal NPM Upgrade System will be documented in this file.

## [1.0.0] - 2025-09-16

### Added
- ✨ Initial release of Universal NPM Upgrade System
- 🔍 Version checking without installation (`upgrade check [tool]`)
- 🚀 Simple upgrade syntax (`upgrade [tool]`)
- 🎯 Specific version support (`upgrade [tool] [version]`)
- 📦 Dynamic package discovery for any npm CLI tool
- ✅ Version validation and error handling
- 🔄 Automatic rollback instructions
- 📈 Clean update summaries showing version changes
- 🛡️ Safety features with backup creation
- 📋 Cross-shell compatibility (bash/zsh)
- 📖 Comprehensive documentation with examples
- 🔧 Professional install/uninstall scripts

### Features
- Works with any npm-installed CLI tool
- Automatically discovers package names from command names
- Interactive confirmation for questionable versions
- Beautiful emoji-based output with clear status indicators
- Supports both scoped (`@org/package`) and regular packages

### Supported Platforms
- macOS
- Linux
- Windows (via WSL)

### Requirements
- bash or zsh shell
- Node.js and npm
- Git (for installation from repository)