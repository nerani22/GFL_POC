#!/bin/bash
# myscript.sh - safe, portable POC script for Linux nodes
set -euo pipefail

echo "===== POC Script: Basic System Check ====="
echo "Host: $(hostname -f 2>/dev/null || hostname)"
echo "OS: $(. /etc/os-release && echo \"$NAME $VERSION\")"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo ""

echo "===== Resource Usage ====="
echo "Memory:"
free -h || true
echo ""
echo "Disk usage (root and /var and /home if present):"
df -h / /var /home 2>/dev/null || df -h || true
echo ""

echo "===== Top processes by CPU (top 5) ====="
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 || true
echo ""

echo "===== Connectivity Check ====="
if ping -c 2 8.8.8.8 >/dev/null 2>&1; then
  echo "Internet: OK"
else
  echo "Internet: FAILED (ping 8.8.8.8)"
fi

echo ""
echo "===== POC Script Completed ====="
exit 0
