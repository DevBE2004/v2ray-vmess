#!/bin/sh

# Config xray client
rm -rf /etc/xray/config.json
cat << EOF > /etc/xray/config.json
{
  "inbounds": [
    {
      "port": ${PORT:-1080},                    # Cổng SOCKS local
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [],
        "enabled": false,
        "routeOnly": false
      },
      "tag": "socks-in"
    }
  ],
  "outbounds": [
    {
      "mux": {
        "concurrency": -1,
        "enabled": false
      },
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "${ADDRESS:-ws-ecw0.onrender.com}",
            "port": ${VPORT:-443},
            "users": [
              {
                "id": "${UUID:-36cfc3de-ecfd-4752-ae6f-8f0f92035143}",
                "level": 8,
                "security": "auto"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",                     # Thêm TLS
        "tlsSettings": {
          "serverName": "ws-ecw0.onrender.com" # Domain của server
        },
        "wsSettings": {
          "host": "${HOST:-m.youtube.com}",
          "path": "${PATH:-/anhtu}"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIP"
      },
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "outboundTag": "proxy",
        "network": "tcp,udp"
      },
      {
        "type": "field",
        "outboundTag": "direct",
        "ip": ["geoip:private"]
      }
    ]
  },
  "log": {
    "loglevel": "debug"                     # Đổi thành debug để xem lỗi chi tiết
  }
}
EOF

# Run xray client
xray -c /etc/xray/config.json