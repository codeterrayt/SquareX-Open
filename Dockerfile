FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl gnupg2 ca-certificates supervisor \
    xvfb fluxbox x11vnc novnc websockify \
    chromium chromium-driver \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set display env
ENV DISPLAY=:99
ENV CHROME_FLAGS="--no-sandbox --disable-dev-shm-usage --disable-gpu --disable-software-rasterizer --headless=new --remote-debugging-port=9222"

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports
EXPOSE 6080

CMD ["/start.sh"]
