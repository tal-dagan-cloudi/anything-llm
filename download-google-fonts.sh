#!/bin/bash

# Google Fonts Auto-Installer for Mac
# Automatically downloads and installs all Google Fonts

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
DOWNLOAD_DIR="$HOME/Downloads/google-fonts"
FONTS_INSTALL_DIR="$HOME/Library/Fonts/GoogleFonts"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Google Fonts Auto-Installer for Mac  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Error: git is not installed.${NC}"
    echo "Please install git first: brew install git"
    exit 1
fi

# Remove existing directory if present
if [ -d "$DOWNLOAD_DIR" ]; then
    echo -e "${BLUE}→ Removing existing download...${NC}"
    rm -rf "$DOWNLOAD_DIR"
fi

# Clone repository with progress
echo -e "${BLUE}→ Downloading Google Fonts (this may take a few minutes)...${NC}"
echo ""
git clone --depth 1 --progress https://github.com/google/fonts.git "$DOWNLOAD_DIR" 2>&1
echo ""
echo -e "${GREEN}✓ Download complete${NC}"
echo ""

# Create fonts directory
mkdir -p "$FONTS_INSTALL_DIR"

# Install fonts with progress
echo -e "${BLUE}→ Analyzing fonts...${NC}"
cd "$DOWNLOAD_DIR"

# Create temporary file list
FONT_LIST=$(mktemp)
find . \( -name "*.ttf" -o -name "*.otf" \) > "$FONT_LIST"
TOTAL_FONTS=$(wc -l < "$FONT_LIST" | tr -d ' ')
echo -e "  Found ${GREEN}$TOTAL_FONTS${NC} font files"
echo ""

# Copy fonts with progress bar
echo -e "${BLUE}→ Installing fonts...${NC}"
CURRENT=0
while IFS= read -r font; do
  cp "$font" "$FONTS_INSTALL_DIR/" 2>/dev/null || true
  CURRENT=$((CURRENT + 1))
  PERCENT=$((CURRENT * 100 / TOTAL_FONTS))
  BAR_LENGTH=$((PERCENT / 2))
  FILLED=$(printf '%*s' "$BAR_LENGTH" '' | tr ' ' '#')
  EMPTY=$(printf '%*s' $((50 - BAR_LENGTH)) '' | tr ' ' '-')
  printf "\r  Progress: [%s%s] %3d%% (%d/%d)" "$FILLED" "$EMPTY" "$PERCENT" "$CURRENT" "$TOTAL_FONTS"
done < "$FONT_LIST"
rm "$FONT_LIST"
echo ""

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Installation Complete!        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BLUE}✓${NC} Downloaded:     ${GREEN}$TOTAL_FONTS${NC} font files"
echo -e "  ${BLUE}✓${NC} Installed to:   ${GREEN}$FONTS_INSTALL_DIR${NC}"
echo -e "  ${BLUE}✓${NC} Source files:   ${GREEN}$DOWNLOAD_DIR${NC}"
echo ""
echo -e "${BLUE}Note:${NC} Restart applications to see new fonts"
echo ""
