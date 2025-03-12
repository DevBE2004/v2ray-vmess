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
      "protocol": "${PROTOCOL:-vless}",
      "settings": {
        "clients": [
          {
            "id": "${UUID:-36cfc3de-ecfd-4752-ae6f-8f0f92035143}",
            "level": 0,
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "serverName": "${SERVER_NAME:-v2ray-vmess.onrender.com}" 
        },
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

# Grant execute permissions to the v2ray binary
chmod +x /usr/bin/v2ray

# Run v2ray with the generated config
exec /usr/bin/v2ray -config=/etc/v2ray/config.json