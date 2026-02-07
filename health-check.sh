#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# Health Check — Verify everything is running
# ============================================================
# Usage:  bash health-check.sh
# ============================================================

echo "=========================================="
echo "  Termux Dev Server — Health Check"
echo "=========================================="
echo ""

# SSH
if pgrep -x sshd > /dev/null; then
  echo "  [✓] SSH server running (port 8022)"
else
  echo "  [✗] SSH server NOT running — start with: sshd"
fi

# tmux
if tmux has-session -t nextjs 2>/dev/null; then
  echo "  [✓] tmux session 'nextjs' active"
else
  echo "  [✗] tmux session 'nextjs' NOT found — start with: bash start-server.sh"
fi

# Node
if command -v node &> /dev/null; then
  echo "  [✓] Node.js $(node --version)"
else
  echo "  [✗] Node.js NOT installed"
fi

# pnpm
if command -v pnpm &> /dev/null; then
  echo "  [✓] pnpm $(pnpm --version)"
else
  echo "  [✗] pnpm NOT installed"
fi

# Port 3000
if ss -tlnp 2>/dev/null | grep -q ":3000" || netstat -tlnp 2>/dev/null | grep -q ":3000"; then
  echo "  [✓] Port 3000 is listening"
else
  echo "  [✗] Port 3000 NOT listening — server may not be running"
fi

# IPs
echo ""
echo "  Network IPs:"

# LAN IP
LAN_IP=$(ip -4 addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "N/A")
echo "    Wi-Fi (LAN):    $LAN_IP"

# Tailscale IP
TS_IP=$(ip -4 addr show tailscale0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "N/A (is Tailscale running?)")
echo "    Tailscale:      $TS_IP"

echo ""
echo "  Access URLs:"
echo "    Local:     http://$LAN_IP:3000"
echo "    Remote:    http://$TS_IP:3000"
echo ""
echo "=========================================="
