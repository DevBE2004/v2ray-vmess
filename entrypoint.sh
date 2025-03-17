#!/bin/sh

# Config xray client
rm -rf /etc/xray/config.json
cat << EOF > /etc/xray/config.json
{
  "inbounds": [
    {
      "port": ${PORT:-1080},                    # Cổng SOCKS local, mặc định 1080
      "protocol": "socks",
      "settings": {
        "auth": "noauth",                      # Không yêu cầu xác thực
        "udp": true,                           # Hỗ trợ UDP
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
            "address": "${ADDRESS:-ws-ecw0.onrender.com}",  # Địa chỉ server VMess
            "port": ${VPORT:-443},                        # Cổng server VMess, mặc định 443
            "users": [
              {
                "id": "${UUID:-36cfc3de-ecfd-4752-ae6f-8f0f92035143}",  # UUID
                "level": 8,
                "security": "auto"                  # Mã hóa tự động
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",                          # Sử dụng WebSocket
        "wsSettings": {
          "host": "${HOST:-m.youtube.com}",       # Chuyển Host ra ngoài headers để tránh cảnh báo deprecated
          "path": "${PATH:-/anhtu}"               # Đường dẫn WebSocket
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
        "outboundTag": "proxy",                 # Mọi lưu lượng TCP/UDP qua proxy
        "network": "tcp,udp"
      },
      {
        "type": "field",
        "outboundTag": "direct",                # IP nội bộ đi trực tiếp
        "ip": ["geoip:private"]
      }
    ]
  },
  "log": {
    "loglevel": "warning"
  }
}
EOF

# Run xray client
xray -c /etc/xray/config.json