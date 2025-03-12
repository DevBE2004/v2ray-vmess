#!/bin/sh

# Create config directory if not exists
mkdir -p /etc/v2ray

# Generate config file with environment variables
rm -rf /etc/v2ray/config.json
cat << EOF > /etc/v2ray/config.json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": ${PORT:-443},
      "protocol": "${PROTOCOL:-vmess}",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "alterId": 0
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${PATH:-/v2ray}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIP"
      }
    }
  ],
  "dns": {
    "servers": [
      "8.8.8.8",
      "1.1.1.1"
    ]
  }
}
EOF

# Run v2ray with config
exec /usr/bin/v2ray run -c /etc/v2ray/config.json