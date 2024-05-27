#!/bin/bash

# Update system repositories and packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install nginx
sudo apt-get install nginx -y

# Clone application from GitHub into the nginx web directory
# given my application GitHub repository information
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/yashvikothari/yashvikothari-devportfolio.git /var/www/html/

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Node Exporter for Prometheus monitoring
# Ensure to replace "v*" with the actual version of Node Exporter you wish to use
#wget #https://github.com/prometheus/node_exporter/releases/download/v*/node_exp#orter-*.*-linux-amd64.tar.gz

wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz

tar xvf node_exporter-1.8-linux-amd64.tar.gz
cd node_exporter-1.8
sudo cp node_exporter /usr/local/bin

# Create a systemd service file for Node Exporter
echo "[Unit]
Description=Node Exporter

[Service]
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/node_exporter.service

# Reload systemd, enable and start Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter.service
sudo systemctl start node_exporter.service