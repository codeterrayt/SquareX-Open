#!/bin/bash
set -e

# Ensure profile directory exists
mkdir -p "$MOZILLA_PROFILE"
export MOZILLA_PROFILE

# Start virtual display (large for scaling)
Xvfb :99 -screen 0 1920x1080x24 &
export DISPLAY=:99

# Start lightweight window manager
fluxbox &

# Launch Firefox in kiosk mode
# --kiosk
firefox-esr --profile "$MOZILLA_PROFILE"  "https://duckduckgo.com" &

# Start VNC server with dynamic resizing
x11vnc -display :99 \
        -nopw \
        -forever \
        -shared \
        -noxdamage \
        -ncache 10 &

# Wait until VNC server is ready
echo "Waiting for x11vnc..."
while ! timeout 0.1 bash -c "</dev/tcp/localhost/5900" 2>/dev/null; do
    sleep 0.5
done
echo "x11vnc is ready, starting noVNC"

# Start noVNC web proxy
websockify --web=/usr/share/novnc/ 6080 localhost:5900
