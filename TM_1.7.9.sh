#! /bin/bash

# Sources list

apt update


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
mv iwtm* /distr
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

systemctl enable sshd && systemctl start sshd

# Cache cleaning
apt-cache show astra-version
apt clean
echo "Cache cleared..."

./iwtm-installer*


