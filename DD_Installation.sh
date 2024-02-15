#! /bin/bash

# Sources list
echo "Sourcelist update"
astraVersion=$(cat /etc/astra_version)
echo "deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/$astraVersion/repository-base/ 1.7_x86-64 main contrib non-free" > /etc/apt/sources.list
echo "deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/$astraVersion/repository-extended/ 1.7_x86-64 contrib main non-free " >> /etc/apt/sources.list
echo "deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/$astraVersion/repository-main/ 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list
apt update

# Addition to AD 
apt-get install fly-admin-ad-client -y
apt update
fly-admin-ad-client

# /etc/hosts change
echo "Working with the /etc/hosts file..."
echo "Enter domain: "; read ADdomain
urIP=$(ifconfig eth0 | awk '/inet / {split($2, a, ":"); print a[1]}')
hostname=$(hostname)
newEntry="$urIP $hostname.$ADdomain $hostname"
sed -i "2s/.*/$newEntry/" /etc/hosts
echo "Done!"

# SSH
systemctl start ssh && systemctl enable ssh
echo "The SSH service will be start and added to autostart"

# conntrack, socat
apt install conntrack -y
apt install socat -y
echo "Success!"

# Sorting IWDD files
mkdir IWDD/
read -p "Enter the unpucking folder name (without extension)" unpuckingFolder
unzip "$unpuckingFolder".zip 
mv $unpuckingFolder/iw_discovery_setup* /home/iwdm/IWDD
cd IWDD
tar -xvf iw_discovery_setup*
./setup.py install

