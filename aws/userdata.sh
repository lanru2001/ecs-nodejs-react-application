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

#  Bash script to install Jenkins on AWS EC2 

sudo yum -y update

echo "Install Java JDK 8"

sudo yum remove -y java

sudo yum install -y java-1.8.0-openjdk

echo "Install Maven"

sudo yum install -y maven 

echo "Install git"

sudo yum install -y git

echo "Install Docker engine"

sudo yum update -y

sudo yum install docker -y

sudo sudo chkconfig docker on

#Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo yum install jenkins -y
sudo systemctl daemon-reload

echo "Start Docker & Jenkins services"

sudo service docker start

sudo service jenkins start
