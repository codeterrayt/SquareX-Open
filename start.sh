#!/bin/bash
set -e

# Start virtual display
Xvfb :99 -screen 0 1280x800x16 &

# Start window manager (optional, for UI)
fluxbox &

# Start Chrome in background (non-headless for VNC)
chromium --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222 &

# Start VNC server on :99
x11vnc -display :99 -nopw -forever -shared -rfbport 5900 &

# Start noVNC websockify
websockify --web=/usr/share/novnc/ 6080 localhost:5900
