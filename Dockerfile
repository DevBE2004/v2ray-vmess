FROM v2ray/official:latest
ENV TZ=Asia/Colombo
WORKDIR /etc/v2ray
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]