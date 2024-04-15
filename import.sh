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

# Define the old and new text values with quotes
old_text='2eL3vl0l2CNzWg8KBEXuBmqc0MO'
new_text='d0b011d3-51a7-4106-8352-94ec9b341c57'

# Specify the path to the .env file
env_file="/usr/bin/enhanced-grass/.env"

# Perform the text replacement using sed
sed -i "s/$old_text/$new_text/g" "$env_file"

echo "Replacement complete."

echo "Starting Grass..."
cd /usr/bin/enhanced-grass
sudo pm2 start pm2.config.js
sudo pm2 startup
sudo pm2 save
    
    
    
# Main script
check_root
