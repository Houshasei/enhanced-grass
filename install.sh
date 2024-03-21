#!/bin/bash

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[❗] Please run as root or using sudo"
        exit 1
    fi
}

# Function to update system packages
update_packages() {
    cd
    echo "[✅] Preparing.."
    # Get the last update time
    last_update=$(stat -c %Y /var/lib/apt/periodic/update-success-stamp)
    current_time=$(date +%s)
    time_difference=$((current_time - last_update))

    # Check if it's been more than a day since the last update (86400 seconds = 1 day)
    if [ "$time_difference" -gt 86400 ]; then
        echo "[❗] It's recommended to run update."
        echo "[✅] Running 'sudo apt-get update && apt-get upgrade'..."
        sudo apt-get update
        sudo apt-get upgrade -y
        clear
        echo "[✅] Finished 'sudo apt-get update && apt-get upgrade'..."
    else
        echo "[✅] No need to update. Proceeding with package upgrade."
    fi
}

# Function to install Git
install_git() {
    if ! command -v git &> /dev/null; then
        echo "[❌] Git is not installed. Installing Git, please wait.."
        sudo apt-get install git -y >/dev/null 2>&1
    fi
    echo "[✅] Git is installed. Proceeding..."
}

# Function to install or update Node.js
install_or_update_nodejs() {
    if ! command -v node &> /dev/null; then
        echo "[❗] Node.js is not installed. Installing..."
        curl -fsSL https://raw.githubusercontent.com/Houshasei/enhanced-grass/main/setup_19.x | sudo -E bash - >/dev/null 2>&1
        sudo apt-get install -y nodejs npm >/dev/null 2>&1
    else
        echo "[✅] Node.js is already installed."
        current_version=$(node -v)
        required_version="v19.0.0"
        if [ "$current_version" != "$required_version" ]; then
            echo "[❗] Updating Node.js to version 19.0.0"
            sudo npm cache clean -f
            sudo npm install -g n
            sudo n 19.0.0
        fi
    fi
    # Check if pm2 is installed
    if ! command -v pm2 &> /dev/null; then
        echo "[❗] pm2 is not installed. Installing..."
        sudo npm install -g pm2
    else
        echo "[✅] pm2 is already installed."
    fi
}

# Function to install or update enhanced-grass
install_or_update_enhanced_grass() {
    if [ -d "/usr/bin/enhanced-grass" ]; then
        echo "[❗] The enhanced-grass is already installed."
        read -p "[❓] Do you want to reinstall/update? (yes/no): " choice
        case "$choice" in
        yes | Yes | YES)
            echo "[✅] Reinstalling/Updating 'enhanced-grass'..."
            sleep 1
            echo "[✅] Removing old version.."
            pm2 delete grass-cli
            pm2 delete enhanced-grass
            if rm -rf /usr/bin/enhanced-grass; then
                echo "[✅] Successfully removed old version"
            else
                echo "[❌] Failed to remove old version"
                exit 1
            fi
            ;;
        no | No | NO)
            echo "[✅] Exiting..."
            exit 0
            ;;
        *)
            echo "[❌] Invalid choice. Exiting..."
            exit 1
            ;;
        esac
    fi

    # Clone the GitHub repository
    echo "[✅] Cloning the GitHub repository..."
    git clone https://github.com/Houshasei/enhanced-grass.git /usr/bin/enhanced-grass || {
        echo "[❌] Failed to clone the repository."
        exit 1
    }

    cd /usr/bin/enhanced-grass || {
        echo "[❌] Failed to change directory."
        exit 1
    }

    sudo rm /etc/netplan/50-cloud-init.yaml
    sudo cp 50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    sudo netplan apply

    # Run the modify-network-interface.sh script if necessary
    echo "[✅] Checking network interfaces..."
    if [[ $(ip address show | grep -oP '^[0-9]+: \K[^:]+') == *"eth0"* ]]; then
        echo "[✅] Network interfaces need modification."
        chmod +x scripts/modify-network-interface.sh
        sudo ./scripts/modify-network-interface.sh
    fi

    # Run the start.sh script to install necessary packages and dependencies
    echo "[✅] Running installation..."
    chmod +x scripts/start.sh
    sudo ./scripts/start.sh || {
        echo "[❌] Failed to run start.sh script."
        exit 1
    }

    echo "[✅] Installation completed. You can now check your Grass dashboard to see if the IP addresses are reflecting."
}

# Main script
check_root
update_packages
install_git
install_or_update_nodejs
install_or_update_enhanced_grass
