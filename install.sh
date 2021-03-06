#!/bin/bash

#Always update your dist repo first
sudo apt-get update

#Installing MongoDB 4.4
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update
sudo apt-get -y install mongodb-org
sudo systemctl start mongod.service
sudo systemctl enable mongod
#export test=$(mongo --eval 'db.runCommand({ connectionStatus: 1 })')
#if [ "$test"  ]

## Installing OpenSSL packages if not installed
sudo apt-get install -y openssl

#Installing Redis Server
sudo apt-get install -y redis-server
export pw=$(openssl rand 60 | openssl base64 -A)
sudo echo 'supervised systemd' >> /etc/redis/redis.conf
sudo echo 'bind 127.0.0.1 ::1' >> /etc/redis/redis.conf
sudo echo 'requirepass '"$pw" >> /etc/redis/redis.conf
sudo systemctl restart redis.service

#Logging basic IP details DO Specific
export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
export USER_DATA=$(curl http://169.254.169.254/metadata/v1/user-data)
echo Droplet: $HOSTNAME, IP Address: $PUBLIC_IPV4, Redis_password: $pw > /etc/server_index.html
echo USER_DATA: >> /etc/server_index.html
echo $USER_DATA >> /etc/server_index.html
