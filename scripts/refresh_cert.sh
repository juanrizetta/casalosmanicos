#!/bin/bash

# Refresh SSL certificate if it will expire within 30 days
# This script is intended to be run weekly via cron.

# Configuration (same as in setup_vps.sh)
DOMAIN="casalosmanicos.es"
EMAIL="casalosmanicos@gmail.com"
CERT_PATH="/etc/letsencrypt/live/$DOMAIN/cert.pem"

# Check if certificate exists
if [ -f "$CERT_PATH" ]; then
    # Check if expires in less than 30 days (2592000 seconds)
    if openssl x509 -checkend 2592000 -noout -in "$CERT_PATH"; then
        echo "$(date): Certificate for $DOMAIN is still valid for more than 30 days. No action needed."
    else
        echo "$(date): Certificate for $DOMAIN expires soon. Renewing..."
        # Certbot renew handles all certificates and checks their expiration autonomously
        # Here we specifically target the domain for clarity, but 'renew' is the standard.
        certbot renew --cert-name "$DOMAIN" --non-interactive --post-hook "systemctl reload nginx"
    fi
else
    echo "$(date): No certificate found for $DOMAIN. Requesting a new one..."
    certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect
fi
