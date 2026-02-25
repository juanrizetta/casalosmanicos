#!/bin/bash

# VPS Initialization Script for "Casa Los Manicos"
# Targeted for Ubuntu 20.04/22.04+
# This script is idempotent and handles user creation + git sync.

set -e

# Configuration
DOMAIN="casalosmanicos.com"
EMAIL="hola@casalosmanicos.com"
NEW_USER="juanri"
REPO_URL="github.com/juanrizetta/casalosmanicos.git"
# Ensure GITHUB_TOKEN is set as an environment variable
if [ -z "$GITHUB_TOKEN" ]; then
    echo "ERROR: GITHUB_TOKEN is not set. Please export it before running: export GITHUB_TOKEN='your_token'"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Advanced VPS Initialization...${NC}"

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

# 2. Update system and install dependencies
echo -e "${GREEN}2. Updating system and installing git/nginx...${NC}"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y git nginx ufw certbot python3-certbot-nginx

# 3. Configure Firewall (UFW)
echo -e "${GREEN}3. Configuring UFW firewall...${NC}"
sudo ufw allow 'Nginx Full'
sudo ufw allow 'OpenSSH'
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
    # Using HTTPS with token for authentication
    sudo -u "$NEW_USER" git clone "https://$GITHUB_TOKEN@$REPO_URL" "$PROJECT_DIR"
else
    echo -e "${NC}Repository already exists. Pulling latest changes...${NC}"
    cd "$PROJECT_DIR"
    sudo -u "$NEW_USER" git pull
fi

# 5. Nginx Configuration & Symbolic Link
WEB_ROOT="/var/www/$DOMAIN"
echo -e "${GREEN}5. Configuring Nginx with symbolic links...${NC}"

# Remove existing root if it exists and is NOT a link or is the wrong link
if [ -d "$WEB_ROOT" ] && [ ! -L "$WEB_ROOT" ]; then
    sudo rm -rf "$WEB_ROOT"
fi

# Create symbolic link from repo's public folder to Nginx root
sudo ln -sfn "$PROJECT_DIR/public" "$WEB_ROOT"

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
    sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
fi

sudo nginx -t && sudo systemctl reload nginx

# 7. SSL Configuration
echo -e "${GREEN}7. Ensuring SSL Certificate...${NC}"
if [ ! -d "/etc/letsencrypt/live/$DOMAIN" ]; then
    echo -e "${RED}Attemping to obtain SSL for $DOMAIN (requires DNS pointing to this IP)...${NC}"
    sudo certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect || echo -e "${RED}Certbot failed. Make sure DNS is correct.${NC}"
else
    echo -e "${NC}SSL already active.${NC}"
fi

echo -e "${GREEN}Initialization Finalized Successfully!${NC}"
echo -e "User: $NEW_USER (sudoer)"
echo -e "Project path: $PROJECT_DIR"
echo -e "Web accessible at: https://$DOMAIN"
