FROM debian:bookworm-slim

# Create dedicated user
RUN useradd -m firefox

# Install dependencies
RUN apt-get update && apt-get install -y \
    firefox-esr xvfb x11vnc novnc websockify fluxbox \
    fonts-liberation fonts-dejavu \
    supervisor curl dbus-x11 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy start script as root
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Switch to dedicated user at the end
USER firefox
ENV HOME=/home/firefox
ENV DISPLAY=:99
ENV MOZILLA_PROFILE=$HOME/.mozilla

EXPOSE 6080
CMD ["/start.sh"]
