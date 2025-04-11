#!/bin/bash

# Create app directory if not exists
mkdir -p /app
# Start fake web server to avoid sleep/health error
python3 -m http.server 8000 &
# Download video only if not already present (with retries)
if [ ! -f "/app/video.mp4" ]; then
  echo "[$(date)] Downloading video..." >> /app/stream.log
  for i in {1..5}; do
    wget https://github.com/totalapping/Live-Horizontal/releases/download/v1.0/live.mp4 -O /app/video.mp4
    if [ $? -eq 0 ]; then
      echo "[$(date)] Download successful" >> /app/stream.log
      break
    else
      echo "[$(date)] Download attempt $i failed" >> /app/stream.log
      sleep 10
    fi
  done
fi

# Verify video exists before streaming
if [ ! -f "/app/video.mp4" ]; then
  echo "[$(date)] ERROR: Video file missing!" >> /app/stream.log
  exit 1
fi

# Infinite streaming loop
while true; do
  echo "[$(date)] Starting stream..." >> /app/stream.log
  
  ffmpeg -re -stream_loop -1 -i "/app/video.mp4" \
    -c:v libx264 -preset veryfast -b:v 2500k -maxrate 2500k -bufsize 5000k \
    -vf "scale=1280:720,fps=30" -g 60 -keyint_min 30 \
    -c:a aac -b:a 128k -ar 44100 \
    -f flv "rtmp://a.rtmp.youtube.com/live2/jybj-1ruf-js34-kyqc-5acf" 2>> /app/ffmpeg.log
  
  # If stream crashes
  echo "[$(date)] Stream crashed! Restarting in 5 seconds..." >> /app/stream.log
  sleep 5
done
