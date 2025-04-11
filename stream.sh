#!/bin/bash

# Create app directory if not exists
mkdir -p /app

# Download video if not already downloaded
if [ ! -f "/app/video.mp4" ]; then
  echo "[$(date)] Downloading video..."
  wget -q --show-progress https://github.com/totalapping/Live-Horizontal/releases/download/v1.0/live.mp4 -O /app/video.mp4
fi

# Verify video exists
if [ ! -f "/app/video.mp4" ]; then
  echo "[$(date)] ERROR: Video file missing!"
  exit 1
fi

# Lightweight dummy HTTP server for health check (runs in background)
python3 -m http.server 8000 &

# Start infinite stream loop
while true; do
  echo "[$(date)] Starting FFmpeg stream..."
  ffmpeg -re -stream_loop -1 -i /app/video.mp4 \
    -c:v libx264 -preset veryfast -b:v 1800k -maxrate 1800k -bufsize 3600k \
    -vf "scale=1280:720,fps=30" -g 60 -keyint_min 30 \
    -c:a aac -b:a 96k -ar 44100 -f flv "rtmp://a.rtmp.youtube.com/live2/2y18-4tcf-0dfc-d5jp-3wq5"

  echo "[$(date)] FFmpeg exited. Restarting in 5 seconds..."
  sleep 5
done


