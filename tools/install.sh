#!/bin/bash
set -e

REPO="imagetec-laboratory/side-project-cli-template"
# เปลี่ยนจาก side-project-cli เป็น side-project
BINARY_NAME="side-project"
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

# Determine filename based on OS - ใช้ชื่อไฟล์จริงใน release
case "$OS" in
    linux|darwin)
        FILENAME="side-project"
        ;;
    mingw*|cygwin*|msys*)
        FILENAME="side-project.exe"
        ;;
    *)
        echo -e "${YELLOW}⚠️  Unsupported OS: $OS${NC}"
        echo -e "${BLUE}Trying generic binary...${NC}"
        FILENAME="side-project"
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

# Download URL
DOWNLOAD_URL="$BASE_URL/$FILENAME"

# Download the binary
echo -e "${BLUE}📥 Downloading $FILENAME...${NC}"
echo -e "${BLUE}🔗 URL: $DOWNLOAD_URL${NC}"

# Download
curl -L "$DOWNLOAD_URL" -o "$BINARY_NAME" || {
    echo -e "${RED}❌ Download failed!${NC}"
    echo -e "${BLUE}💡 Available files at: https://github.com/$REPO/releases/latest${NC}"
    exit 1
}

# Verify file size (should be > 1MB for a real binary)
FILE_SIZE=$(stat -f%z "$BINARY_NAME" 2>/dev/null || stat -c%s "$BINARY_NAME" 2>/dev/null || echo "0")
if [ "$FILE_SIZE" -lt 1000000 ]; then
    echo -e "${RED}❌ Downloaded file seems too small ($FILE_SIZE bytes). Something went wrong.${NC}"
    rm -f "$BINARY_NAME"
    exit 1
fi

# Make executable (Unix systems)
if [ "$OS" != "mingw"* ] && [ "$OS" != "cygwin"* ] && [ "$OS" != "msys"* ]; then
    chmod +x "$BINARY_NAME"
fi

# Success message
echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${GREEN}📁 Binary saved as: ./$BINARY_NAME (${FILE_SIZE} bytes)${NC}"
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