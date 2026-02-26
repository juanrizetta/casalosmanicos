#!/bin/bash

# VPS Initialization Script for "Casa Los Manicos"
# Targeted for Ubuntu 20.04/22.04+
# This script is idempotent and handles user creation, git sync, and SSL.

set -e

# Configuration
DOMAIN="casalosmanicos.es"
EMAIL="casalosmanicos@gmail.com"
NEW_USER="juanri"
REPO_URL="github.com/juanrizetta/casalosmanicos.git"

# Ensure GITHUB_TOKEN is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "\033[0;31mERROR: GITHUB_TOKEN is not set. Please export it first.\033[0m"
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Starting Robust VPS Initialization...${NC}"

# 1. Create User
if ! id "$NEW_USER" &>/dev/null; then
    sudo adduser --disabled-password --gecos "" "$NEW_USER"
    sudo usermod -aG sudo "$NEW_USER"
fi
# Fix permissions for Nginx traversal
sudo chmod o+x /home/$NEW_USER
sudo chmod -R o+rx /home/$NEW_USER/app

# 2. Dependencies
sudo apt-get update
sudo apt-get install -y git nginx ufw certbot python3-certbot-nginx dnsutils curl

# 3. Firewall
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx Full'
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
if [[ $(sudo ufw status | grep "Status: active") == "" ]]; then echo "y" | sudo ufw enable; fi

# 4. Git Sync
PROJECT_DIR="/home/$NEW_USER/appl/casalosmanicos"
sudo mkdir -p "/home/$NEW_USER/appl"
sudo chown -R $NEW_USER:$NEW_USER "/home/$NEW_USER/appl"

if [ ! -d "$PROJECT_DIR" ]; then
    sudo -u "$NEW_USER" git clone "https://$GITHUB_TOKEN@$REPO_URL" "$PROJECT_DIR"
else
    cd "$PROJECT_DIR"
    sudo -u "$NEW_USER" git pull
fi

# 5. Nginx Configuration (Idempotent for SSL)
WEB_ROOT="/var/www/$DOMAIN"
CONF_FILE="/etc/nginx/sites-available/$DOMAIN"

# Remove existing root if not a link
if [ -e "$WEB_ROOT" ] && [ ! -L "$WEB_ROOT" ]; then sudo rm -rf "$WEB_ROOT"; fi
sudo ln -sfn "$PROJECT_DIR/public" "$WEB_ROOT"

# Only write base config if it doesn't have SSL managed by certbot yet
if ! grep -q "managed by Certbot" "$CONF_FILE" 2>/dev/null; then
    echo -e "${GREEN}Writing base Nginx configuration...${NC}"
    sudo tee "$CONF_FILE" <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name $DOMAIN www.$DOMAIN;
    root $WEB_ROOT;
    index index.html;
    location / { try_files \$uri \$uri/ =404; }
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
}
EOF
else
    echo -e "${NC}Nginx config already contains SSL (managed by Certbot). Skipping overwrite.${NC}"
fi

# 6. Enable site
sudo ln -sf "$CONF_FILE" /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default || true
sudo nginx -t && sudo systemctl reload nginx

# 7. SSL - Certbot
echo -e "${GREEN}Verifying SSL status...${NC}"
PUBLIC_IP=$(curl -s https://ifconfig.me)
DNS_IP=$(dig +short "$DOMAIN" | tail -n1)

echo -e "Server IP: $PUBLIC_IP | Domain $DOMAIN points to: $DNS_IP"

CERT_PATH="/etc/letsencrypt/live/$DOMAIN/cert.pem"
if [ -f "$CERT_PATH" ]; then
    echo -e "${NC}Checking certificate expiration for $DOMAIN...${NC}"
    # Check if the certificate expires in the next 30 days (2592000 seconds)
    if sudo openssl x509 -checkend 2592000 -noout -in "$CERT_PATH"; then
        echo -e "${GREEN}Certificate is still valid for more than 30 days. Skipping renewal/re-installation.${NC}"
    else
        echo -e "${YELLOW}Certificate expires in less than 30 days. Updating Nginx configuration...${NC}"
        sudo certbot install --nginx --cert-name "$DOMAIN" --non-interactive --redirect
    fi
else
    echo -e "${YELLOW}No certificate found. Requesting new one...${NC}"
    sudo certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect || echo -e "${RED}Certbot failed. Check DNS propagation.${NC}"
fi

sudo systemctl reload nginx

# Ensure scripts are executable
sudo chmod +x "$PROJECT_DIR/scripts/setup_vps.sh"
sudo chmod +x "$PROJECT_DIR/scripts/refresh_cert.sh"

echo -e "${GREEN}Done! Try visiting https://$DOMAIN${NC}"

echo -e "Diagnostics: sudo netstat -tulpn | grep nginx"

# Ensure weekly cron for certificate refresh (as root)
CRON_CMD="$PROJECT_DIR/scripts/refresh_cert.sh >> /var/log/refresh_cert.log 2>&1"
# Add cron if not already present in root's crontab
(sudo crontab -l 2>/dev/null | grep -F "$CRON_CMD") || (sudo crontab -l 2>/dev/null; echo "@weekly $CRON_CMD") | sudo crontab -
