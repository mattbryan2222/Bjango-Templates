#!/usr/bin/env bash
set -euo pipefail

REPO="mattbryan2222/Bjango-Templates"
BRANCH="main"
ARCHIVE_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.zip"
TMP_DIR=$(mktemp -d)
EXTRACTED_DIR="${TMP_DIR}/Bjango-Templates-${BRANCH}"

# Cleanup on exit
trap 'rm -rf "$TMP_DIR"' EXIT

# OS check (macOS only for now)
if [[ "$(uname)" != "Darwin" ]]; then
  echo "This installer currently only supports macOS."
  exit 1
fi

# Dependency check (curl, unzip)
for cmd in curl unzip; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Required: $cmd"; exit 1; }
done

# Download archive
echo "Downloading Bjango Templates..."
curl -fsSL "$ARCHIVE_URL" -o "${TMP_DIR}/templates.zip"

# Extract
unzip -q "${TMP_DIR}/templates.zip" -d "$TMP_DIR"

# Tool selection menu
echo ""
echo "Which design tool would you like to install templates for?"
echo "  1) Sketch"
echo "  2) All (copy to ~/Documents/Bjango-Templates)"
read -r -p "Enter choice [1-2]: " CHOICE

case "$CHOICE" in
  1|"")
    SKETCH_DIR=~/Library/Application\ Support/com.bohemiancoding.sketch3/Templates
    mkdir -p "$SKETCH_DIR"
    cp "$EXTRACTED_DIR"/Sketch/*.sketch "$SKETCH_DIR/"
    echo "Sketch templates installed to $SKETCH_DIR"
    echo "Open Sketch → File → New From Template to use them."
    ;;  
  2)
    DEST=~/Documents/Bjango-Templates
    mkdir -p "$DEST"
    cp -r "$EXTRACTED_DIR"/Sketch "$DEST/"
    cp -r "$EXTRACTED_DIR"/Photoshop "$DEST/"
    cp -r "$EXTRACTED_DIR"/"Affinity Designer" "$DEST/"
    cp -r "$EXTRACTED_DIR"/Illustrator "$DEST/"
    cp -r "$EXTRACTED_DIR"/PNG "$DEST/"
    echo "All templates installed to $DEST"
    ;;  
  *)
    echo "Invalid choice. Exiting."
    exit 1;
    ;;
 esac

# ASCII art / success banner
echo ""
echo "         :::::::::   :::::::     ::::      ::::    :::   ::::::::    ::::::::"
echo "        :+:    :+:      :+:    :+: :+:    :+:+:   :+:  :+:    :+:  :+:    :+:"
echo "       +:+    +:+      +:+   +:+   +:+   :+:+:+  +:+  +:+         +:+    +:+ "
echo "      +#++:++#+       +#+  +#++:++#++:  +#+ +:+ +#+  :#:         +#+    +:+  "
echo "     +#+    +#+      +#+  +#+     +#+  +#+  +#+#+#  +#+   +#+#  +#+    +#+   "
echo "    #+#    #+#  #+# #+#  #+#     #+#  #+#   #+#+#  #+#    #+#  #+#    #+#    "
echo "   #########    #####   ###     ###  ###    ####   ########    ########      "
echo ""
echo "All done!"