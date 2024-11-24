#!/bin/bash
echo "Starting Selenium Tests on Self-Hosted Runner..."
# Detect operating system and validate Windows
if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32"* ]]; then
    echo "Running on a Windows-based system."
else
    echo "This script is designed to run only on Windows-based systems."
    exit 1
fi