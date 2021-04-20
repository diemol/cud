#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/diemol/cud/main/cud.sh -o cud.sh
# chmod +x cud.sh && ./cud.sh

# Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Allowing ubuntu user to run docker
sudo usermod -aG docker ubuntu

# https://ubuntu.com/tutorials/ubuntu-desktop-aws#1-overview
# Install desktop and VNC
sudo apt update
sudo apt install ubuntu-desktop -y
sudo apt install tightvncserver -y
# Fixes copy & paste to VNC https://askubuntu.com/questions/41273/how-to-copy-paste-text-from-remote-system
sudo apt-get install autocutsel -y
sudo apt install gnome-panel gnome-settings-daemon metacity nautilus -y

# Install VSCode
sudo apt update
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code -y

# Update Python
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.9 -y
python3.9 --version

# Start VNC to generate configuration
mkdir -p ${HOME}/.vnc
MY_PWD="saucecon"
echo $MY_PWD | vncpasswd -f > ${HOME}/.vnc/passwd
chmod 0600 ${HOME}/.vnc/passwd

# Start VNC Server to generate config
vncserver :1

# Replace ~/.vnc/xstartup contents
curl -fsSL https://raw.githubusercontent.com/diemol/cud/main/xstartup -o ${HOME}/.vnc/xstartup

# Stop & start VNC 
vncserver -kill :1
vncserver :1 -geometry 1280x1024

# Start VNC after reboot
# https://linuxconfig.org/vnc-server-on-ubuntu-20-04-focal-fossa-linux
sudo curl -fsSL https://raw.githubusercontent.com/diemol/cud/main/vncserver.service -o /etc/systemd/system/vncserver@.service
sudo systemctl daemon-reload
sudo systemctl enable vncserver@1

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

########################################
# noVNC exposes VNC through a web page #
########################################
# https://github.com/novnc/noVNC#running-as-a-service-daemon
sudo snap install novnc
sudo snap set novnc services.n7901.listen=7901 services.n7901.vnc=localhost:5901

echo "Installation completed"

sudo reboot

