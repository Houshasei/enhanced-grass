#!/bin/bash

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[❗] Please run as root or using sudo"
        exit 1
    fi
}

# Kill the PM2 process and daemon
sudo pm2 kill
sudo pm2 unstartup

# Fetch the latest certs and constants for already installed packages
curl -O https://raw.githubusercontent.com/Houshasei/enhanced-grass/main/src/ssl/websocket.pem
curl -O https://raw.githubusercontent.com/Houshasei/enhanced-grass/main/src/constants.js
sudo mv -f websocket.pem /usr/bin/enhanced-grass/src/ssl
sudo mv -f constants.js /usr/bin/enhanced-grass/src

echo "Starting Grass..."
cd /usr/bin/enhanced-grass
sudo pm2 start pm2.config.js
sudo pm2 startup
sudo pm2 save



# Main script
check_root
