FROM v2fly/v2ray-core:latest

# Set timezone for the container
ENV TZ=Asia/Colombo

# Set working directory
WORKDIR /etc/v2ray

# Add entrypoint script
ADD entrypoint.sh /entrypoint.sh

# Grant execution permissions to the script
RUN chmod +x /entrypoint.sh

# Define the entrypoint
ENTRYPOINT ["/entrypoint.sh"]