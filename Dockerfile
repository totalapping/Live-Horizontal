FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg wget && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Copy script
COPY stream.sh /app/
RUN chmod +x /app/stream.sh

# Run script
CMD ["/app/stream.sh"]
