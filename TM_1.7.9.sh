#! /bin/bash

# Sources list
echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free" > /etc/apt/sources.list
echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list
echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list
echo "deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free" >> /etc/apt/sources.list
apt update

## If youre use VMWare install VMWare Tools automatically
mkdir /mnt/vmware
mount /dev/cdrom /mnt/vmware
cp /mnt/vmware/VMwareTools-*.tar.gz /tmp/
cd /tmp
tar -xzf VMwareTools-*.tar.gz
./vmware-tools-distrib/vmware-install.pl 
cd /home/*

# TM packages
apt install lsb-release lshw ntp ntpdate gsfonts libjemalloc2 libnewt0.52 libwmf-bin libwmf0.2-7 libxml2-utils liblzf1 python-newt redis-server redis-tools

# /etc/hosts change
echo "Enter domain: "; read ADdomain
urIP=$(ifconfig eth0 | awk '/inet / {split($2, a, ":"); print a[1]}')
hostname=$(hostname)
newEntry="$urIP $hostname.$ADdomain $hostname"
sed -i "2s/.*/$newEntry/" /etc/hosts

# SSH
systemctl start ssh && systemctl enable ssh

# Mandate regime
pdpl-user -i 63 root

# TM files movement
7z e *.zip
mkdir /distr/
mv iwtm* /distr/
mv opt_packages/ /distr/
cd /distr/
rm -rf *.md5
rm -rf *.sha256
chmod +x iwtm-installer-*

# /etc/systemd/system/rsyslog.service file editing
cat << EOF > /etc/systemd/system/rsyslog.service
[Service]
ExecStart=true
ExecStop=true
 
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

# SSH
systemctl enable sshd && systemctl start sshd

# Cache cleaning
apt clean

./iwtm-installer*


