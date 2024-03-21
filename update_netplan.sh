#!/bin/bash

# Replace the file in /etc/netplan/
sudo rm /etc/netplan/50-cloud-init.yaml
sudo cp /usr/bin/enhanced-grass/50-cloud-init.yaml /etc/netplan/

# Apply the changes using netplan
sudo netplan apply
