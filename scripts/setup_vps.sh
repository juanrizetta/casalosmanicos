#!/bin/bash

# VPS Initialization Script for "Casa Los Manicos"
# Targeted for Ubuntu 20.04/22.04+
# This script is idempotent (safe to run multiple times).

set -e

# Configuration - CHANGE THESE
DOMAIN="casalosmanicos.com"
EMAIL="hola@casalosmanicos.com"
WEB_ROOT="/var/www/$DOMAIN"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Idempotent VPS Initialization...${NC}"

# Function to check if a package is installed
is_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

# 1. Update system
echo -e "${GREEN}1. Updating system packages...${NC}"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y

# 2. Install Nginx
if ! is_installed nginx; then
    echo -e "${GREEN}2. Installing Nginx...${NC}"
    sudo apt-get install -y nginx
else
    echo -e "${NC}2. Nginx is already installed.${NC}"
fi

# 3. Configure Firewall (UFW)
echo -e "${GREEN}3. Configuring UFW firewall...${NC}"
sudo ufw allow 'Nginx Full'
sudo ufw allow 'OpenSSH'
# Enable UFW if not already enabled
if [[ $(sudo ufw status | grep "Status: active") == "" ]]; then
    echo "y" | sudo ufw enable
fi

# 4. Create Web Directory
if [ ! -d "$WEB_ROOT" ]; then
    echo -e "${GREEN}4. Creating web root at $WEB_ROOT...${NC}"
    sudo mkdir -p "$WEB_ROOT"
    sudo chown -R $USER:$USER "$WEB_ROOT"
    sudo chmod -R 755 "$WEB_ROOT"
else
    echo -e "${NC}4. Web root directory already exists.${NC}"
fi

# 5. Create Nginx Site Configuration
echo -e "${GREEN}5. Configuring Nginx site...${NC}"
sudo tee /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name $DOMAIN www.$DOMAIN;

    root $WEB_ROOT;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # Cache Control for static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
}
EOF

# 6. Enable the site
if [ ! -f "/etc/nginx/sites-enabled/$DOMAIN" ]; then
    echo -e "${GREEN}6. Enabling the site...${NC}"
    sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
else
    echo -e "${NC}6. Site configuration is already enabled.${NC}"
fi

# 7. Test Nginx and reload
echo -e "${GREEN}7. Testing and reloading Nginx...${NC}"
sudo nginx -t
sudo systemctl reload nginx

# 8. SSL Configuration (Let's Encrypt / Certbot)
echo -e "${GREEN}8. Setting up SSL with Let's Encrypt...${NC}"
if ! is_installed certbot; then
    sudo apt-get install -y certbot python3-certbot-nginx
fi

# Check if certificates already exist
if [ ! -d "/etc/letsencrypt/live/$DOMAIN" ]; then
    echo -e "${GREEN}Requesting SSL certificate for $DOMAIN...${NC}"
    echo -e "${RED}IMPORTANT: Make sure your domain A record points to this IP before proceeding.${NC}"
    # Run certbot (non-interactive, needs domain to point to this IP)
    # We use --nginx plugin to automatically configure SSL in Nginx
    sudo certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect
else
    echo -e "${NC}SSL certificate for $DOMAIN already exists.${NC}"
    # Ensure renewal timer is active
    sudo systemctl status certbot.timer | grep "active" > /dev/null || sudo systemctl enable --now certbot.timer
fi

echo -e "${GREEN}VPS Initialization Complete!${NC}"
echo -e "Your site should now be live at: https://$DOMAIN"
