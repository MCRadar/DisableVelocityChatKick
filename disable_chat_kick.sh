#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

PATCH_FILE="$SCRIPT_DIR/disable_chat_kick.patch"
REPO_DIR="$SCRIPT_DIR/Velocity"

echo "Patch file path: $PATCH_FILE"
echo "Repository directory: $REPO_DIR"

if [ ! -f "$PATCH_FILE" ]; then
    echo "Error: Patch file does not exist."
    exit 1
fi

if [ ! -d "$REPO_DIR" ]; then
    git clone https://github.com/VelocityPowered/Velocity.git "$REPO_DIR"
fi

cd "$REPO_DIR"

if [ ! -d ".git" ]; then
    echo "Error: This is not a git repository."
    exit 1
fi

# Patch
git apply "$PATCH_FILE"
if [ $? -ne 0 ]; then
    echo "Failed to apply patch."
    exit 1
else
    echo "Patch applied successfully."
fi

# Build
./gradlew shadowJar
if [ $? -ne 0 ]; then
    echo "Failed to build the project."
    exit 1
else
    echo "Project built successfully."
fi

mv "$REPO_DIR/proxy/build/libs/"*.jar "$SCRIPT_DIR/"
if [ $? -ne 0 ]; then
    echo "Failed to move the JAR file."
    exit 1
else
    echo "JAR file moved successfully."
fi

# Clean up
rm -rf "$REPO_DIR"
echo "Cleaned up repository files."

echo "All tasks completed successfully."
