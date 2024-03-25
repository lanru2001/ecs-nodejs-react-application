#!/bin/bash

#Install basic packages and set SELinux to permissive
sudo yum  -y update
sudo yum install -y vim bash-completion curl wget tar telnet
sudo setstatus
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

# Shell script for installing Java, Jenkins and Maven in Ubuntu EC2 instance
sudo yum -y install wget
sudo yum -y install git

#Install aws cli

# Install the latest system updates.
sudo yum -y update
# Install the AWS CLI
sudo yum -y install aws-cli
# Confirm the AWS CLI was installed.
 aws --version

#Install Maven"
sudo yum install -y maven

#Install git
sudo yum install -y git

# simple script to install Docker on RedHat Linux/CentOS

#Remove Podman container
dnf remove -y podman buildah

#Install yum-utils package
dnf install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo


#Install the official latest community edition
dnf install -y docker-ce
sudo yum makecache
sudo dnf -y  install docker-ce --nobest

#Enable and start Docker Daemon
sudo systemctl start  docker
sudo systemctl enable docker

#Run docker with privilege without a sudo
sudo usermod -aG docker $USER

#Bash script to install Jenkins on AWS EC2

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-17-openjdk -y
sudo yum install jenkins
sudo systemctl daemon-reload
sudo systemctl start jenkins
