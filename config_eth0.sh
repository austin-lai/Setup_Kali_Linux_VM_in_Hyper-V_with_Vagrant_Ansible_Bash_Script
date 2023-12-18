#!/bin/bash

# Get the current date in the format DDMMYYYY
current_date=$(date +'%d%m%Y-%H%M')

# Backup /etc/network/interfaces
sudo -S <<< "kali" cp -v /etc/network/interfaces /etc/network/interfaces.$current_date.bak
sudo -S <<< "kali" cat /etc/network/interfaces

sudo -S <<< "kali" ip a
