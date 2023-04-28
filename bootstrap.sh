#!/bin/bash

yum update && yum upgrade -y

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.0.11 kafka1
192.168.0.11 zookeeper1
192.168.0.12 kafka2
192.168.0.12 zookeeper2
192.168.0.13 kafka3
192.168.0.13 zookeeper3
EOF

# Disable SELinux
# echo "[TASK 4] Disable SELinux"
# setenforce 0
# sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# # Disable swap
# echo "[TASK 7] Disable and turn off SWAP"
# sed -i '/swap/d' /etc/fstab
# swapoff -a


# Add vagrant user to docker group
#usermod -aG user root > /dev/null 2>&1
