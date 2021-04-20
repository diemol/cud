#!/bin/bash

# curl -fsSL https://raw.githubusercontent.com/diemol/cud/main/cud.sh -o cud.sh
# chmod +x cud.sh && ./cud.sh

# Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Allowing ubuntu user to run docker
sudo usermod -aG docker ubuntu

# Install desktop and VNC
sudo apt update
sudo apt install ubuntu-desktop -y
sudo apt install tightvncserver -y
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
sudo curl -fsSL https://raw.githubusercontent.com/diemol/cud/main/vncserver.service -o /etc/systemd/system/vncserver@.service
sudo systemctl daemon-reload
sudo systemctl enable vncserver@1

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

########################################
# noVNC exposes VNC through a web page #
########################################
# Download https://github.com/novnc/noVNC dated 2021-03-30 commit 84f102d6a9ffaf3972693d59bad5c6fddb6d7fb0
# Download https://github.com/novnc/websockify dated 2021-03-22 commit c5d365dd1dbfee89881f1c1c02a2ac64838d645f
NOVNC_SHA="84f102d6a9ffaf3972693d59bad5c6fddb6d7fb0"
WEBSOCKIFY_SHA="c5d365dd1dbfee89881f1c1c02a2ac64838d645f"
wget -nv -O noVNC.zip "https://github.com/novnc/noVNC/archive/${NOVNC_SHA}.zip"
unzip -x noVNC.zip
mv noVNC-${NOVNC_SHA} ${HOME}/noVNC
cp ${HOME}/noVNC/vnc.html ${HOME}/noVNC/index.html
rm noVNC.zip
wget -nv -O websockify.zip "https://github.com/novnc/websockify/archive/${WEBSOCKIFY_SHA}.zip"
unzip -x websockify.zip
rm websockify.zip
mv websockify-${WEBSOCKIFY_SHA} ${HOME}/noVNC/utils/websockify

# ${HOME}/noVNC/utils/launch.sh --listen 7901 --vnc localhost:5901 &

echo "Installation completed"

