#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <your-server-ip>"
    echo "Example: $0 192.168.1.100"
    exit 1
fi

IP=$1
PORT=${2:-8766}
echo "Configuring IP address: $IP Port: $PORT"

cd "$(dirname "$0")"

sed -i "s/39.105.134.68/$IP/g" xyh5/www/wwwroot/xy/cdn/serverlist.json
sed -i "s/39.105.134.68/$IP/g" xyh5/www/wwwroot/xy/cdn/serverlist.php

# Update URL with port
sed -i "s|http://[0-9.]*:[0-9]*/cdn/|http://$IP:$PORT/cdn/|g" xyh5/www/wwwroot/xy/cdn/preload.js
sed -i "s|http://[0-9.]*:[0-9]*/cdn/|http://$IP:$PORT/cdn/|g" xyh5/www/wwwroot/xy/cdn/index.min.html

echo "IP configuration complete!"
echo ""
echo "Game URL: http://$IP:$PORT/cdn/"
echo "GM URL: http://$IP:$PORT/gm/gm.php"
echo ""
echo "Now you can run: docker compose up -d"
