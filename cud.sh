#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/diemol/cud/main/cud.sh -o cud.sh
# chmod +x cud.sh && ./cud.sh

# Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh && ./get-docker.sh

# Allowing ubuntu user to run docker
sudo usermod -aG docker ubuntu
newgrp docker

# Install desktop and VNC
sudo apt update
sudo apt install ubuntu-desktop -y
sudo apt install tightvncserver -y
sudo apt install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal -y

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
MY_USER="ubuntu"
echo $MY_PWD | vncpasswd -f > /home/$MY_USER/.vnc/passwd
chmod 0600 /home/$MY_USER/.vnc/passwd

# Start VNC Server to generate config
vncserver :1

# Replace ~/.vnc/xstartup contents
curl -fsSL https://raw.githubusercontent.com/diemol/cud/main/xstartup -o /home/$MY_USER/.vnc/xstartup

# Stop & start VNC 
vncserver -kill :1
vncserver :1 -geometry 1280x1024

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


echo "Installation completed"

