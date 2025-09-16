# Usage Examples

Comprehensive examples of how to use the Universal NPM Upgrade System.

## Daily Workflow Examples

### Morning Update Check
```bash
# Check what needs updating
upgrade check

# Output:
# Package    Current   Latest    Status
# eslint     9.34.0    9.35.0    outdated
# typescript 5.1.6     5.2.2     outdated
# codex      0.35.0    0.36.0    outdated
```

### Selective Updates
```bash
# Check specific tools
upgrade check eslint
upgrade check typescript
upgrade check codex

# Update only what you want
upgrade eslint      # Safe utility update
upgrade typescript  # Language update
# Skip codex for now (maybe it has issues)
```

## Version Management

### Staying on Stable Versions
```bash
# Pin to known stable versions
upgrade claude 1.0.88    # Known stable
upgrade typescript 5.1.6 # LTS version
upgrade eslint 8.57.0    # Previous major

# Check what you have
upgrade check claude
upgrade check typescript
upgrade check eslint
```

### Testing New Versions
```bash
# Current setup
upgrade check codex
# Output: Current: 0.35.0, Latest: 0.36.0

# Try new version
upgrade codex 0.36.0

# If issues, rollback
upgrade codex 0.35.0
```

## Common Scenarios

### After Clean macOS Install
```bash
# Install your development tools first
npm install -g @openai/codex
npm install -g @anthropic-ai/claude-code
npm install -g typescript
npm install -g eslint

# Then use upgrade system for management
upgrade check        # See current state
upgrade              # Update everything to latest
```

### Before Important Project Work
```bash
# Check tool versions
upgrade check typescript
upgrade check eslint
upgrade check prettier

# Pin to known working versions
upgrade typescript 5.1.6
upgrade eslint 8.57.0
upgrade prettier 3.0.0
```

### Weekly Maintenance
```bash
# Monday morning routine
upgrade check                    # See what's outdated
upgrade check | grep -v "latest" # Only show outdated packages

# Update non-critical tools
upgrade eslint
upgrade prettier
upgrade typescript

# Check critical tools but don't auto-update
upgrade check claude
upgrade check codex
# Manual decision on these
```

## Troubleshooting Examples

### When Upgrades Fail
```bash
# Upgrade attempt
upgrade some-tool

# If it fails, you get:
# ❌ Installation failed!
# 🔄 To rollback: upgrade some-tool 1.2.3
# 📋 Try: npm view some-tool versions --json | tail -10

# Follow the suggestions
npm view some-tool versions --json | tail -10
# Pick a working version
upgrade some-tool 1.2.4
```

### Package Not Found
```bash
upgrade nonexistent-tool
# ❌ Command 'nonexistent-tool' not found

# Install it first
npm install -g some-new-tool
# Then manage with upgrade
upgrade check some-new-tool
```

### Version Validation
```bash
upgrade codex 999.999.999
# Output:
# 🔍 Checking if version exists...
# ⚠️  Warning: Version 999.999.999 might not exist
# 📋 Available versions:
# [...list of versions...]
# Continue anyway? (y/n): n
# ❌ Installation cancelled
```

## Advanced Usage

### Scripting with Upgrade
```bash
#!/bin/bash
# development-setup.sh

echo "Setting up development environment..."

# Install base tools
npm install -g @anthropic-ai/claude-code
npm install -g typescript
npm install -g eslint

# Pin to specific versions for consistency
upgrade claude 1.0.88
upgrade typescript 5.1.6
upgrade eslint 8.57.0

echo "Development environment ready!"
```

### Conditional Updates
```bash
# Only update if outdated
check_and_update() {
    local tool=$1
    if upgrade check "$tool" | grep -q "Update available"; then
        echo "Updating $tool..."
        upgrade "$tool"
    else
        echo "$tool is up to date"
    fi
}

check_and_update eslint
check_and_update typescript
check_and_update prettier
```

### Bulk Operations
```bash
# Update multiple specific tools
for tool in eslint typescript prettier; do
    echo "Checking $tool..."
    upgrade check "$tool"
    read -p "Update $tool? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        upgrade "$tool"
    fi
done
```

## Real-World Package Examples

### AI/ML Tools
```bash
upgrade check codex          # @openai/codex
upgrade check claude         # @anthropic-ai/claude-code
upgrade check cursor         # cursor-cli
```

### Development Tools
```bash
upgrade check typescript     # typescript
upgrade check eslint        # eslint
upgrade check prettier      # prettier
upgrade check nodemon       # nodemon
upgrade check pm2           # pm2
```

### Build Tools
```bash
upgrade check webpack       # webpack
upgrade check vite          # vite
upgrade check rollup        # rollup
upgrade check parcel        # parcel
```

### Testing Tools
```bash
upgrade check jest          # jest
upgrade check mocha         # mocha
upgrade check playwright    # @playwright/test
```

### Utility Tools
```bash
upgrade check http-server   # http-server
upgrade check live-server   # live-server
upgrade check json-server   # json-server
```

## Team Collaboration

### Sharing Version Lock File
```bash
# Create a team version lock
upgrade check > team-versions.txt

# Team members can reference this
cat team-versions.txt
# Then manually install same versions
upgrade typescript 5.1.6
upgrade eslint 8.57.0
```

### Documentation for Team
```bash
# Document your team's standard setup
echo "# Team Development Setup" > SETUP.md
echo "" >> SETUP.md
echo "## Install Universal NPM Upgrade" >> SETUP.md
echo "git clone <repo-url>" >> SETUP.md
echo "./install.sh" >> SETUP.md
echo "" >> SETUP.md
echo "## Standard Tool Versions" >> SETUP.md
upgrade check typescript >> SETUP.md
upgrade check eslint >> SETUP.md
upgrade check prettier >> SETUP.md
```

---

**These examples should cover most real-world usage scenarios!**