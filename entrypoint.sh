#!/bin/sh

# Tạo thư mục cấu hình nếu chưa tồn tại
mkdir -p /etc/v2ray

# Tạo file cấu hình từ biến môi trường
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
            "id": "${UUID}",
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
          "serverName": "v2ray-vmess.onrender.com"
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

# Chạy v2ray với cấu hình
exec /usr/bin/v2ray run -c /etc/v2ray/config.json