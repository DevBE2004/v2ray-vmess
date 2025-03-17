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
            "address": "${ADDRESS:-v2ray-vmess.onrender.com}",  # Địa chỉ server VMess riêng, thay bằng địa chỉ của bạn
            "port": ${VPORT:-443},                        # Cổng server VMess, mặc định 443
            "users": [
              {
                "id": "${UUID:-36cfc3de-ecfd-4752-ae6f-8f0f92035143}",  # UUID riêng, thay bằng UUID của bạn
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
          "headers": {
            "Host": "${HOST:-m.youtube.com}"  # Header Host, thay bằng tên miền của bạn
          },
          "path": "${PATH:-/anhtu}"              # Đường dẫn WebSocket, thay nếu cần
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
        "outboundTag": "proxy"                    # Mọi lưu lượng đi qua proxy VMess
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