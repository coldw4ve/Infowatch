#! /bin/bash

# Sources list
deb http://download.astralinux.ru/stable/1.7_x86-64/repository-main/     1.7_x86-64 main contrib non-free
deb http://download.astralinux.ru/stable/1.7_x86-64/repository-update/   1.7_x86-64 main contrib non-free
deb http://download.astralinux.ru/stable/1.7_x86-64/repository-base/     1.7_x86-64 main contrib non-free
deb http://download.astralinux.ru/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free
apt update


# Addition to AD 
apt-get install fly-admin-ad-client -y
apt update
fly-admin-ad-client

# TM packages
"Installing additional packages for IWTM..."
apt install lsb-release lshw ntp ntpdate gsfonts libjemalloc2 libnewt0.52 libwmf-bin libwmf0.2-7 libxml2-utils liblzf1 python-newt redis-server redis-tools

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
echo "Max access mode set..."
pdpl-user -i 63 root

mkdir /distr
mv iwtm-installer* /distr
mv iwtm-postgresql* /distr
cd /distr
chmod +x iwtm-installer*

cat << EOF > /etc/systemd/system/rsyslog.service
[Service]
ExecStart=true
ExecStop=true
 
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

# for graphical installation
apt-get install xauth
nano /etc/ssh/sshd_config

# please add X11Forwarding = Yes
systemctl restart sshd

# Cache cleaning
apt-cache show astra-version
apt clean
echo "Cache cleared..."
history -c

./iwtm-installer*


