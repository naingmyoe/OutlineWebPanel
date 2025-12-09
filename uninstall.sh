#!/bin/bash

# Define Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (sudo su)${NC}"
  exit
fi

echo -e "${RED}======================================${NC}"
echo -e "${RED}   Outline Manager Uninstaller        ${NC}"
echo -e "${RED}======================================${NC}"

# 1. Remove Panel File
echo -e "${YELLOW}[1/2] Removing Web Panel Files...${NC}"
if [ -f "/var/www/html/index.html" ]; then
    rm -f /var/www/html/index.html
    echo -e "${GREEN}Panel file removed successfully.${NC}"
else
    echo -e "${RED}Panel file not found.${NC}"
fi

# 2. Ask to Remove Nginx
echo -e "${YELLOW}[2/2] Web Server Configuration${NC}"
echo -e "Do you want to completely remove Nginx Web Server?"
echo -e "${RED}Warning: If you are hosting other websites on this VPS, type 'n'.${NC}"
read -p "Uninstall Nginx? (y/n): " confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo -e "${YELLOW}Stopping and Removing Nginx...${NC}"
    systemctl stop nginx
    apt-get purge nginx nginx-common nginx-full -y
    apt-get autoremove -y
    rm -rf /etc/nginx
    echo -e "${GREEN}Nginx has been completely removed.${NC}"
else
    echo -e "${GREEN}Nginx was kept installed.${NC}"
    # Restore a simple default page so it doesn't show 403 error
    echo "<h1>Outline Manager Uninstalled</h1>" > /var/www/html/index.html
    systemctl restart nginx
fi

echo -e ""
echo -e "${GREEN}Uninstallation Complete.${NC}"
