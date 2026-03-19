#!/bin/bash

sed -i 's/^#Port 22$/Port 22222/' /etc/ssh/sshd_config
sed -i 's/^Port 22$/Port 22222/' /etc/ssh/sshd_config
systemctl restart ssh

set -e

apt-get update
apt-get upgrade -y

apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl start docker
systemctl enable docker

echo "root:x:test1234" > userdb.txt

mkdir -p /opt/cowrie/logs
sudo chown -R 999:1000 /opt/cowrie/logs

docker pull cowrie/cowrie:latest
docker run -d --name cowrie --restart always -p 22:2222 -v $(pwd)/userdb.txt:/cowrie/cowrie-git/etc/userdb.txt:ro -v /opt/cowrie/logs:/cowrie/cowrie-git/var/log/cowrie cowrie/cowrie:latest

sudo chmod 755 /opt/cowrie /opt/cowrie/logs
sudo chmod 644 /opt/cowrie/logs/cowrie.json

echo "Docker and Cowrie honeypot installation complete"