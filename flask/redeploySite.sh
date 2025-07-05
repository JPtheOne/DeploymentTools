#!/usr/bin/env bash

tmux kill-session -t flask_server || true
cd /root/JPverse || { echo "Folder not found."; exit 1; }

tmux new-session -d -s flask_server "
  cd /root/JPverse && \
  source venv/bin/activate && \
  flask run --host=0.0.0.0 --port=5000
"

echo "Flask server running in tmux session 'flask_server'."
