FROM ubuntu:22.04

# Reduce image size and install only what's needed
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ffmpeg wget ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy stream script
COPY stream.sh /app/
RUN chmod +x /app/stream.sh

# Health check (optional but helpful for Koyeb stability)
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD pgrep ffmpeg || exit 1

# Start script
CMD ["/app/stream.sh"]

