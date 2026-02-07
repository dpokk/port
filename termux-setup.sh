#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# Termux Setup Script — Next.js Dev Server on Android
# ============================================================
# Run this ONCE after installing Termux.
# Usage:  bash termux-setup.sh
# ============================================================

set -e

echo "=========================================="
echo "  Termux Dev Server Setup"
echo "=========================================="

# ------------------------------------------
# 1. Update packages
# ------------------------------------------
echo "[1/6] Updating Termux packages..."
pkg update -y && pkg upgrade -y

# ------------------------------------------
# 2. Install required packages
# ------------------------------------------
echo "[2/6] Installing dependencies..."
pkg install -y \
  openssh \
  git \
  nodejs-lts \
  tmux \
  which \
  vim

# Install pnpm globally
echo "[3/6] Installing pnpm..."
npm install -g pnpm

# ------------------------------------------
# 3. Setup SSH
# ------------------------------------------
echo "[4/6] Configuring SSH..."

# Set password if not already set
echo ""
echo "Set a password for SSH access (you'll type it twice):"
passwd

# Start sshd
sshd
echo "  SSH server started on port 8022"
echo "  Your username: $(whoami)"

# ------------------------------------------
# 4. Setup storage access (optional)
# ------------------------------------------
echo "[5/6] Setting up storage permissions..."
termux-setup-storage || true

# ------------------------------------------
# 5. Git config
# ------------------------------------------
echo "[6/6] Configuring Git..."
echo ""
read -p "  Git user.name: " GIT_NAME
read -p "  Git user.email: " GIT_EMAIL
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# ------------------------------------------
# Summary
# ------------------------------------------
echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "  SSH:       port 8022"
echo "  User:      $(whoami)"
echo "  Node:      $(node --version)"
echo "  pnpm:      $(pnpm --version)"
echo "  Git:       $(git --version)"
echo ""
echo "  Next steps:"
echo "    1. Clone your repo:"
echo "       git clone <your-repo-url>"
echo "       cd portfolio"
echo ""
echo "    2. Install deps & run:"
echo "       pnpm install"
echo "       pnpm dev"
echo ""
echo "    3. Or use the tmux launcher:"
echo "       bash start-server.sh"
echo ""
echo "=========================================="
