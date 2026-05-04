#!/bin/bash
# Setup script for secure-askpass

echo "=== Secure Askpass Setup ==="
echo

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "1. Detected installation directory: $SCRIPT_DIR"
echo

# Check for SSH keys
echo "2. Checking for SSH keys..."
if { [ -f ~/.ssh/id_ed25519 ] && [ -f ~/.ssh/id_ed25519.pub ]; } || { [ -f ~/.ssh/id_rsa ] && [ -f ~/.ssh/id_rsa.pub ]; }; then
    echo "   ✓ SSH keys found"
else
    echo "   ✗ Supported SSH keys not found. Please generate one first:"
    echo "     ssh-keygen -t ed25519"
    exit 1
fi
echo

echo "3. Checking for age..."
if command -v age >/dev/null 2>&1; then
    echo "   ✓ age found"
else
    echo "   ✗ age not found. Install age first:"
    echo "     sudo apt install age   # Debian/Ubuntu"
    echo "     sudo dnf install age   # Fedora"
    echo "     sudo pacman -S age     # Arch"
    exit 1
fi
echo

# Make scripts executable
echo "4. Setting executable permissions..."
chmod +x "$SCRIPT_DIR/askpass"
chmod +x "$SCRIPT_DIR/askpass-manager"
chmod +x "$SCRIPT_DIR/agent-sudo"
echo "   ✓ Permissions set"
echo

# Suggest environment variable setup
echo "5. Environment setup"
echo "   Add the following to your ~/.bashrc or ~/.bash_profile:"
echo
echo "   export SUDO_ASKPASS=\"$SCRIPT_DIR/askpass\""
echo "   alias agent-sudo=\"$SCRIPT_DIR/agent-sudo\""
echo
echo "   Then reload your shell configuration:"
echo "   source ~/.bashrc"
echo

# Initial password setup
echo "6. Would you like to set up your sudo password now? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    "$SCRIPT_DIR/askpass-manager" set
fi

echo
echo "=== Setup Complete ==="
echo "To test your setup, run: ./askpass-manager test"
