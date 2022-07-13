#!/bin/bash
sudo apt -y install ca-certificates curl gnupg lsb-release;
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update &&
sudo apt -y install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER


#docker ps

#https://losst.ru/ustanovka-docker-v-debian-11
#sudo systemctl start docker
#sudo systemctl enable docker