#!/bin/bash

set -o nounset                              # Treat unset variables as an error
echo "#==============================================================================="
echo "Installing base packages"
echo "#==============================================================================="
sleep 5
yum -y update
echo "group_package_types=mandatory,default,optional" >> /etc/yum.conf
yum -y group install base
echo "#==============================================================================="
echo "Installing the Extra Packages for Enterprise Linux Repository" 
echo "#==============================================================================="
sleep 5
yum -y install epel-release
yum -y update
echo "#==============================================================================="

echo "Installing project specific tools"
echo "#==============================================================================="
sleep 5
yum -y install curl vim wget tmux nmap-ncat tcpdump nmap tmux
echo "#==============================================================================="
echo "Setting Up VirtualBox Guest Additions"
echo "Installing pre-requisites"
echo "#==============================================================================="
sleep 5
yum -y install kernel-devel kernel-headers dkms gcc gcc-c+
echo "#==============================================================================="
echo "Creating mount point, mounting, and installing VirtualBox Guest Additions"
echo "#==============================================================================="
sleep 5
mkdir vbox_cd
mount /dev/cdrom ./vbox_cd
./vbox_cd/VBoxLinuxAdditions.run
umount ./vbox_cd
rmdir ./vbox_cd
echo "#==============================================================================="
echo "Disabling selinux"
echo "#==============================================================================="
sleep 5
setenforce 0
sed -r -i 's/SELINUX=(enforcing|disabled)/SELINUX=permissive/' /etc/selinux/config
echo "#==============================================================================="
echo "Turning off and disabling Network Manager"
echo "#==============================================================================="
sleep 5
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service
echo "#==============================================================================="
echo "Turning off and disabling Firewall Daemon"
echo "#==============================================================================="
sleep 5
systemctl stop firewalld.service
systemctl disable firewalld.service
echo "#==============================================================================="
echo "Enabling and starting the Network Service (ignoring angry messages)"
echo "#==============================================================================="
sleep 5
systemctl enable network.service 
systemctl start network.service
echo "#==============================================================================="
echo "Setting up itrepo User"
echo "#==============================================================================="
sleep 5
useradd -m -G wheel,users itrepo
echo "itrepo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
mkdir ~itrepo/.ssh/
cat > ~itrepo/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnVBM1rij2BCAnWYMndo5PG/0+ngXij1EAiVFkxztCeRT0ACIoAMEIdqBK6waLe9g8Th7ZvyGBJrAVnTORCDLTBmhOqJj57zMKBezFESCEHd35U1/11mUCDe+Hexj6abTu0HJr3k5Bur3XqpvKqKuOWHdcpNZW9nwassTQGYEvsBE/Fxzzz8atWV6kXF8LjpmySAyUjBBqE+5E6GlTJXvyHbP2x0uMYUm1gu2ZLOilKY3ADB7peiRzNIAsTqtomLJPgSFls6oAadl4fblPxCJ/Ro0beV+WgJs0VYFKwEvO7ix+FIJ6jjRDKpgILpGQWnINhcvose1/6OWlDj9b9mCb instructor@s01rtr
EOF
chown -R itrepo:itrepo ~itrepo/.ssh

