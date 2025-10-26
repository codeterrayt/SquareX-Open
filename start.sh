#!/bin/bash
set -e

# Ensure profile directory exists
mkdir -p $MOZILLA_PROFILE
export MOZILLA_PROFILE

# Start virtual display
Xvfb :99 -screen 0 1920x1080x24 &

# Start lightweight window manager
fluxbox &

# Launch Firefox in kiosk mode
firefox-esr --profile $MOZILLA_PROFILE --kiosk "duckduckgo.com" &

# Start VNC server
x11vnc -display :99 -nopw -forever -shared -rfbport 5900 &

# Start noVNC web proxy
websockify --web=/usr/share/novnc/ 6080 localhost:5900
