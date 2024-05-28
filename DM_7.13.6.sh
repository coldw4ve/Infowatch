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

echo "Enter domain: "; read ADdomain
urIP=$(ifconfig eth0 | awk '/inet / {split($2, a, ":"); print a[1]}')
hostname=$(hostname)
newEntry="$urIP $hostname.$ADdomain $hostname"
sed -i "2s/.*/$newEntry/" /etc/hosts
echo "Done!"

# SSH
systemctl start ssh && systemctl enable ssh

apt install ca-certificates apt-transport-https -y

# Dotnet
wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null 
wget https://packages.microsoft.com/config/debian/10/prod.list -O /etc/apt/sources.list.d/microsoft-prod.list 
apt update 
apt install dotnet-aspnetcore-runtime-6.0 -y
dotnet --info


# conntrack, socat
apt install conntrack -y
apt install socat -y
echo "Success!"
apt update

apt install python2.7
apt install python-modules-json
apt install python-modules-distutils
apt install python-modules-sqlite3

nano /etc/openssl/openssl.cnf 

# Console installation
mkdir /dm
mv iw_devicemonitor_setup* /dm
cd /dm
tar xvf iw_devicemonitor_setup*
python2 ./setup.py install
kubectl get pods -n infowatch 
kubectl get configmap nginx-config -o yaml -n infowatch > n.yaml
nano n.yaml
kubectl apply -f n.yaml
kubectl rollout restart deployment webgui-central -n infowatch

# Server Installation 



