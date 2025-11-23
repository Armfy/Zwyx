#!/usr/bin/env zsh
set -euo pipefail

APP_NAME="Zwyx"
BUNDLE_DIR="${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"
PLIST_SRC="Info.plist"

# Clean previous
rm -rf "$BUNDLE_DIR"

# Create bundle folders
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Determine SDK path
SDK_PATH=$(xcrun --sdk macosx --show-sdk-path)

# Compile the SwiftUI app
# Note: Requires Xcode Command Line Tools. Links SwiftUI, Cocoa, and IOKit frameworks.
echo "Compiling ${APP_NAME}…"
swiftc \
  -parse-as-library \
  -sdk "$SDK_PATH" \
  -O \
  -o "${MACOS_DIR}/${APP_NAME}" \
  main.swift \
  -framework SwiftUI \
  -framework Cocoa \
  -framework IOKit

# Make executable
chmod +x "${MACOS_DIR}/${APP_NAME}"

# Copy Info.plist
if [[ -f "$PLIST_SRC" ]]; then
  cp "$PLIST_SRC" "${CONTENTS_DIR}/Info.plist"
else
  echo "Warning: Info.plist not found, app may not open from Finder."
fi

# Create PkgInfo (optional)
echo -n "APPL????" > "${CONTENTS_DIR}/PkgInfo"

# Done
echo "Built ${BUNDLE_DIR}"
