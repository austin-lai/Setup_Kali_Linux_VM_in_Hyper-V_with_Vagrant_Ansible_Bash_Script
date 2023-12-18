#!/bin/bash

# Get the current date in the format DDMMYYYY
current_date=$(date +'%d%m%Y-%H%M')

# The desired static IP address
IP="192.168.50.5"

# The network interface you want to configure
IFACE="eth0"
  
# Backup /etc/network/interfaces
sudo -S <<< "kali" cp -v /etc/network/interfaces /etc/network/interfaces.$current_date.bak
sudo -S <<< "kali" cat /etc/network/interfaces

sudo -S <<< "kali" ip a
