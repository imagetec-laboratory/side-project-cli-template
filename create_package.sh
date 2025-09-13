#!/bin/bash

# Simple package creation script for side-project CLI

echo "📦 Creating distribution package for Side Project CLI..."

# Create dist directory if it doesn't exist
mkdir -p dist

# Copy executable and create package structure
if [ -f "dist/side-project" ]; then
    echo "✅ Executable found: dist/side-project"
    
    # Create a simple package directory
    PACKAGE_DIR="dist/side-project-cli-$(date +%Y%m%d)"
    mkdir -p "$PACKAGE_DIR"
    
    # Copy executable
    cp dist/side-project "$PACKAGE_DIR/"
    
    # Create a simple README for the package
    cat > "$PACKAGE_DIR/README.txt" << 'EOF'
Side Project CLI - Standalone Executable

Installation:
1. Copy the 'side-project' executable to a directory in your PATH
   For example: cp side-project /usr/local/bin/
2. Make sure it has execute permissions: chmod +x /usr/local/bin/side-project
3. Run from anywhere: side-project --help

Usage:
- side-project hello "Your Name"
- side-project info
- side-project version
- side-project --help

This is a standalone executable and does not require Python to be installed.
EOF
    
    # Create archive
    cd dist
    tar -czf "side-project-cli-$(date +%Y%m%d).tar.gz" "side-project-cli-$(date +%Y%m%d)"
    
    echo "📁 Package created: dist/side-project-cli-$(date +%Y%m%d).tar.gz"
    echo "📊 Package contents:"
    tar -tzf "side-project-cli-$(date +%Y%m%d).tar.gz"
    
    cd ..
else
    echo "❌ Executable not found. Please run './build.sh' first."
    exit 1
fi