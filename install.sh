#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN="erfan.paydar.store"
PORT="2052"
GITHUB_USER="YOUR_GITHUB_USER"
REPO_NAME="bio"

echo -e "${CYAN}Deploying Web3 Bio on $DOMAIN (Port $PORT)...${NC}"

# 1. Install Nginx & Curl
sudo apt update -y && sudo apt install -y nginx curl

# 2. Download index.html from GitHub
sudo mkdir -p /var/www/html
sudo rm -rf /var/www/html/*
sudo curl -sL "https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/main/index.html" -o /var/www/html/index.html

# 3. Configure Nginx for erfan.paydar.store on Port 2052
cat << EOF | sudo tee /etc/nginx/sites-available/$DOMAIN > /dev/null
server {
    listen $PORT;
    listen [::]:$PORT;
    server_name $DOMAIN;
    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 4. Set permissions & restart Nginx
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo systemctl restart nginx
sudo systemctl enable nginx

# 5. Open firewall port 2052
sudo ufw allow $PORT/tcp 2/>/dev/null || true

echo -e "\n${GREEN}==============================================${NC}"
echo -e "${GREEN}✅ Deployed Successfully on Port $PORT!${NC}"
echo -e "${CYAN}🌐 Address: http://$DOMAIN:$PORT${NC}"
echo -e "${CYAN}🟣 Cloudflare Proxy: https://$DOMAIN${NC}"
echo -e "${GREEN}==============================================${NC}\n"
