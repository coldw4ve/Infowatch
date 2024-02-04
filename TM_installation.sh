#! /bin/bash

# Sources list
echo "Sourcelist update"
astraVersion=$(cat /etc/astra_version)
echo "deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/$astraVersion/repository-base/ 1.7_x86-64 main contrib non-free" > /etc/apt/sources.list
echo "deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/$astraVersion/repository-main/ 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list
apt update
cat /etc/apt/sources.list
echo "Done!"

# Addition to AD 
apt-get install fly-admin-ad-client -y
apt update
fly-admin-ad-client

# TM packages
"Installing additional packages for IWTM..."
if apt-get install lsb-release lshw ntp ntpdate gsfonts libnewt0.52 libwmf-bin libwmf0.2-7 libxml2-utils python-newt -y; then echo "Доп пакеты для IWTM успешно установлены"; else echo "Ошибка"; fi;

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

# Mandate regime
pdpl-user -i 63 root
echo "Max access mode set..."

# Cache cleaning
apt-cache show astra-version
apt clean
echo "Cache cleared..."

# Installation
echo "Moving and start IWTM-installer files..."
mkdir IWTM
mv iwtm-* IWTM/
cd IWTM
chmod +x iwtm-installer-7.7.2.136-astra-smolensk-1.7
./iwtm-installer-7.7.2.136-astra-smolensk-1.7
