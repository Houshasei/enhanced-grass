#!/bin/bash

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[❗] Please run as root or using sudo"
        exit 1
    fi
}

    # Clone the GitHub repository and update the machine
    echo "[✅] Updating the machine..."
    sudo apt update
    sudo apt install git -y
    echo "[✅] Cloning the GitHub repository..."
    git clone https://github.com/Houshasei/enhanced-grass.git /usr/bin/enhanced-grass
    cd /usr/bin/enhanced-grass 
    sudo rm /etc/netplan/50-cloud-init.yaml
    sudo cp 50-cloud-init.yaml /etc/netplan/
    sudo netplan apply
    
    # Run the start.sh script to install necessary packages and dependencies
    echo "[✅] Running installation..."
    chmod +x update_netplan.sh
    sudo cp update_netplan.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable update_netplan.service
    chmod +x scripts/start.sh
    sudo ./scripts/start.sh

    echo "[✅] Installation completed. You can now check your Grass dashboard to see if the IP addresses are reflecting."
    
# Main script
check_root
