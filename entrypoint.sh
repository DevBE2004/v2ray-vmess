#!/bin/sh

# Create config directory if not exists
mkdir -p /etc/v2ray

# Config v2ray
rm -rf /etc/v2ray/config.json
cat << EOF > /etc/v2ray/config.json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "$PROTOCOL",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "alterId": 0
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

# Run v2ray
/usr/bin/v2ray -config /etc/v2ray/config.json