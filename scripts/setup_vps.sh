#!/bin/bash

# VPS Initialization Script for "Casa Los Manicos"
# Targeted for Ubuntu 20.04/22.04+
# This script is idempotent and handles user creation + git sync.

set -e

# Configuration
DOMAIN="casalosmanicos.es"
EMAIL="casalosmanicos@gmail.com"
NEW_USER="juanri"
REPO_URL="github.com/juanrizetta/casalosmanicos.git"

# Ensure GITHUB_TOKEN is set as an environment variable
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "\033[0;31mERROR: GITHUB_TOKEN is not set. Please export it before running:\033[0m"
    echo -e "export GITHUB_TOKEN='your_token'"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Robust VPS Initialization...${NC}"

# Function to check if a package is installed
is_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

# 1. Create User 'juanri'
echo -e "${GREEN}1. Configuring user $NEW_USER...${NC}"
if ! id "$NEW_USER" &>/dev/null; then
    sudo adduser --disabled-password --gecos "" "$NEW_USER"
    sudo usermod -aG sudo "$NEW_USER"
    echo -e "${GREEN}User $NEW_USER created and added to sudoers.${NC}"
else
    echo -e "${NC}User $NEW_USER already exists.${NC}"
fi

# Fix permissions for Nginx traversal
sudo chmod o+x /home/$NEW_USER

# 2. Update system and install dependencies
echo -e "${GREEN}2. Updating system and installing dependencies...${NC}"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y git nginx ufw certbot python3-certbot-nginx dnsutils

# 3. Configure Firewall (UFW)
echo -e "${GREEN}3. Configuring UFW firewall...${NC}"
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx Full'
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
if [[ $(sudo ufw status | grep "Status: active") == "" ]]; then
    echo "y" | sudo ufw enable
fi

# 4. Clone / Sync Repository
PROJECT_DIR="/home/$NEW_USER/app/casalosmanicos"
echo -e "${GREEN}4. Synchronizing repository...${NC}"
sudo mkdir -p "/home/$NEW_USER/app"
sudo chown -R $NEW_USER:$NEW_USER "/home/$NEW_USER/app"

if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${GREEN}Cloning repository...${NC}"
    sudo -u "$NEW_USER" git clone "https://$GITHUB_TOKEN@$REPO_URL" "$PROJECT_DIR"
else
    echo -e "${NC}Repository already exists. Pulling latest changes...${NC}"
    cd "$PROJECT_DIR"
    sudo -u "$NEW_USER" git pull
fi

# 5. Nginx Configuration & Symbolic Link
WEB_ROOT="/var/www/$DOMAIN"
echo -e "${GREEN}5. Configuring Nginx...${NC}"

if [ -e "$WEB_ROOT" ] || [ -L "$WEB_ROOT" ]; then
    sudo rm -rf "$WEB_ROOT"
fi
sudo ln -sfn "$PROJECT_DIR/public" "$WEB_ROOT"

sudo tee /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

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
    sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
fi
sudo rm -f /etc/nginx/sites-enabled/default || true

sudo nginx -t && sudo systemctl reload nginx

# 7. SSL Configuration (Detailed Diagnostics)
echo -e "${GREEN}7. Ensuring SSL Certificate...${NC}"

# Pre-flight DNS check
PUBLIC_IP=$(curl -s https://ifconfig.me)
DNS_IP=$(dig +short "$DOMAIN" | tail -n1)

echo -e "Server IP: $PUBLIC_IP"
echo -e "Domain $DOMAIN points to: $DNS_IP"

if [ -z "$DNS_IP" ]; then
    echo -e "${RED}WARNING: Domain $DOMAIN has no A record. SSL acquisition will fail.${NC}"
elif [ "$DNS_IP" != "$PUBLIC_IP" ]; then
    echo -e "${YELLOW}WARNING: Domain $DOMAIN points to $DNS_IP, but this server is $PUBLIC_IP. SSL might fail.${NC}"
fi

if [ ! -d "/etc/letsencrypt/live/$DOMAIN" ]; then
    echo -e "${GREEN}Attemping SSL acquisition via Certbot...${NC}"
    if sudo certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect; then
        echo -e "${GREEN}SSL Certificate obtained successfully!${NC}"
    else
        echo -e "${RED}Certbot FAILED.${NC}"
        echo -e "${YELLOW}Common reasons for failure:${NC}"
        echo -e "1. DNS A record has not propagated yet (can take 1-24h)."
        echo -e "2. Port 80 or 443 blocked by VPS provider's external firewall (e.g. AWS Security Groups, Google Cloud Firewall)."
        echo -e "3. Domain ownership could not be verified by Let's Encrypt."
    fi
else
    echo -e "${NC}SSL already active.${NC}"
fi

echo -e "${GREEN}Initialization Finalized!${NC}"
echo -e "Visit: https://$DOMAIN"
