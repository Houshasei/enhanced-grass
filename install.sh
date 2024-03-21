#!/bin/bash

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[❗] Please run as root or using sudo"
        exit 1
    fi
}

    # Clone the GitHub repository
    echo "[✅] Cloning the GitHub repository..."
    sudo apt-get update
    sudo apt-get install git-all
    git clone https://github.com/Houshasei/enhanced-grass.git /usr/bin/enhanced-grass
    cd /usr/bin/enhanced-grass 
    sudo rm /etc/netplan/50-cloud-init.yaml
    sudo cp 50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    sudo netplan apply
    
    # Run the start.sh script to install necessary packages and dependencies
    echo "[✅] Running installation..."
    chmod +x scripts/start.sh
    sudo ./scripts/start.sh

    echo "[✅] Installation completed. You can now check your Grass dashboard to see if the IP addresses are reflecting."
    
# Main script
check_root
