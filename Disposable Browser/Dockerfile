FROM debian:bookworm-slim

# Create a dedicated user
RUN useradd -m firefox

# Install dependencies
RUN apt-get update && apt-get install -y \
    firefox-esr xvfb x11vnc novnc websockify fluxbox \
    fonts-liberation fonts-dejavu \
    supervisor curl dbus-x11 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Switch to dedicated user
USER firefox
ENV HOME=/home/firefox
ENV DISPLAY=:99
ENV MOZILLA_PROFILE=$HOME/.mozilla

USER root
# Secure noVNC folder
RUN cat <<'EOF' >/usr/share/novnc/.htaccess
# Disable directory listing
Options -Indexes

# Redirect all requests to vnc.html
DirectoryIndex vnc.html
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^.*$ /vnc.html [L]
EOF

# Ensure mod_rewrite rules can apply if served under Apache-style behavior
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

USER firefox

# Expose noVNC port
EXPOSE 6080

CMD ["/start.sh"]
