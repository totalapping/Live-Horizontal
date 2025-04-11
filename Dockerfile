FROM ubuntu:22.04

# Install only essential packages
RUN apt-get update && \
    apt-get install -y ffmpeg wget python3 && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy script
COPY stream.sh /app/
RUN chmod +x /app/stream.sh

# Expose port for dummy health server
EXPOSE 8000

# Start script
CMD ["/app/stream.sh"]


