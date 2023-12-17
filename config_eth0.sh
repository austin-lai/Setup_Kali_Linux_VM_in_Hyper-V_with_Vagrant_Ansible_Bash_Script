#!/bin/bash

# Get the current date in the format DDMMYYYY
current_date=$(date +'%d%m%Y-%H%M')

# The desired static IP address
IP="192.168.50.5"

# The network interface you want to configure
IFACE="eth0"
  
# Backup /etc/network/interfaces
sudo -S <<< "kali" cp -v /etc/network/interfaces /etc/network/interfaces.$current_date.bak

# Update apt
# sudo -S <<< "kali" apt update -y

# Install nmcli
# sudo -S <<< "kali" apt install -y network-manager
# sudo -S <<< "kali" systemctl enable NetworkManager.service
# sudo -S <<< "kali" systemctl start NetworkManager.service 

# Configure the network interface
# sudo -S <<< "kali" nmcli con mod $IFACE ipv4.addresses $IP/24
# sudo -S <<< "kali" nmcli con mod $IFACE ipv4.method manual

# Restart the networking service for the changes to take effect
# sudo -S <<< "kali" systemctl restart NetworkManager.service 

# sudo -S <<< "kali" systemctl restart networking
sleep 2
sudo -S <<< "kali" ip a | grep -A 10 $IFACE

