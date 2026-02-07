#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# Start Next.js Dev Server inside tmux
# ============================================================
# Usage:  bash start-server.sh [dev|prod]
#   dev  — runs `pnpm dev`       (default, port 3000)
#   prod — runs `pnpm build && pnpm start` (port 3000)
#
# The server runs inside a tmux session named "nextjs"
# so it survives SSH disconnects and screen locks.
#
# Reattach anytime:  tmux attach -t nextjs
# Detach from tmux:  Ctrl+B, then D
# Kill session:      tmux kill-session -t nextjs
# ============================================================

set -e

MODE="${1:-dev}"
SESSION="nextjs"
PROJECT_DIR="$HOME/port"

# ------------------------------------------
# Validate
# ------------------------------------------
if [ ! -d "$PROJECT_DIR" ]; then
  echo "ERROR: Project directory not found: $PROJECT_DIR"
  echo "Clone your repo first:"
  echo "  git clone <your-repo-url> $PROJECT_DIR"
  exit 1
fi

# ------------------------------------------
# Kill existing session if any
# ------------------------------------------
tmux kill-session -t "$SESSION" 2>/dev/null || true

# ------------------------------------------
# Ensure sshd is running
# ------------------------------------------
if ! pgrep -x sshd > /dev/null; then
  echo "Starting SSH server..."
  sshd
fi

# ------------------------------------------
# Termux fix: os.cpus() returns [] on Android,
# which breaks concurrency libraries (p-limit).
# Preload a patch that returns a fake CPU entry.
# ------------------------------------------
export NODE_OPTIONS="--require $PROJECT_DIR/termux-cpu-fix.js"

# ------------------------------------------
# Start tmux session
# ------------------------------------------
if [ "$MODE" = "prod" ]; then
  echo "Starting PRODUCTION server in tmux session '$SESSION'..."
  tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" \
    "export NODE_OPTIONS='--require $PROJECT_DIR/termux-cpu-fix.js'; pnpm build && pnpm start; exec bash"
else
  echo "Starting DEV server in tmux session '$SESSION'..."
  tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" \
    "export NODE_OPTIONS='--require $PROJECT_DIR/termux-cpu-fix.js'; pnpm dev; exec bash"
fi

echo ""
echo "=========================================="
echo "  Server started in tmux session: $SESSION"
echo "=========================================="
echo ""
echo "  Mode:    $MODE"
echo "  Port:    3000"
echo "  Bound:   0.0.0.0 (accessible from all interfaces)"
echo ""
echo "  Access from laptop:"
echo "    Local Wi-Fi:  http://<phone-lan-ip>:3000"
echo "    Tailscale:    http://<phone-tailscale-ip>:3000"
echo ""
echo "  tmux commands:"
echo "    Attach:   tmux attach -t $SESSION"
echo "    Detach:   Ctrl+B, then D"
echo "    Kill:     tmux kill-session -t $SESSION"
echo ""
