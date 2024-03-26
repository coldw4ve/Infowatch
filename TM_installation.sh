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
if apt-get install lsb-release lshw ntp ntpdate gsfonts libnewt0.52 libwmf-bin libwmf0.2-7 libxml2-utils python-newt -y; then echo "Additional packages for IWTM installed successfully"; else echo "Ooops, error"; fi;

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


# IPv6 blocking
([0-9|a-f|A-F]{0,4}):([0-9|a-f|A-F]{0,4}):([0-9|a-f|A-F]{0,4}):([0-9|a-f|A-F]{0,4}):([0-9|a-f|A-F]{0,4}):([0-9|a-f|A-F]{0,4}):([0-9|a-f|A-F]{0,4}):([0-9|a-f|A-F]{0,4})(/([0-9]|[0-9]\d))


# when you must blocking some transport numbers (for example ДГВБА-321/Л)
[А-я|Ё|ё]{5}-([0-9]|[1-9]\d|1\d{2}|2(([0-2]|[4-9])\d|3([0-2]|[4-9]))|3(([0-1]|[3-9])\d|2([0]|[2-9]))|[4-7]\d{2}|800)/[А-Я|Ё]{1,4}


      # blocking some numbers starting with M
      [А|В|Е|К|Н|О|Р|С|Т|У|Х]\d{3}\D{2}(102|02|702)
      
      # without 333
      М([0-2]\d{2}|3(([0-2]|[4-9])\d|3([0-2]|[4-9]))|[4-9]\d{2})\D{2}(102|02|702)
      
      # when number starting with M333
      М333([В|Е|К|М|Н|О|Р|С|Т|У|Х]{2}|(ОА)|[А|В|Е|К|М|Н|Р|С|Т|У|Х]{2})(102|02|702)
      
      # for M333AO numbers and without 102
      М333АО(02|702)

# if you want to exclude some word with different cases (for example: Wednesday)
[Ww]ednesday
