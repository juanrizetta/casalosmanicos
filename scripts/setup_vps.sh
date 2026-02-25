#!/bin/bash

# VPS Initialization Script for "Casa Los Manicos"
# Targeted for Ubuntu 20.04/22.04+

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting VPS Initialization...${NC}"

# 1. Update system
echo -e "${GREEN}Updating system packages...${NC}"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y

# 2. Install Nginx
echo -e "${GREEN}Installing Nginx...${NC}"
sudo apt-get install -y nginx

# 3. Configure Firewall (UFW)
echo -e "${GREEN}Configuring UFW firewall...${NC}"
sudo ufw allow 'Nginx Full'
sudo ufw allow 'OpenSSH'
echo "y" | sudo ufw enable

# 4. Create Web Directory
DOMAIN="casalosmanicos.com" # Change this as needed
WEB_ROOT="/var/www/$DOMAIN"
echo -e "${GREEN}Creating web root at $WEB_ROOT...${NC}"
sudo mkdir -p "$WEB_ROOT"
sudo chown -R $USER:$USER "$WEB_ROOT"
sudo chmod -R 755 "$WEB_ROOT"

# 5. Backup default Nginx config and create new one
echo -e "${GREEN}Configuring Nginx site...${NC}"
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
sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 7. Test Nginx and reload
echo -e "${GREEN}Testing Nginx configuration...${NC}"
sudo nginx -t
sudo systemctl reload nginx

echo -e "${GREEN}VPS Initialization Complete!${NC}"
echo -e "Next steps: "
echo -e "1. Point your domain A record to this VPS IP."
echo -e "2. Upload your static files to $WEB_ROOT."
echo -e "3. (Optional) Run 'sudo apt install certbot python3-certbot-nginx && sudo certbot --nginx' for SSL."
