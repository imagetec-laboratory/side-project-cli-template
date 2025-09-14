#!/bin/bash
set -e

REPO="imagetec-laboratory/side-project-cli-template"
BINARY_NAME="side-project-cli"
BASE_URL="https://github.com/$REPO/releases/latest/download"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Installing Side Project CLI Template...${NC}"

# Check if curl is available
if ! command -v curl >/dev/null 2>&1; then
    echo -e "${RED}❌ curl is required but not installed.${NC}"
    exit 1
fi

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

echo -e "${BLUE}🔍 Detected OS: $OS, Architecture: $ARCH${NC}"

# Determine filename based on OS
case "$OS" in
    linux)
        case "$ARCH" in
            x86_64) FILENAME="${BINARY_NAME}-linux-x64" ;;
            aarch64|arm64) FILENAME="${BINARY_NAME}-linux-arm64" ;;
            *) FILENAME="${BINARY_NAME}" ;; # fallback to generic binary
        esac
        ;;
    darwin)
        case "$ARCH" in
            x86_64) FILENAME="${BINARY_NAME}-macos-x64" ;;
            arm64) FILENAME="${BINARY_NAME}-macos-arm64" ;;
            *) FILENAME="${BINARY_NAME}" ;; # fallback to generic binary
        esac
        ;;
    mingw*|cygwin*|msys*)
        FILENAME="${BINARY_NAME}.exe"
        ;;
    *)
        echo -e "${YELLOW}⚠️  Unsupported OS: $OS${NC}"
        echo -e "${BLUE}Trying generic binary...${NC}"
        FILENAME="${BINARY_NAME}"
        ;;
esac

# Get latest version info
echo -e "${BLUE}📡 Fetching latest release info...${NC}"
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null) || {
    echo -e "${RED}❌ Failed to fetch release info. Please check your internet connection.${NC}"
    exit 1
}

VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | cut -d '"' -f 4)
if [ -z "$VERSION" ]; then
    echo -e "${RED}❌ No releases found for this repository.${NC}"
    echo -e "${BLUE}💡 Please check: https://github.com/$REPO/releases${NC}"
    exit 1
fi

echo -e "${GREEN}📦 Latest version: $VERSION${NC}"

# Try to get specific download URL, fallback to generic
DOWNLOAD_URL="$BASE_URL/$FILENAME"

# Download the binary
echo -e "${BLUE}📥 Downloading $FILENAME...${NC}"
echo -e "${BLUE}🔗 URL: $DOWNLOAD_URL${NC}"

# Check if file exists (do a HEAD request)
if ! curl -s --head "$DOWNLOAD_URL" | head -n 1 | grep -q "200 OK"; then
    echo -e "${YELLOW}⚠️  Specific binary not found, trying generic name...${NC}"
    FILENAME="${BINARY_NAME}"
    DOWNLOAD_URL="$BASE_URL/$FILENAME"
fi

# Download
curl -L "$DOWNLOAD_URL" -o "$BINARY_NAME" || {
    echo -e "${RED}❌ Download failed!${NC}"
    echo -e "${BLUE}💡 Available files at: https://github.com/$REPO/releases/latest${NC}"
    exit 1
}

# Make executable (Unix systems)
if [ "$OS" != "mingw"* ] && [ "$OS" != "cygwin"* ] && [ "$OS" != "msys"* ]; then
    chmod +x "$BINARY_NAME"
fi

# Success message
echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${GREEN}📁 Binary saved as: ./$BINARY_NAME${NC}"
echo -e "${YELLOW}🎉 Run with: ./$BINARY_NAME${NC}"

# Optional: show version if binary supports it
echo -e "${BLUE}📋 Testing installation...${NC}"
if ./"$BINARY_NAME" --version 2>/dev/null; then
    echo -e "${GREEN}✅ Installation verified!${NC}"
elif ./"$BINARY_NAME" --help >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Installation verified!${NC}"
else
    echo -e "${YELLOW}⚠️  Binary installed but version check failed (this might be normal)${NC}"
fi

echo -e "${BLUE}🔗 For more info: https://github.com/$REPO${NC}"