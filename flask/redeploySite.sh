#!/usr/bin/env bash

cd /root/JPverse || { echo "Folder not found."; exit 1; }

git fetch && git reset origin/main --hard || { echo "Git update failed."; exit 1; }

source venv/bin/activate || { echo "Failed to activate virtual environment."; exit 1; }

pip install -r requirements.txt || { echo "Dependency installation failed."; exit 1; }

systemctl restart myportfolio || { echo "Failed to restart myportfolio service."; exit 1; }

echo "Deployment complete. Service restarted successfully."
