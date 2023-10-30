#!/bin/bash

## Function to check if lolcat is installed and install it if not
#check_and_install_lolcat() {
#  if ! command -v lolcat &> /dev/null; then
#    echo "lolcat is not installed. Installing lolcat..."
#    sudo apt-get install lolcat -y
#  fi
#}

## Function to check if echo is installed and install it if not
#check_and_install_echo() {
#  if ! command -v echo &> /dev/null; then
#    echo "echo is not installed. Installing echo..."
#    sudo apt-get install echo -y
#  fi
#}

# Function to display a welcome message with echo and lolcat
welcome_message() {
  #check_and_install_lolcat
  #check_and_install_echo
  echo "SIEM & HIDS Setup"
  echo "This script will help you set up a security monitoring environment."
  echo "It includes the following components:"
  echo "1. SIEM (Elasticsearch, Kibana, Filebeat)"
  echo "2. NIDS (Suricata)"
  echo "3. HIDS (Wazuh Manager)"
  echo "The SIEM will be installed with Elasticsearch version 7.17.13 and Wazuh version 4.5, as they were compatible during the script creation."
}


# Function to install SIEM and display a message with echo and lolcat
install_siem() {
  #check_and_install_lolcat
  echo "Starting SIEM Setup"
  chmod +x siem_setup.sh
  ./siem_setup.sh
  echo "SIEM Setup Completed"
  read -p "Press Enter to continue..."
}

# Function to install Suricata (NIDS) and display a message with echo and lolcat
install_suricata() {
  #check_and_install_lolcat
  echo "Starting Suricata Setup"
  chmod +x suricata_setup.sh
  ./suricata_setup.sh
  echo "Suricata Setup Completed"
  read -p "Press Enter to continue..."
}

# Function to install Wazuh (HIDS) and display a message with echo and lolcat
install_wazuh() {
  #check_and_install_lolcat
  echo "Starting Wazuh Setup"
  chmod +x wazuh_setup.sh
  ./wazuh_setup.sh
  echo "Wazuh Setup Completed"
  read -p "Press Enter to continue..."
}

# Function to check system requirements
check_system_requirements() {
  #check_and_install_lolcat
  total_ram=$(free -m | awk '/^Mem:/{print $2}')
  available_disk_space=$(df -BG / | awk 'NR==2{print $4}' | tr -d 'G')

  echo "Checking Requirements"
  echo "Total RAM: ${total_ram} MB"
  echo "Available Disk Space: ${available_disk_space} GB"

  if [ "$total_ram" -lt 4096 ] || [ "$available_disk_space" -lt 20 ]; then
    echo "Warning: Not Enough Resources."
    read -p "Do you want to continue with the installation? (y/n): " continue_choice
    if [ "$continue_choice" != "y" ]; then
      echo "Setup Aborted"
      exit 1
    fi
  else
    echo "Requirements Met"
    echo "System requirements met. Continuing with the installation."
  fi
}

# Color codes for formatting
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Welcome message and description
echo -e "${GREEN}Welcome to the SIEM, HIDS, and NIDS Setup Script${NC}"

# Ask for user confirmation to continue
read -p "Do you want to proceed with the setup? (y/n): " choice

if [ "$choice" != "y" ]; then
  echo "Setup Aborted"
  exit 1
fi

# Check system requirements
check_system_requirements

# Ask the user which components to install
read -p "Do you want to install the SIEM (Elasticsearch, Kibana, Filebeat)? (y/n): " install_siem_choice
if [ "$install_siem_choice" == "y" ]; then
  install_siem
fi

read -p "Do you want to install Suricata (NIDS)? (y/n): " install_suricata_choice
if [ "$install_suricata_choice" == "y" ]; then
  install_suricata
fi

read -p "Do you want to install Wazuh (HIDS)? (y/n): " install_wazuh_choice
if [ "$install_wazuh_choice" == "y" ]; then
  install_wazuh
fi

echo "All done!"
