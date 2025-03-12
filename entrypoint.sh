#!/bin/sh

# Config xray

rm -rf /etc/xray/config.json
cat << EOF > /etc/xray/config.json
{
  "inbounds": [
    {
      "port": ${PORT:-443},
      "protocol": "vless",
      "settings": {
        "decryption": "none",
        "clients": [
          {
            "id": "${UUID:-36cfc3de-ecfd-4752-ae6f-8f0f92035143}"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "serverName": "${SNI:-m.tiktok.com}",
          "alpn": ["http/1.1"]
        },
        "tcpSettings": {
          "header": {
            "type": "http",
            "response": {
              "version": "1.1",
              "status": "200",
              "reason": "OK",
              "headers": {
                "Content-Type": "text/plain",
                "Connection": "keep-alive",
                "Server": "Xray"
              }
            }
          }
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Run xray
exec /usr/bin/xray -c /etc/xray/config.json